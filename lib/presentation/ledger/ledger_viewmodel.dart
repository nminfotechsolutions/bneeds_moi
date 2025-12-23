// lib/presentation/ledger/ledger_viewmodel.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
 
import '../../data/models/ledger_model.dart';
import '../../data/repositories/ledger_repository.dart';

// ViewModel-க்கான StateNotifierProvider
final ledgerViewModelProvider = StateNotifierProvider.autoDispose<
    LedgerViewNotifier, AsyncValue<List<LedgerViewModel>>>((ref) {
  return LedgerViewNotifier(ref.watch(ledgerRepositoryProvider));
});

class LedgerViewNotifier extends StateNotifier<AsyncValue<List<LedgerViewModel>>> {
  final LedgerRepository _repository;

  // ✨✨ முக்கிய மாற்றம் இங்கே ✨✨
  // constructor-இல் இருந்த `fetchLedgerView` அழைப்பு முழுமையாக நீக்கப்பட்டுள்ளது.
  // ViewModel தொடங்கும் போது, அது ஒரு வெற்றுப் பட்டியலுடன் தொடங்குகிறது.
  LedgerViewNotifier(this._repository) : super(const AsyncValue.data([]));

  Future<void> fetchLedgerView(String cloudId) async {
    // cloudId காலியாக இருந்தால், தேவையற்ற API அழைப்பைத் தவிர்க்கவும்.
    if (cloudId.isEmpty) {
      state = const AsyncValue.data([]); // காலியான பட்டியலை அமைக்கவும்.
      return;
    }
    state = const AsyncValue.loading();
    try {
      final response = await _repository.getLedgerView(cloudId);
      state = AsyncValue.data(response);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
