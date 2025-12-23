// lib/presentation/home/home_viewmodel.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
 
import '../../data/models/collection_model.dart'; // CollectionModel-ஐ import செய்யவும்
import '../../data/models/function_model.dart';
import '../../data/repositories/collection_repository.dart';
import '../../data/repositories/function_repository.dart';
import 'home_state.dart';

final homeViewModelProvider = StateNotifierProvider.autoDispose<HomeViewModel, AsyncValue<HomeState>>((ref) {
  final functionRepository = ref.watch(functionRepositoryProvider);
  final collectionRepository = ref.watch(collectionRepositoryProvider);
  return HomeViewModel(functionRepository, collectionRepository);
});

class HomeViewModel extends StateNotifier<AsyncValue<HomeState>> {
  final FunctionRepository _functionRepository;
  final CollectionRepository _collectionRepository;

  HomeViewModel(this._functionRepository, this._collectionRepository) : super(const AsyncValue.loading());

  Future<void> fetchHomeData(String cloudId) async {
    state = const AsyncValue.loading();
    try {
      final results = await Future.wait([
        _functionRepository.getFunctionDetails(cloudId),
        _collectionRepository.getCollectionDetails(cloudId),
      ]);

      final functionDetailsList = results[0] as List<FunctionModel>;
      final allCollections = results[1] as List<CollectionModel>;

      // ✨ முக்கிய மாற்றம்: தொகையின் அடிப்படையில் உறுப்பினர்களை வரிசைப்படுத்தவும்
      allCollections.sort((a, b) => b.amount.compareTo(a.amount));

      // ✨ முதல் 3 உறுப்பினர்களை மட்டும் எடுத்துக்கொள்ளவும்
      final topContributors = allCollections.take(3).toList();

      final homeState = HomeState(
        functionDetails: functionDetailsList.isNotEmpty ? functionDetailsList.first : null,
        // ✨ HomeState-இல் topContributors-ஐ சேமிக்கவும்
        topContributors: topContributors,
      );

      state = AsyncValue.data(homeState);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }
}
