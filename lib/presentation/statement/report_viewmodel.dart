// lib/presentation/statement/report_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
 
import '../../core/utils/shared_prefrences_helper.dart'; // ✨ படி 1: import செய்யவும்
import '../../data/models/statement_model.dart';
import '../../data/repositories/statement_repository.dart';

// தேடல் παραμέτρος-களை நிர்வகிக்க ஒரு provider (இதில் மாற்றம் இல்லை)
final searchParamsProvider = StateProvider<StatementSearchParams>((ref) {
  return StatementSearchParams();
});

// ViewModel-க்கான StateNotifierProvider
final statementViewModelProvider = StateNotifierProvider.autoDispose<
    StatementViewModel, AsyncValue<StatementResponse?>>((ref) {
  final repository = ref.watch(statementRepositoryProvider);

  // ✨ படி 2: SharedPreferences-லிருந்து cloudId-ஐப் பெறவும்
  final cloudId = SharedPrefsHelper.getCloudId() ?? ''; // cloudId கிடைக்கவில்லை என்றால், ખાલી string அனுப்பவும்

  return StatementViewModel(repository, cloudId);
});

class StatementViewModel
    extends StateNotifier<AsyncValue<StatementResponse?>> {
  final StatementRepository _repository;
  final String _cloudId;

  // Controller-கள்
  final cityController = TextEditingController();
  final functionController = TextEditingController();
  final memberController = TextEditingController();

  StatementViewModel(this._repository, this._cloudId)
      : super(const AsyncValue.data(null));

  Future<void> fetchStatements(StatementSearchParams params) async {
    // cloudId காலியாக இருந்தால், API-ஐ அழைக்க வேண்டாம்
    if (_cloudId.isEmpty) {
      state = AsyncValue.error("User not logged in", StackTrace.current);
      return;
    }
    state = const AsyncValue.loading();
    try {
      final response = await _repository.getStatements(
        cloudId: _cloudId,
        params: params,
      );
      state = AsyncValue.data(response);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void search() {
    final searchParams = StatementSearchParams(
      cityName: cityController.text,
      functionName: functionController.text,
      member: memberController.text,
    );
    fetchStatements(searchParams);
  }

  // தொடக்கத்தில் எல்லா அறிக்கைகளையும் பெற, இந்தச் செயல்பாட்டை report_screen.dart-இன் initState-இல் அழைக்கலாம்.
  void fetchInitialData() {
    fetchStatements(StatementSearchParams());
  }

  @override
  void dispose() {
    cityController.dispose();
    functionController.dispose();
    memberController.dispose();
    super.dispose();
  }
}
