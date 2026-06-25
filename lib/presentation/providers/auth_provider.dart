import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../../data/models/user_model.dart';
import '../../data/services/api_service.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return AuthNotifier(apiService);
});

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;

  AuthState({this.user, this.isLoading = false, this.error});

  AuthState copyWith({UserModel? user, bool? isLoading, String? error}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final ApiService _apiService;

  AuthNotifier(this._apiService) : super(AuthState()) {
    checkAuth();
  }

  Future<void> checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      state = state.copyWith(isLoading: true);
      try {
        final response = await _apiService.get('/user/profile');

        if (response.statusCode == 200) {
          state = state.copyWith(
            user: UserModel.fromJson({...response.data, 'token': token}),
            isLoading: false,
          );
        } else {
          await prefs.remove('token');
          state = state.copyWith(isLoading: false);
        }
      } catch (e) {
        state = state.copyWith(isLoading: false);
      }
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _apiService.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final user = UserModel.fromJson(response.data);
        state = state.copyWith(user: user, isLoading: false);
        _saveToken(user.token!);
      }
    } on DioException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.response?.data['message'] ?? 'Login failed',
      );
    }
  }

  Future<void> register(String name, String email, String phone, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _apiService.post('/auth/register', data: {
        'fullName': name,
        'email': email,
        'phone': phone,
        'password': password
      });

      if (response.statusCode == 201) {
        final user = UserModel.fromJson(response.data);
        state = state.copyWith(user: user, isLoading: false);
        _saveToken(user.token!);
      }
    } on DioException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.response?.data['message'] ?? 'Registration failed',
      );
    }
  }

  Future<bool> updateProfile({
    required String fullName,
    required String phone,
    required String location,
    required String degree,
    required String college,
    required String careerGoal,
    List<String>? skills,
    String? preferredLanguage,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _apiService.put('/user/profile', data: {
        'fullName': fullName,
        'phone': phone,
        'location': location,
        'education': {
          'degree': degree,
          'college': college,
        },
        'careerGoal': careerGoal,
        'skills': skills,
        'preferredLanguage': preferredLanguage,
      });

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        state = state.copyWith(
          user: UserModel.fromJson({...response.data, 'token': token}),
          isLoading: false,
        );
        return true;
      }
      return false;
    } on DioException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.response?.data['message'] ?? 'Update failed',
      );
      return false;
    }
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    state = AuthState();
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }
}
