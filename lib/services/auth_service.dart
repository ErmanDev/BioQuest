import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import '../models/app_user.dart';
import 'db_service.dart';

class AuthResult {
  final bool ok;
  final String? error;
  const AuthResult.success() : ok = true, error = null;
  const AuthResult.failure(this.error) : ok = false;
}

/// Offline registration + login backed by SQLite. Passwords are stored as
/// salted SHA-256 hashes. The active session is persisted locally so progress
/// reloads after an app restart.
class AuthService extends ChangeNotifier {
  AuthService(this._db);
  final DbService _db;

  AppUser? _current;
  AppUser? get currentUser => _current;
  bool get isLoggedIn => _current != null;

  static const String _salt = 'bioquest::v1';
  static const String _sessionKey = 'last_user_id';

  String _hash(String password) =>
      sha256.convert(utf8.encode('$_salt::$password')).toString();

  AppUser _userFromRow(Map<String, Object?> row) {
    final storedUsername = row['username'] as String;
    return AppUser(
      id: row['id'] as int,
      username: storedUsername,
      displayName: (row['display_name'] as String?)?.trim().isNotEmpty == true
          ? row['display_name'] as String
          : storedUsername,
      avatarId: row['avatar_id'] as int,
      avatarChosen: (row['avatar_chosen'] as int? ?? 0) == 1,
    );
  }

  Future<void> _persistSession(int userId) =>
      _db.setSetting(_sessionKey, userId.toString());

  Future<void> _clearSession() => _db.removeSetting(_sessionKey);

  /// Restores the last logged-in user from SQLite (no password required).
  Future<bool> restoreSession() async {
    final stored = await _db.getSetting(_sessionKey);
    if (stored == null) return false;
    final userId = int.tryParse(stored);
    if (userId == null) {
      await _clearSession();
      return false;
    }
    final db = await _db.database;
    final rows = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
      limit: 1,
    );
    if (rows.isEmpty) {
      await _clearSession();
      return false;
    }
    _current = _userFromRow(rows.first);
    notifyListeners();
    return true;
  }

  Future<AuthResult> register(
    String username,
    String password,
    String displayName,
  ) async {
    final name = username.trim();
    final shown = displayName.trim();
    if (name.length < 3) {
      return const AuthResult.failure('Username must be at least 3 characters.');
    }
    if (shown.isEmpty) {
      return const AuthResult.failure('Display name is required.');
    }
    if (password.length < 4) {
      return const AuthResult.failure('Password must be at least 4 characters.');
    }
    final db = await _db.database;
    final existing = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [name],
      limit: 1,
    );
    if (existing.isNotEmpty) {
      return const AuthResult.failure('That username is already taken.');
    }
    final id = await db.insert('users', {
      'username': name,
      'display_name': shown,
      'password_hash': _hash(password),
      'avatar_id': 0,
      'avatar_chosen': 0,
      'created_at': DateTime.now().toIso8601String(),
    });
    _current = AppUser(
      id: id,
      username: name,
      displayName: shown,
      avatarId: 0,
      avatarChosen: false,
    );
    await _persistSession(id);
    notifyListeners();
    return const AuthResult.success();
  }

  Future<AuthResult> login(String username, String password) async {
    final name = username.trim();
    final db = await _db.database;
    final rows = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [name],
      limit: 1,
    );
    if (rows.isEmpty) {
      return const AuthResult.failure('No account found with that username.');
    }
    final row = rows.first;
    if (row['password_hash'] != _hash(password)) {
      return const AuthResult.failure('Incorrect password.');
    }
    _current = _userFromRow(row);
    await _persistSession(_current!.id);
    notifyListeners();
    return const AuthResult.success();
  }

  /// Saves the tour-guide avatar once. Returns false if already chosen.
  Future<bool> chooseAvatar(int avatarId) async {
    final user = _current;
    if (user == null || user.avatarChosen) return false;

    final db = await _db.database;
    final updated = await db.update(
      'users',
      {'avatar_id': avatarId, 'avatar_chosen': 1},
      where: 'id = ? AND avatar_chosen = 0',
      whereArgs: [user.id],
    );
    if (updated == 0) return false;

    _current = user.copyWith(avatarId: avatarId, avatarChosen: true);
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _current = null;
    await _clearSession();
    notifyListeners();
  }
}
