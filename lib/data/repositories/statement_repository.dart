// lib/data/repositories/statement_repository.dart

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/service/dio_service.dart';
import '../models/statement_model.dart';

// StatementRepository-ஐ வழங்குவதற்கான Provider
final statementRepositoryProvider = Provider<StatementRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return StatementRepository(dio: dio);
});

// தேடல் παραμέτρος-களை வைத்திருக்க ஒரு வகுப்பு
class StatementSearchParams {
  final String? cityName;
  final String? functionName;
  final String? member;

  StatementSearchParams({this.cityName, this.functionName, this.member});
}

class StatementRepository {
  final Dio _dio;
  StatementRepository({required Dio dio}) : _dio = dio;

  // Statement விவரங்களைப் பெறும் முறை
  Future<StatementResponse> getStatements({
    required String cloudId,
    StatementSearchParams? params, // விருப்பத்திற்கேற்ப தேடல் παραμέτρος-கள்
  }) async {
    try {
      // queryParameters-ஐ உருவாக்குதல்
      final Map<String, dynamic> queryParameters = {
        'action': 'BV',
        'cloudid': cloudId,
      };

      // அனுப்பப்பட்ட παραμέτρος-களை மட்டும் query-இல் சேர்க்கவும்
      if (params?.cityName != null && params!.cityName!.isNotEmpty) {
        queryParameters['cityname'] = params.cityName;
      }
      if (params?.functionName != null && params!.functionName!.isNotEmpty) {
        queryParameters['functionname'] = params.functionName;
      }
      if (params?.member != null && params!.member!.isNotEmpty) {
        queryParameters['member'] = params.member;
      }

      final response = await _dio.get(
        'Statement/statementview', // API endpoint
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return StatementResponse.fromJson(response.data);
      } else {
        throw Exception(
          'Failed to load statements: ${response.data['message']}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Network Error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
