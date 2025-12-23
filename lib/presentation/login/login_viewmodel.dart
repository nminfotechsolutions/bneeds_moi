// lib/presentation/login/login_viewmodel.dart

// ✨ Import செய்யவும்
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
 
import '../../core/utils/shared_prefrences_helper.dart';import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

final loginViewModelProvider = StateNotifierProvider<LoginViewModel, AsyncValue<UserModel?>>((ref) {
  return LoginViewModel(authRepository: ref.watch(authRepositoryProvider));
});

class LoginViewModel extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthRepository _authRepository;

  LoginViewModel({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AsyncData(null));

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> loginUser() async {
    state = const AsyncLoading();
    try {
      final user = await _authRepository.login(
        usernameController.text.trim(),
        passwordController.text.trim(),
      );

      // --- ✨ முக்கிய மாற்றம்: உள்நுழைவு வெற்றி பெற்றவுடன் சேமித்தல் ---
      if (user != null) {
        // API பதிலில் இருந்து பெயரைப் பெறுகிறோம்
        await SharedPrefsHelper.setCustomerName(user.username);
        await SharedPrefsHelper.setCloudId(user.cloudId);
        await SharedPrefsHelper.setCustomerMobile(usernameController.text.trim());
        await SharedPrefsHelper.setCustomerPassword(passwordController.text.trim());
        await SharedPrefsHelper.setLoggedIn(true);

        // ✨✨ Textfield-களை clear செய்யவும் ✨✨
        usernameController.clear();
        passwordController.clear();
      }
      // -----------------------------------------------------------

      state = AsyncData(user);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
