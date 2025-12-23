// lib/data/repositories/return_repository.dart

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/service/dio_service.dart';
import '../models/new_entry_model.dart';
import '../models/return_details_model.dart';

// ReturnRepository-ஐ வழங்குவதற்கான Provider
final returnRepositoryProvider = Provider<ReturnRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ReturnRepository(dio: dio);
});

class ReturnRepository {
  final Dio _dio;
  ReturnRepository({required Dio dio}) : _dio = dio;

  // பணத்தைத் திரும்பக் கொடுத்தல் பதிவை உருவாக்கும் முறை
  Future<void> createReturnEntry(NewEntryModel entry) async {
    try {
      final Map<String, dynamic> requestBody = {
        "Entrydet": [entry.toJson()]
      };

      final response = await _dio.post(
        'ReturnEntry/ReturnEntryApi', // ✨ Return Entry API endpoint
        queryParameters: {'action': 'I'},
        data: requestBody,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Return Entry created successfully: ${response.data}');
      } else {
        throw Exception('Failed to create return entry: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Network Error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<List<ReturnDetailsModel>> getReturnDetails(String cloudId) async {
    try {
      final response = await _dio.get(
        'ReturnDet/Returndet', // ✨ Return Details API endpoint
        queryParameters: {
          'action': 'G',
          'cloudid': cloudId,
        },
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => ReturnDetailsModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load return details');
      }
    } on DioException catch (e) {
      throw Exception('Network Error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
