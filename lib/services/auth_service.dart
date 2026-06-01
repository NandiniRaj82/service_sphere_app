// ─────────────────────────────────────────────────────────────────────────────
// Auth Service — Service Sphere (Mock / Local Implementation)
// Simulates Firebase Auth behavior with SharedPreferences persistence
// ─────────────────────────────────────────────────────────────────────────────

import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'mock_data_service.dart';

class AuthService {
  static const _keyUserId    = 'ss_user_id';
  static const _keyUserEmail = 'ss_user_email';
  static const _keyUserRole  = 'ss_user_role';

  // ── Login ──────────────────────────────────────────────────────────────────
  Future<UserModel> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800)); // simulate network

    final account = MockDataService.demoAccounts.firstWhere(
      (a) => a['email'] == email.trim() && a['password'] == password,
      orElse: () => {},
    );

    if (account.isEmpty) {
      throw AuthException('Invalid email or password. Try the demo credentials.');
    }

    final user = _findUser(email.trim(), account['role'] as String);
    await _persistSession(user);
    return user;
  }

  // ── Signup ─────────────────────────────────────────────────────────────────
  Future<UserModel> signup({
    required String name,
    required String email,
    required String password,
    required String phone,
    required UserRole role,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    // Check if email already registered
    final allEmails = [
      ...MockDataService.users.map((u) => u.email),
      ...MockDataService.providers.map((u) => u.email),
      MockDataService.adminUser.email,
    ];
    if (allEmails.contains(email.trim())) {
      throw AuthException('An account with this email already exists.');
    }

    final newUser = UserModel(
      id: 'u_new_${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim(),
      email: email.trim(),
      phone: phone.trim(),
      role: role,
      isActive: true,
      createdAt: DateTime.now(),
    );

    await _persistSession(newUser);
    return newUser;
  }

  // ── Forgot Password ─────────────────────────────────────────────────────────
  Future<void> sendPasswordReset(String email) async {
    await Future.delayed(const Duration(milliseconds: 800));
    // In production this would send a Firebase reset email
    // For mock: we just simulate success
  }

  // ── Logout ─────────────────────────────────────────────────────────────────
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyUserEmail);
    await prefs.remove(_keyUserRole);
  }

  // ── Restore Session ────────────────────────────────────────────────────────
  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(_keyUserId);
    final email  = prefs.getString(_keyUserEmail);
    final role   = prefs.getString(_keyUserRole);

    if (userId == null || email == null || role == null) return null;

    try {
      final userRole = UserRole.values.firstWhere((r) => r.name == role);
      return _findUserById(userId, userRole) ??
          UserModel(
            id: userId, name: 'User', email: email, phone: '',
            role: userRole, createdAt: DateTime.now(),
          );
    } catch (_) {
      return null;
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  UserModel _findUser(String email, String role) {
    if (role == 'admin') return MockDataService.adminUser;
    if (role == 'provider') {
      return MockDataService.providers.firstWhere(
        (p) => p.email == email,
        orElse: () => throw AuthException('Provider not found.'),
      );
    }
    return MockDataService.users.firstWhere(
      (u) => u.email == email,
      orElse: () => throw AuthException('User not found.'),
    );
  }

  UserModel? _findUserById(String id, UserRole role) {
    try {
      if (role == UserRole.admin) return MockDataService.adminUser;
      if (role == UserRole.provider) {
        return MockDataService.providers.firstWhere((p) => p.id == id);
      }
      return MockDataService.users.firstWhere((u) => u.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> _persistSession(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserId, user.id);
    await prefs.setString(_keyUserEmail, user.email);
    await prefs.setString(_keyUserRole, user.role.name);
  }
}

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);
  @override
  String toString() => message;
}
