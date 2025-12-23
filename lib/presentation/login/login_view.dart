// D:/android source/bneeds_moi/lib/presentation/login/login_view.dart

// ✨ படி 1: மொழிபெயர்ப்பு கோப்பை import செய்யவும்
import 'package:bneeds_moi/core/utils/app_localizations.dart';
import 'package:bneeds_moi/presentation/home/home_view.dart';
import 'package:bneeds_moi/presentation/login/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
 

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _formKey = GlobalKey<FormState>();
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final viewModel = ref.read(loginViewModelProvider.notifier);
    final loginState = ref.watch(loginViewModelProvider);

    // ✨ படி 2: மொழிபெயர்ப்பு instance-ஐப் பெறவும்
    final lang = AppLocalizations.of(context);

    final isPasswordVisible = StateProvider<bool>((ref) => false);

    ref.listen<AsyncValue>(loginViewModelProvider, (_, state) {
      if (state.hasError && !state.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login Failed: ${state.error}')),
        );
      }
      if (state.value != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    });

    void _login() {
      FocusManager.instance.primaryFocus?.unfocus();
      if (_formKey.currentState?.validate() ?? false) {
        viewModel.loginUser();
      }
    }

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.lock_person,
                    size: 60,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: 20),
                  // ✨ மொழிபெயர்ப்பைப் பயன்படுத்தவும்
                  Text(
                    lang.welcomeBack,
                    textAlign: TextAlign.center,
                    style: textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // ✨ மொழிபெயர்ப்பைப் பயன்படுத்தவும்
                  Text(
                    lang.loginToContinue,
                    textAlign: TextAlign.center,
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onBackground.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Mobile Number Field
                  TextFormField(
                    controller: viewModel.usernameController,
                    keyboardType: TextInputType.phone,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      // ✨ மொழிபெயர்ப்பைப் பயன்படுத்தவும்
                      labelText: lang.mobileNumber,
                      prefixIcon: const Icon(Icons.phone_android_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your mobile number';
                      }
                      if (value.length != 10) {
                        return 'Mobile number must be 10 digits';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Password Field
                  Consumer(
                    builder: (context, ref, child) {
                      final isVisible = ref.watch(isPasswordVisible);
                      return TextFormField(
                        controller: viewModel.passwordController,
                        obscureText: !isVisible,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          // ✨ மொழிபெயர்ப்பைப் பயன்படுத்தவும்
                          labelText: lang.password,
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isVisible
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            onPressed: () {
                              ref.read(isPasswordVisible.notifier).state = !isVisible;
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 32),

                  // Login Button
                  loginState.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // ✨ மொழிபெயர்ப்பைப் பயன்படுத்தவும்
                    child: Text(lang.login),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
