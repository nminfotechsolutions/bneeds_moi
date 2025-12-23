// lib/presentation/new_entry/new_entry_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
 
import 'package:intl/intl.dart';
import '../../core/utils/shared_prefrences_helper.dart';
import '../../data/models/new_entry_model.dart';
import '../../data/models/collection_model.dart';
import '../../data/repositories/collection_repository.dart';

final newEntryStateProvider = StateProvider<AsyncValue<void>>((ref) => const AsyncValue.data(null));

final newEntryViewModelProvider = Provider((ref) {
  final repository = ref.watch(collectionRepositoryProvider);
  return NewEntryViewModel(repository, ref);
});

class NewEntryViewModel {
  final CollectionRepository _repository;
  final Ref _ref;

  NewEntryViewModel(this._repository, this._ref);

  // Form fieldsக்கான controller-கள்
  final nameController = TextEditingController();
  final cityController = TextEditingController();
  final mobileController = TextEditingController();
  final amountController = TextEditingController();
  final spouseController = TextEditingController();
  final educationController = TextEditingController();
  final workController = TextEditingController();
  final initialController = TextEditingController();
  // ✨ பிழையைச் சரிசெய்ய இந்த வரியைச் சேர்க்கவும்
  final cityIniController = TextEditingController();

  Future<void> createEntry() async {
    _ref.read(newEntryStateProvider.notifier).state = const AsyncValue.loading();

    try {

      final cloudId = SharedPrefsHelper.getCloudId();
      if (cloudId == null || cloudId.isEmpty) {
        throw Exception("User not logged in. Cloud ID is missing.");
      }

      final newEntry = NewEntryModel(
        cloudId: cloudId,
        billDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        memName: nameController.text,
        cityName: cityController.text,
        memMobileNo: mobileController.text,
        amount: double.tryParse(amountController.text) ?? 0.0,
        memSpouse: spouseController.text,
        memEdu: educationController.text,
        memWork: workController.text,
        memIni: initialController.text,
        // cityIni-க்கு cityIniController-ஐப் பயன்படுத்தவும்
        cityIni: cityIniController.text,
      );

      await _repository.createCollectionEntry(newEntry);
      
      clearForm();

      _ref.read(newEntryStateProvider.notifier).state = const AsyncValue.data(null);

    } catch (e, stackTrace) {
      _ref.read(newEntryStateProvider.notifier).state = AsyncValue.error(e, stackTrace);
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
    // ✨ controller-ஐ dispose செய்யவும்
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
