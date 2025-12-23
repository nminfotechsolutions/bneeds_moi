// lib/data/repositories/auth_repository.dart

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/service/dio_service.dart';
import '../models/user_model.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(dio: ref.watch(dioProvider));
});

class AuthRepository {
  final Dio _dio;
  AuthRepository({required Dio dio}) : _dio = dio;

  Future<UserModel> login(String username, String password) async {
    try {
      // ✨ முக்கிய மாற்றம்: முழுமையான இறுதிப் புள்ளிப் பெயரைச் சேர்க்கவும்
      final response = await _dio.get(
        'login/Getlogin', // 'login/' என்பதை இங்கே சேர்க்கவும்
        queryParameters: {
          'action': 'L',
          'username': username,
          'Password': password,
        },
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final userData = response.data['data'][0];
        return UserModel.fromJson(userData);
      } else {
        throw Exception('Login failed: ${response.data['message'] ?? 'Unknown error'}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
