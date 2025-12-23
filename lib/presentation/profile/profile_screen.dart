// ✨ AppLocalizations-ஐ import செய்யவும்
import 'package:bneeds_moi/core/utils/app_localizations.dart';
import 'package:bneeds_moi/presentation/login/login_view.dart';import 'package:bneeds_moi/presentation/screens/SettingsScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/shared_prefrences_helper.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    // ✨ மொழிபெயர்ப்பு instance-ஐப் பெறவும்
    final lang = AppLocalizations.of(context);

    // SharedPreferences-லிருந்து தரவைப் படித்தல்
    final String personName = SharedPrefsHelper.getCustomerName() ?? "Guest User";
    final String mobileNumber = SharedPrefsHelper.getCustomerMobile() ?? "N/A";
    final String userInitials = personName.length >= 2
        ? personName.substring(0, 2).toUpperCase()
        : (personName.isNotEmpty ? personName[0].toUpperCase() : 'B');

    void showLogoutDialog() {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to log out?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              ),
              TextButton(
                child: const Text('Logout'),
                onPressed: () {
                  SharedPrefsHelper.clearAll();
                  Navigator.of(dialogContext).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                        (Route<dynamic> route) => false,
                  );
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      // AppBar-ஐ இங்கே கொண்டு வருவோம்
      appBar: AppBar(
        // ✨ மொழிபெயர்ப்பு
        title: Text(lang.profile),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 2.0,
      ),
      backgroundColor: colorScheme.surface,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // --- Profile Header ---
          _buildProfileHeader(context, personName, userInitials),
          const SizedBox(height: 24),

          // --- Personal Info Section ---
          Text(
            // ✨ மொழிபெயர்ப்பு
            lang.personalInformation,
            style: textTheme.titleSmall?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildInfoCard(
            context,
            children: [
              _buildInfoRow(
                context,
                icon: Icons.phone_android_outlined,
                // ✨ மொழிபெயர்ப்பு
                label: lang.mobileNumber,
                value: mobileNumber,
              ),
              _buildInfoRow(
                context,
                icon: Icons.password_outlined,
                // ✨ மொழிபெயர்ப்பு
                label: lang.password,
                value: '********',
              ),
            ],
          ),
          const SizedBox(height: 24),

          // --- Actions Section ---
          Text(
            // ✨ மொழிபெயர்ப்பு
            lang.actionsAndSettings,
            style: textTheme.titleSmall?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildInfoCard(
            context,
            children: [
              _buildActionRow(
                context,
                icon: Icons.settings_outlined,
                // ✨ மொழிபெயர்ப்பு
                label: lang.appSettings,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsScreen()),
                  );
                },
              ),
              _buildActionRow(
                context,
                icon: Icons.logout,
                // ✨ மொழிபெயர்ப்பு
                label: lang.logout,
                color: Colors.red.shade400,
                onTap: showLogoutDialog,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Helper Widgets for the new UI ---

  Widget _buildProfileHeader(BuildContext context, String name, String initials) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.secondary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: colorScheme.onPrimary.withOpacity(0.9),
            child: Text(
              initials,
              style: textTheme.displaySmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: textTheme.headlineSmall?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, {required List<Widget> children}) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoRow(BuildContext context, {required IconData icon, required String label, required String value}) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      leading: Icon(icon, color: colorScheme.primary),
      title: Text(label, style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.7))),
      subtitle: Text(value, style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildActionRow(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap, Color? color}) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      leading: Icon(icon, color: color ?? colorScheme.primary),
      title: Text(
        label,
        style: textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: color ?? colorScheme.onSurface,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      onTap: onTap,
    );
  }
}
