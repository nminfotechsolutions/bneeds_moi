// lib/core/utils/shared_prefrences_helper.dart

import 'package:shared_preferences/shared_preferences.dart';

// SharedPreferences-இல் பயன்படுத்தப்படும் keys-ஐ வரையறுக்கும் வகுப்பு
class SharedPrefsKeys {
  static const String cloudId = "cloudId";
  static const String customerMobile = "customerMobile";
  static const String customerName = "customerName";
  static const String isRegistered = "isRegistered";
  static const String customerPassword = "customerPassword";
  static const String isLoggedIn = "isLoggedIn";

  // Theme மற்றும் Language-க்கான keys
  static const String appTheme = "appTheme";
  static const String appLanguage = "appLanguage";
}

// SharedPreferences-ஐ எளிதாகக் கையாள உதவும் helper வகுப்பு
class SharedPrefsHelper {
  static SharedPreferences? _prefs;

  // செயலி தொடங்கும் போது இந்த முறையை அழைக்க வேண்டும்
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // --- Theme Methods ---

  // ✨✨ இந்தப் பகுதி சேர்க்கப்பட்டுள்ளது ✨✨
  /// Theme-ஐ String ஆக ('light', 'dark', 'system') சேமிக்கிறது
  static Future<void> setAppTheme(String theme) async {
    await _prefs?.setString(SharedPrefsKeys.appTheme, theme);
  }

  /// சேமிக்கப்பட்ட Theme-ஐப் படிக்கிறது. எதுவும் இல்லை என்றால், 'system'-ஐ இயல்புநிலையாகத் தருகிறது.
  static String getAppTheme() {
    return _prefs?.getString(SharedPrefsKeys.appTheme) ?? "system";
  }
  // ✨✨---------------------------------✨✨


  // --- Language Methods ---

  // ✨✨ இந்தப் பகுதி சேர்க்கப்பட்டுள்ளது ✨✨
  /// மொழியின் language code-ஐ ('ta', 'en') சேமிக்கிறது
  static Future<void> setAppLanguage(String languageCode) async {
    await _prefs?.setString(SharedPrefsKeys.appLanguage, languageCode);
  }

  /// சேமிக்கப்பட்ட மொழியைப் படிக்கிறது. எதுவும் இல்லை என்றால், 'ta' (தமிழ்)-ஐ இயல்புநிலையாகத் தருகிறது.
  static String getAppLanguage() {
    return _prefs?.getString(SharedPrefsKeys.appLanguage) ?? "ta";
  }
  // ✨✨---------------------------------✨✨


  // --- User Data Methods ---

  /// பயனரின் cloudId-ஐச் சேமிக்கிறது
  static Future<void> setCloudId(String id) async {
    await _prefs?.setString(SharedPrefsKeys.cloudId, id);
  }

  /// பயனரின் மொபைல் எண்ணைச் சேமிக்கிறது
  static Future<void> setCustomerMobile(String mobile) async {
    await _prefs?.setString(SharedPrefsKeys.customerMobile, mobile);
  }

  /// பயனரின் பெயரைச் சேமிக்கிறது
  static Future<void> setCustomerName(String name) async {
    await _prefs?.setString(SharedPrefsKeys.customerName, name);
  }

  /// பயனரின் cloudId-ஐப் படிக்கிறது
  static String? getCloudId() {
    return _prefs?.getString(SharedPrefsKeys.cloudId);
  }

  /// பயனரின் மொபைல் எண்ணைப் படிக்கிறது
  static String? getCustomerMobile() {
    return _prefs?.getString(SharedPrefsKeys.customerMobile);
  }

  /// பயனரின் பெயரைப் படிக்கிறது
  static String? getCustomerName() {
    return _prefs?.getString(SharedPrefsKeys.customerName);
  }

  static Future<void> setCustomerPassword(String password) async {
    await _prefs?.setString(SharedPrefsKeys.customerPassword, password);
  }

  /// பயனரின் கடவுச்சொல்லைப் படிக்கிறது
  static String? getCustomerPassword() {
    return _prefs?.getString(SharedPrefsKeys.customerPassword);
  }
  static Future<void> setLoggedIn(bool status) async {
    await _prefs?.setBool(SharedPrefsKeys.isLoggedIn, status);
  }

  /// பயனர் உள்நுழைந்துள்ளாரா என்பதைச் சரிபார்க்கிறது
  static bool isLoggedIn() {
    return _prefs?.getBool(SharedPrefsKeys.isLoggedIn) ?? false;
  }

  // --- Logout Method ---
  static Future<void> clearAll() async {
    // இப்போது இந்த செயல்பாடுகள் சரியாக வேலை செய்யும்
    final theme = getAppTheme();
    final lang = getAppLanguage();

    await _prefs?.clear();

    await setAppTheme(theme);
    await setAppLanguage(lang);
    await setLoggedIn(false);
  }
}
