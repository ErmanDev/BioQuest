import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import '../data/stations.dart';
import '../data/basecamp_data.dart';
import '../models/station_progress.dart';
import 'db_service.dart';

/// Tracks per-user station unlock state, scores, and earned badges.
class ProgressService extends ChangeNotifier {
  ProgressService(this._db);
  final DbService _db;

  final Map<String, StationProgress> _progress = {};
  int? _userId;
  bool _hasOnboarded = false;

  /// True once this user has taken the pretest.
  bool get hasOnboarded => _hasOnboarded;

  bool get hasTakenPretest => _hasOnboarded;

  StationProgress progressOf(String key) =>
      _progress[key] ?? StationProgress(stationKey: key);

  bool isUnlocked(String key) =>
      progressOf(key).status != StationStatus.locked;

  bool isCompleted(String key) =>
      progressOf(key).status == StationStatus.completed;

  bool hasCompletedDiscovery(String key) {
    final p = progressOf(key);
    return p.discoveryComplete || p.missionScore > 0 || p.checkpointScore > 0;
  }

  bool isMissionUnlocked(String key) => hasCompletedDiscovery(key);

  bool isCheckpointUnlocked(String key) => progressOf(key).takeawayComplete;

  int get completedCount =>
      _progress.values.where((p) => p.status == StationStatus.completed).length;

  List<String> get earnedBadges => kStationOrder
      .where((k) => k != 'summit' && progressOf(k).badgeEarned)
      .toList();

  bool _orientationStepDone(String key) {
    final status = progressOf(key).status;
    return status == StationStatus.completed || status == StationStatus.unlocked;
  }

  bool get hasReadOverview =>
      _orientationStepDone(kOrientationOverviewKey);

  bool get hasReadInstructions =>
      _orientationStepDone(kOrientationInstructionsKey);

  bool get hasReadObjectives =>
      _orientationStepDone(kOrientationObjectivesKey);

  bool get orientationComplete =>
      hasTakenPretest ||
      (hasReadOverview && hasReadInstructions && hasReadObjectives);

  Future<void> markOrientationRead(String key) async {
    if (_orientationStepDone(key)) return;
    await _upsert(key, status: StationStatus.completed);
    notifyListeners();
  }

  /// Clears in-memory progress when the active user logs out.
  void clear() {
    _userId = null;
    _progress.clear();
    _hasOnboarded = false;
    notifyListeners();
  }

  Future<void> loadForUser(int userId) async {
    _userId = userId;
    _progress.clear();
    final db = await _db.database;
    final pretestRows = await db.query(
      'assessments',
      where: 'user_id = ? AND test_key = ?',
      whereArgs: [userId, 'pretest'],
      limit: 1,
    );
    _hasOnboarded = pretestRows.isNotEmpty;
    final rows = await db.query(
      'progress',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    for (final row in rows) {
      final key = row['station_key'] as String;
      _progress[key] = StationProgress(
        stationKey: key,
        status: StationStatus.values.firstWhere(
          (s) => s.name == row['status'],
          orElse: () => StationStatus.locked,
        ),
        missionScore: row['mission_score'] as int,
        checkpointScore: row['checkpoint_score'] as int,
        badgeEarned: (row['badge_earned'] as int) == 1,
        discoveryComplete: (row['discovery_complete'] as int? ?? 0) == 1,
        takeawayComplete: (row['takeaway_complete'] as int? ?? 0) == 1,
      );
    }
    // Station 1 unlocks after the pretest.
    if (_hasOnboarded &&
        (!_progress.containsKey('station1') ||
            _progress['station1']!.status == StationStatus.locked)) {
      await _upsert('station1', status: StationStatus.unlocked);
    }
    notifyListeners();
  }

  Future<void> _upsert(
    String key, {
    StationStatus? status,
    int? missionScore,
    int? checkpointScore,
    bool? badgeEarned,
    bool? discoveryComplete,
    bool? takeawayComplete,
  }) async {
    final current = progressOf(key);
    final updated = StationProgress(
      stationKey: key,
      status: status ?? current.status,
      missionScore: missionScore ?? current.missionScore,
      checkpointScore: checkpointScore ?? current.checkpointScore,
      badgeEarned: badgeEarned ?? current.badgeEarned,
      discoveryComplete: discoveryComplete ?? current.discoveryComplete,
      takeawayComplete: takeawayComplete ?? current.takeawayComplete,
    );
    _progress[key] = updated;
    if (_userId != null) {
      final db = await _db.database;
      await db.insert(
        'progress',
        {
          'user_id': _userId,
          'station_key': key,
          'status': updated.status.name,
          'mission_score': updated.missionScore,
          'checkpoint_score': updated.checkpointScore,
          'badge_earned': updated.badgeEarned ? 1 : 0,
          'discovery_complete': updated.discoveryComplete ? 1 : 0,
          'takeaway_complete': updated.takeawayComplete ? 1 : 0,
          'updated_at': DateTime.now().toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<void> markDiscoveryComplete(String key) async {
    if (hasCompletedDiscovery(key)) return;
    await _upsert(key, discoveryComplete: true);
    notifyListeners();
  }

  Future<void> saveMissionScore(String key, int score) async {
    await _upsert(
      key,
      missionScore: score,
      discoveryComplete: true,
    );
    notifyListeners();
  }

  Future<void> markTakeawayComplete(String key) async {
    if (progressOf(key).takeawayComplete) return;
    await _upsert(key, takeawayComplete: true);
    notifyListeners();
  }

  /// Marks a station complete, awards its badge, and unlocks the next station.
  Future<void> completeStation(String key, int checkpointScore) async {
    await _upsert(
      key,
      status: StationStatus.completed,
      checkpointScore: checkpointScore,
      badgeEarned: true,
    );
    final next = nextStationKey(key);
    if (next != null && progressOf(next).status == StationStatus.locked) {
      await _upsert(next, status: StationStatus.unlocked);
    }
    notifyListeners();
  }

  Future<void> recordAssessment(String testKey, int score, int total) async {
    if (_userId == null) return;
    final db = await _db.database;
    await db.insert('assessments', {
      'user_id': _userId,
      'test_key': testKey,
      'score': score,
      'total': total,
      'taken_at': DateTime.now().toIso8601String(),
    });
    if (testKey == 'pretest') {
      _hasOnboarded = true;
      if (progressOf('station1').status == StationStatus.locked) {
        await _upsert('station1', status: StationStatus.unlocked);
      }
      notifyListeners();
    }
  }
}
