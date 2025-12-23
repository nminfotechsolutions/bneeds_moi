import 'dart:async';
import 'package:bneeds_moi/presentation/home/home_view.dart';
import 'package:bneeds_moi/presentation/login/login_view.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/shared_prefrences_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scale = Tween(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();

    Timer(const Duration(seconds: 3), () {
      final bool userIsLoggedIn = SharedPrefsHelper.isLoggedIn();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => userIsLoggedIn ? const HomeScreen() : const LoginScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fade,
            child: ScaleTransition(
              scale: _scale,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // const Icon(Icons.currency_rupee,
                  //     size: 90, color: Colors.white),
                  // const SizedBox(height: 20),
                  // // --- ✨ முக்கிய மாற்றம் இங்கே ✨ ---
                  // // Text விட்ஜெட்டுக்கு பதிலாக Image விட்ஜெட்டைப் பயன்படுத்தவும்
                  Image.asset(
                    'assets/images/new_app_logo.jpg', // உங்கள் லோகோவின் சரியான பாதை
                    width: 300, // உங்கள் லோகோவின் அளவை சரிசெய்யவும்
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
