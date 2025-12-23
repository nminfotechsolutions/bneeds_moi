// lib/data/repositories/function_repository.dart

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/service/dio_service.dart';
import '../models/function_model.dart';

final functionRepositoryProvider = Provider<FunctionRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return FunctionRepository(dio: dio);
});

class FunctionRepository {
  final Dio _dio;

  FunctionRepository({required Dio dio}) : _dio = dio;

  Future<List<FunctionModel>> getFunctionDetails(String cloudId) async {
    try {
      // ✨ முக்கிய மாற்றம்: முழுமையான இறுதிப் புள்ளிப் பெயரைச் சேர்க்கவும்
      final response = await _dio.get(
        'Function/Functiondet', // 'Function/' என்பதை இங்கே சேர்க்கவும்
        queryParameters: {
          'action': 'G',
          'cloudid': cloudId,
        },
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => FunctionModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load function details: ${response.data['message']}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
