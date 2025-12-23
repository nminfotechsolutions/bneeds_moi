// lib/presentation/return_det_view/return_det_viewmodel.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/return_details_model.dart';
import '../../data/repositories/return_repository.dart';

// ViewModel-க்கான StateNotifierProvider
final returnDetViewModelProvider = StateNotifierProvider.autoDispose<
    ReturnDetViewModel, AsyncValue<List<ReturnDetailsModel>>>((ref) {
  return ReturnDetViewModel(ref.watch(returnRepositoryProvider));
});

class ReturnDetViewModel extends StateNotifier<AsyncValue<List<ReturnDetailsModel>>> {
  final ReturnRepository _returnRepository;

  ReturnDetViewModel(this._returnRepository) : super(const AsyncValue.loading());

  // பணத்தைத் திரும்பக் கொடுத்தல் பட்டியலைப் பெறும் முறை
  Future<void> fetchReturnDetails(String cloudId) async {
    state = const AsyncValue.loading();
    try {
      final returns = await _returnRepository.getReturnDetails(cloudId);

      // ✨ அகரவரிசைப்படி (A to Z Alphabetical Order) வரிசைப்படுத்துகிறோம்
      returns.sort((a, b) => a.memName.toLowerCase().compareTo(b.memName.toLowerCase()));

      state = AsyncValue.data(returns);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
