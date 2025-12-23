// lib/presentation/return_entry/return_entry_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
 
//   // ✨ இந்த வரியை அகற்றவும்
import 'package:intl/intl.dart';
import '../../core/utils/shared_prefrences_helper.dart';
import '../../data/models/new_entry_model.dart';
import '../../data/models/collection_model.dart';
import '../../data/repositories/return_repository.dart';

// இந்த Provider, செயல்பாட்டின் நிலையை (loading, error, success) நிர்வகிக்கும்
final returnEntryStateProvider = StateProvider<AsyncValue<void>>((ref) => const AsyncValue.data(null));

final returnEntryViewModelProvider = Provider((ref) {
  final repository = ref.watch(returnRepositoryProvider);
  return ReturnEntryViewModel(repository, ref);
});

class ReturnEntryViewModel {
  final ReturnRepository _repository;
  // ✨ வகையை 'Ref' என மாற்றவும்
  final Ref _ref;

  ReturnEntryViewModel(this._repository, this._ref);

  // Form fields-க்கான controller-கள்
  final nameController = TextEditingController();
  final cityController = TextEditingController();
  final mobileController = TextEditingController();
  final amountController = TextEditingController();
  final spouseController = TextEditingController();
  final educationController = TextEditingController();
  final workController = TextEditingController();
  final initialController = TextEditingController();
  final cityIniController = TextEditingController();

  Future<void> createReturnEntry() async {
    _ref.read(returnEntryStateProvider.notifier).state = const AsyncValue.loading();
    try {
      final cloudId = SharedPrefsHelper.getCloudId();
      if (cloudId == null || cloudId.isEmpty) {
        throw Exception("User not logged in. Cloud ID is missing.");
      }
      final newEntry = NewEntryModel(
        cloudId: cloudId, // இதை login-லிருந்து பெற வேண்டும்
        billDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        memName: nameController.text,
        cityName: cityController.text,
        memMobileNo: mobileController.text,
        amount: double.tryParse(amountController.text) ?? 0.0,
        memSpouse: spouseController.text,
        memEdu: educationController.text,
        memWork: workController.text,
        memIni: initialController.text,
        cityIni: cityIniController.text,
      );

      // ✨ ரெப்போசிட்டரியில் உள்ள createReturnEntry முறையை அழைக்கவும்
      await _repository.createReturnEntry(newEntry);

      clearForm();

      _ref.read(returnEntryStateProvider.notifier).state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      _ref.read(returnEntryStateProvider.notifier).state = AsyncValue.error(e, stackTrace);
    }
  }

  void dispose() {
    nameController.dispose();
    cityController.dispose();
    mobileController.dispose();
    amountController.dispose();
    spouseController.dispose();
    educationController.dispose();
    workController.dispose();
    initialController.dispose();
    cityIniController.dispose();
  }

  void clearForm() {
    nameController.clear();
    cityController.clear();
    mobileController.clear();
    amountController.clear();
    spouseController.clear();
    educationController.clear();
    workController.clear();
    initialController.clear();
    cityIniController.clear();
  }

  void preFillData(CollectionModel member) {
    nameController.text = member.memName;
    cityController.text = member.cityName;
    spouseController.text = member.memSpouse;
    educationController.text = member.memEdu;
    workController.text = member.memWork;
    initialController.text = member.memIni;
    mobileController.text = member.memMobileNo;
  }
}
