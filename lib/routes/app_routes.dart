import 'package:flutter/cupertino.dart';

import '../presentation/home/home_view.dart';
import '../presentation/screens/splash_screen.dart';


class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String register = '/register';
  static const String login = '/login';
  static const String profile = '/profile';
  static const String JoinScheme = '/JoinScheme';
  static const String Otp = '/Otp';
  static const String Transaction = '/Transaction';
  static const String myPlans = '/myPlans';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
     home: (context) =>  HomeScreen(),
    // register: (context) =>  RegisterScreen(),
    // login: (context) =>  LoginScreen(),
    // home: (context) => const HomeScreen(),
    // profile: (context) => const ProfileScreen(),
    // JoinScheme: (context) => const JoinSchemeScreen(),
    // Otp: (context) => const OtpScreen( mobile: '8870602962'),
    // Transaction: (context) => const TransactionScreen(),
    // myPlans: (context) => const MyPlansScreen(),
  };
}

