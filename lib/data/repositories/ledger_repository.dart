// lib/data/repositories/ledger_repository.dart

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/service/dio_service.dart';
import '../models/ledger_model.dart'; // ✨ புதிய மாடலை import செய்யவும்

// LedgerRepository-ஐ வழங்குவதற்கான Provider
final ledgerRepositoryProvider = Provider<LedgerRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return LedgerRepository(dio: dio);
});

class LedgerRepository {
  final Dio _dio;
  LedgerRepository({required Dio dio}) : _dio = dio;

  // Ledger விவரங்களைப் பெறும் முறை
  Future<List<LedgerViewModel>> getLedgerView(String cloudId) async {
    try {
      final response = await _dio.get(
        'ledgerview/ledgerview', // API endpoint
        queryParameters: {
          'action': 'G',
          'cloudid': cloudId,
        },
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => LedgerViewModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load ledger view');
      }
    } on DioException catch (e) {
      throw Exception('Network Error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
