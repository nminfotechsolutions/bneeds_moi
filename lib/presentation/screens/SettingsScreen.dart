import 'package:bneeds_moi/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ✨ மொழிபெயர்ப்பு மற்றும் SharedPreferences-ஐ import செய்யவும்
import 'package:bneeds_moi/core/utils/app_localizations.dart';

import '../../core/utils/shared_prefrences_helper.dart';

class SettingsScreen extends ConsumerWidget { // ✨ StatefulWidget-ஐ ConsumerWidget-ஆக மாற்றவும்
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) { // ✨ build முறைக்குள் ref-ஐப் பெறவும்
    final lang = AppLocalizations.of(context);
    final currentLocale = ref.watch(localeProvider);
    // ThemeProvider-லிருந்து தற்போதைய theme mode-ஐப் பெறுகிறோம்
    final currentThemeMode = ThemeProvider.of(context)!.themeMode.value;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(lang.settings), // ✨ மொழிபெயர்ப்பு
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        children: [
          // --- Language Section ---
          _buildSettingsCard(
            context: context,
            title: lang.language, // ✨ மொழிபெயர்ப்பு
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  lang.appLanguage, // ✨ மொழிபெயர்ப்பு
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              // ✨ மொழி மாற்றும் தர்க்கத்தைச் சேர்க்கவும்
              _buildLanguageSelector(context, currentLocale, ref),
            ],
          ),
          const SizedBox(height: 20),

          // --- Appearance Section ---
          _buildSettingsCard(
            context: context,
            title: 'Appearance', // இதை மொழிபெயர்ப்பு கோப்பில் சேர்க்கலாம்
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'App Theme', // இதை மொழிபெயர்ப்பு கோப்பில் சேர்க்கலாம்
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              // ✨ Theme மாற்றும் தர்க்கத்தைச் சேர்க்கவும்
              _buildThemeSelector(context, currentThemeMode),
            ],
          ),
          const SizedBox(height: 20),

          // --- About Section ---
          _buildSettingsCard(
            context: context,
            title: 'About', // இதை மொழிபெயர்ப்பு கோப்பில் சேர்க்கலாம்
            children: [
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('App Version'),
                trailing: Text(
                  '1.0.0', // உங்கள் செயலியின் பதிப்பு
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context, Locale currentLocale, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: SegmentedButton<Locale>(
        segments: const [
          ButtonSegment(value: Locale('ta'), label: Text('தமிழ்')),
          ButtonSegment(value: Locale('en'), label: Text('English')),
        ],
        selected: {currentLocale},
        onSelectionChanged: (newSelection) {
          // ✨ localeProvider-ஐப் பயன்படுத்தி மொழியை மாற்றி, SharedPreferences-இல் சேமிக்கவும்
          ref.read(localeProvider.notifier).setLocale(newSelection.first);
        },
        style: SegmentedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.5),
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          selectedForegroundColor: Theme.of(context).colorScheme.onPrimary,
          selectedBackgroundColor: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildThemeSelector(BuildContext context, ThemeMode currentThemeMode) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: SegmentedButton<ThemeMode>(
        segments: const [
          ButtonSegment(value: ThemeMode.light, label: Text('Light'), icon: Icon(Icons.wb_sunny_outlined)),
          ButtonSegment(value: ThemeMode.dark, label: Text('Dark'), icon: Icon(Icons.nightlight_outlined)),
          ButtonSegment(value: ThemeMode.system, label: Text('System'), icon: Icon(Icons.brightness_auto_outlined)),
        ],
        selected: {currentThemeMode},
        onSelectionChanged: (newSelection) {
          final newTheme = newSelection.first;
          // ✨ ThemeProvider-ஐப் பயன்படுத்தி Theme-ஐ மாற்றவும்
          ThemeProvider.setTheme(context, newTheme);
          // ✨ SharedPreferences-இல் சேமிக்கவும்
          SharedPrefsHelper.setAppTheme(newTheme.name);
        },
        style: SegmentedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.5),
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          selectedForegroundColor: Theme.of(context).colorScheme.onPrimary,
          selectedBackgroundColor: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildSettingsCard({
    required BuildContext context,
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shadowColor: Theme.of(context).shadowColor.withOpacity(0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title.toUpperCase(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}
