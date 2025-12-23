// lib/core/service/dio_service.dart

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// இந்த கோப்பு இனி தேவையில்லை, ஏனெனில் baseUrl பொதுவானதாக மாற்றப்படுகிறது.
// import '../constants/api_endpoints.dart';

// Dio instance-ஐ வழங்குவதற்கான Provider
final dioProvider = Provider<Dio>((ref) {
  // ✨ முக்கிய மாற்றம்: baseUrl-ஐ பொதுவானதாக மாற்றவும்
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://184.168.125.10:3001/api/', // '/login' பகுதியை அகற்றவும்
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        logPrint: (object) {
          debugPrint(object.toString());
        },
      ),
    );
  }

  return dio;
});
