// lib/data/repositories/collection_repository.dart

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/service/dio_service.dart';
import '../models/collection_model.dart';
import '../models/new_entry_model.dart'; // புதிய மாடலை import செய்யவும்

final collectionRepositoryProvider = Provider<CollectionRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return CollectionRepository(dio: dio);
});

class CollectionRepository {
  final Dio _dio;
  CollectionRepository({required Dio dio}) : _dio = dio;

  // ஏற்கனவே உள்ள முறை
  Future<List<CollectionModel>> getCollectionDetails(String cloudId) async {
    // ... (இந்தக் குறியீடு அப்படியே இருக்கும்)
    try {
      final response = await _dio.get(
        'CollectionDet/Collectiondet',
        queryParameters: {'action': 'G', 'cloudid': cloudId},
      );
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => CollectionModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load collection details');
      }
    } catch (e) {
      rethrow;
    }
  }

  // ✨ படி 2: புதிய பதிவை உருவாக்கும் புதிய முறை
  Future<void> createCollectionEntry(NewEntryModel entry) async {
    try {
      // API-க்கு அனுப்ப வேண்டிய JSON body-ஐ உருவாக்குதல்
      final Map<String, dynamic> requestBody = {
        "Entrydet": [entry.toJson()]
      };

      final response = await _dio.post(
        'CollectionEntry/CollectionEntryApi',
        queryParameters: {'action': 'I'},
        data: requestBody, // data παραμέτρος-இல் body-ஐ அனுப்பவும்
      );

      // POST கோரிக்கை வெற்றிகரமாக உள்ளதா என சரிபார்த்தல்
      if (response.statusCode == 200 || response.statusCode == 201) {
        // பொதுவாக, POST கோரிக்கை வெற்றிகரமாக இருந்தால், பதில் இருக்காது அல்லது ஒரு வெற்றிச் செய்தி இருக்கும்.
        // இங்கே நீங்கள் எதுவும் செய்யத் தேவையில்லை.
        print('Entry created successfully: ${response.data}');
      } else {
        throw Exception('Failed to create entry: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Network Error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
