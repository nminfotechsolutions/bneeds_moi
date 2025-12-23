// lib/presentation/member/member_viewmodel.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
 
import '../../data/models/collection_model.dart';
import '../../data/repositories/collection_repository.dart';

// MemberViewModel-க்கான StateNotifierProvider
final memberViewModelProvider = StateNotifierProvider.autoDispose<
    MemberViewModel, AsyncValue<List<CollectionModel>>>((ref) {
  return MemberViewModel(ref.watch(collectionRepositoryProvider));
});

class MemberViewModel extends StateNotifier<AsyncValue<List<CollectionModel>>> {
  final CollectionRepository _collectionRepository;

  MemberViewModel(this._collectionRepository) : super(const AsyncValue.loading());

  Future<void> fetchCollectionDetails(String cloudId) async {
    state = const AsyncValue.loading();
    try {
      final collections = await _collectionRepository.getCollectionDetails(cloudId);
      
      // ✨ பெயரின் அடிப்படையில் அகரவரிசையில் (Alphabetical Order) அடுக்குகிறோம்
      collections.sort((a, b) => a.memName.toLowerCase().compareTo(b.memName.toLowerCase()));
      
      state = AsyncValue.data(collections);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }
}

