import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Opens and migrates the local SQLite database used for offline auth,
/// per-user station progress, and assessment scores.
class DbService {
  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    final dir = await getDatabasesPath();
    final path = p.join(dir, 'bioquest.db');
    _db = await openDatabase(
      path,
      version: 6,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return _db!;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        display_name TEXT NOT NULL DEFAULT '',
        password_hash TEXT NOT NULL,
        avatar_id INTEGER NOT NULL DEFAULT 0,
        avatar_chosen INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE progress (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        station_key TEXT NOT NULL,
        status TEXT NOT NULL,
        mission_score INTEGER NOT NULL DEFAULT 0,
        checkpoint_score INTEGER NOT NULL DEFAULT 0,
        badge_earned INTEGER NOT NULL DEFAULT 0,
        discovery_complete INTEGER NOT NULL DEFAULT 0,
        takeaway_complete INTEGER NOT NULL DEFAULT 0,
        updated_at TEXT NOT NULL,
        UNIQUE(user_id, station_key)
      )
    ''');
    await db.execute('''
      CREATE TABLE assessments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        test_key TEXT NOT NULL,
        score INTEGER NOT NULL,
        total INTEGER NOT NULL,
        taken_at TEXT NOT NULL
      )
    ''');
    await _createAppSettingsTable(db);
  }

  Future<void> _createAppSettingsTable(Database db) async {
    await db.execute('''
      CREATE TABLE app_settings (
        key TEXT PRIMARY KEY NOT NULL,
        value TEXT NOT NULL
      )
    ''');
  }

  /// Persists a key/value pair for offline session and app state.
  Future<void> setSetting(String key, String value) async {
    final db = await database;
    await db.insert(
      'app_settings',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getSetting(String key) async {
    final db = await database;
    final rows = await db.query(
      'app_settings',
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return rows.first['value'] as String;
  }

  Future<void> removeSetting(String key) async {
    final db = await database;
    await db.delete('app_settings', where: 'key = ?', whereArgs: [key]);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        "ALTER TABLE users ADD COLUMN display_name TEXT NOT NULL DEFAULT ''",
      );
      await db.execute(
        'UPDATE users SET display_name = username WHERE display_name = ""',
      );
    }
    if (oldVersion < 3) {
      await db.execute(
        'ALTER TABLE users ADD COLUMN avatar_chosen INTEGER NOT NULL DEFAULT 0',
      );
      await db.execute('''
        UPDATE users SET avatar_chosen = 1
        WHERE id IN (
          SELECT user_id FROM assessments WHERE test_key = 'pretest'
        )
      ''');
    }
    if (oldVersion < 4) {
      await db.execute(
        'ALTER TABLE progress ADD COLUMN discovery_complete INTEGER NOT NULL DEFAULT 0',
      );
      await db.execute('''
        UPDATE progress SET discovery_complete = 1
        WHERE mission_score > 0 OR checkpoint_score > 0
      ''');
    }
    if (oldVersion < 5) {
      await _createAppSettingsTable(db);
    }
    if (oldVersion < 6) {
      await db.execute(
        'ALTER TABLE progress ADD COLUMN takeaway_complete INTEGER NOT NULL DEFAULT 0',
      );
    }
  }
}
