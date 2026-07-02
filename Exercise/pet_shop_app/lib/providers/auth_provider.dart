import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../data/mock_data.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  List<User> _users = List.from(MockData.users);
  bool _rememberMe = false;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get rememberMe => _rememberMe;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    
    final mockUsersStr = prefs.getString('mock_users');
    if (mockUsersStr != null) {
      try {
        final List<dynamic> decoded = json.decode(mockUsersStr);
        final loadedUsers = decoded.map((item) => User.fromMap(item)).toList();
        
        for (var mockUser in MockData.users) {
          if (!loadedUsers.any((u) => u.email == mockUser.email)) {
            loadedUsers.add(mockUser);
          }
        }
        _users = loadedUsers;
      } catch (e) {
        _users = List.from(MockData.users);
      }
    }

    _rememberMe = prefs.getBool('remember_me') ?? false;
    if (_rememberMe) {
      final email = prefs.getString('user_email');
      if (email != null) {
        try {
          _currentUser = _users.firstWhere((u) => u.email == email);
        } catch (e) {
          _currentUser = null;
        }
      }
    }
    notifyListeners();
  }

  Future<void> _saveUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(_users.map((u) => u.toMap()).toList());
    await prefs.setString('mock_users', encoded);
  }

  Future<bool> login(String email, String password, bool rememberMe) async {
    try {
      final user = _users.firstWhere((u) => u.email == email && u.password == password);
      _currentUser = user;
      _rememberMe = rememberMe;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('remember_me', rememberMe);
      if (rememberMe) {
        await prefs.setString('user_email', email);
      } else {
        await prefs.remove('user_email');
      }

      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(String fullName, String email, String password) async {
    if (_users.any((u) => u.email == email)) {
      return false; // Email already exists
    }
    final newUser = User(
      id: DateTime.now().toString(),
      fullName: fullName,
      email: email,
      password: password,
      role: 'user',
    );
    _users.add(newUser);
    await _saveUsers(); 
    
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_email');
    await prefs.setBool('remember_me', false);
    notifyListeners();
  }
}
