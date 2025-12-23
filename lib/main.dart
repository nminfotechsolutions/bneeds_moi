import 'package:bneeds_moi/core/constants/app_colors.dart';
import 'package:bneeds_moi/core/utils/app_localizations.dart';
// SharedPreferences helper-ஐ import செய்யவும்
import 'package:bneeds_moi/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
 

import 'core/utils/shared_prefrences_helper.dart';

// --- Locale Provider ---
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  // SharedPreferences-லிருந்து சேமிக்கப்பட்ட மொழியைப் படிக்கவும்
  final languageCode = SharedPrefsHelper.getAppLanguage();
  return LocaleNotifier(Locale(languageCode));
});

class LocaleNotifier extends StateNotifier<Locale> {
  // தொடக்கத்தில் சேமிக்கப்பட்ட மொழியைப் பெறவும்
  LocaleNotifier(super.initialLocale);

  void setLocale(Locale newLocale) {
    if (state != newLocale) {
      state = newLocale;
      // புதிய மொழியை SharedPreferences-இல் சேமிக்கவும்
      SharedPrefsHelper.setAppLanguage(newLocale.languageCode);
    }
  }
}

// --- Theme Provider (இதில் மாற்றம் இல்லை) ---
class ThemeProvider extends InheritedWidget {
  final ValueNotifier<ThemeMode> themeMode;

  const ThemeProvider({
    super.key,
    required this.themeMode,
    required super.child,
  });

  static ThemeProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ThemeProvider>();
  }

  static void setTheme(BuildContext context, ThemeMode newThemeMode) {
    final provider = of(context);
    if (provider != null) {
      provider.themeMode.value = newThemeMode;
    }
  }

  @override
  bool updateShouldNotify(ThemeProvider oldWidget) {
    return oldWidget.themeMode != themeMode;
  }
}

// ✨ main-ஐ async ஆக மாற்றவும்
void main() async {
  // ✨ செயலி தொடங்கும் முன் SharedPreferences-ஐ initialize செய்யவும்
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefsHelper.init();

  runApp(
    const ProviderScope(
      child: MyAppWrapper(),
    ),
  );
}

class MyAppWrapper extends StatefulWidget {
  const MyAppWrapper({super.key});

  @override
  State<MyAppWrapper> createState() => _MyAppWrapperState();
}

class _MyAppWrapperState extends State<MyAppWrapper> {
  late final ValueNotifier<ThemeMode> _themeMode;

  @override
  void initState() {
    super.initState();
    // SharedPreferences-லிருந்து சேமிக்கப்பட்ட Theme-ஐப் படித்து, _themeMode-ஐ அமைக்கவும்
    _themeMode = ValueNotifier(_getThemeModeFromString(SharedPrefsHelper.getAppTheme()));
  }

  // String-ஐ ThemeMode ஆக மாற்றும் helper முறை
  ThemeMode _getThemeModeFromString(String theme) {
    switch (theme) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Consumer-ஐப் பயன்படுத்தி localeProvider-ஐ அணுகவும்
    return Consumer(
      builder: (context, ref, child) {
        final currentLocale = ref.watch(localeProvider);

        return ThemeProvider(
          themeMode: _themeMode,
          child: ValueListenableBuilder<ThemeMode>(
            valueListenable: _themeMode,
            builder: (_, currentMode, __) {
              return MaterialApp(
                title: 'Digital Moi',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: currentMode,

                // மொழிபெயர்ப்புக்கான அமைப்புகள்
                locale: currentLocale,
                supportedLocales: const [
                  Locale('en', ''), // ஆங்கிலம்
                  Locale('ta', ''), // தமிழ்
                ],
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],

                home: const SplashScreen(),
              );
            },
          ),
        );
      },
    );
  }
}
