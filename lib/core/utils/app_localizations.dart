// lib/core/utils/app_localizations.dart
import 'dart:async';
import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
  _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // Login Screen
      'welcomeBack': 'Welcome Back!',
      'loginToContinue': 'Login to continue your account',
      'mobileNumber': 'Mobile Number',
      'password': 'Password',
      'login': 'LOGIN',

      // Home Screen
      'overview': 'Overview',
      'quickActions': 'Quick Actions',
      'report': 'Report',
      'newEntry': 'New Entry',
      'addCollection': 'Add Collection',
      'members': 'Members',
      'addReturn': 'Add Return',
      'topContributors': 'Top Contributors',

      // Member Screen
      'memberList': 'Member List',
      'searchByName': 'Search by name...',

      // New & Return Entry Screens
      'addCollectionTitle': 'Add Collection Entry',
      'addReturnTitle': 'Add Return Entry',
      'saveEntry': 'SAVE ENTRY',
      'saveReturn': 'SAVE RETURN',
      'city': 'City',
      'name': 'Name',
      'spouseName': "Spouse",
      'education': 'Education',
      'occupation': 'Occupation',
      'amount': 'Amount',
      'initial': 'Initial',
      'cityInitial': 'City Initial',

      // Settings
      'settings': 'Settings',
      'language': 'Language',
      'appLanguage': 'App Language',

      // Profile Screen
      'profile': 'Profile',
      'personalInformation': 'Personal Information',
      'actionsAndSettings': 'Actions & Settings',
      'appSettings': 'App Settings',
      'logout': 'Logout',

      // Return Details Screen
      'returnList': 'Return List',
      'returnDetails': 'Return Details',

      // Report/Statement Screen
      'statementReport': 'Statement Report',

      // ✨✨ Ledger Screen - புதிய வார்த்தைகள் ✨✨
      'ledger': 'Ledger',
      'memberLedger': 'Member Ledger',
      'searchPlaceholder': 'Search by name, city or mobile...',
      'noResults': 'No results found for your search.',
      'noLedgerData': 'No ledger data available.',
      'memberDetails': 'Member Details',
      'mobile': 'Mobile', // ✨ New
      'notes': 'Notes',
      'transactionList': 'Transaction List',
      'balanceAmount': 'Balance Amount', // ✨ New
      'totalCredit': 'Total Credit',
      'totalDebit': 'Total Return',
      'credit': 'Credit', // ✨ New
      'debit': 'Return', // ✨ New (or Return)
      'noTransactions': 'No transactions found for this member.',
    },
    'ta': {
      // Login Screen
      'welcomeBack': 'வருக வருக!',
      'loginToContinue': 'உங்கள் கணக்கைத் தொடர உள்நுழைக',
      'mobileNumber': 'கைபேசி எண்',
      'password': 'கடவுச்சொல்',
      'login': 'உள்நுழைக',

      // Home Screen
      'overview': 'மேலோட்டம்',
      'quickActions': 'விரைவுச் செயல்கள்',
      'report': 'அறிக்கை',
      'newEntry': 'புதிய பதிவு',
      'addCollection': 'வசூல் சேர்க்க',
      'members': 'உறுப்பினர்கள்',
      'addReturn': 'திரும்ப அளிக்க',
      'topContributors': 'சிறந்த நன்கொடையாளர்கள்',

      // Member Screen
      'memberList': 'உறுப்பினர் பட்டியல்',
      'searchByName': 'பெயரை உள்ளிட்டு தேடவும்...',

      // New & Return Entry Screens
      'addCollectionTitle': 'புதிய வசூல் பதிவு',
      'addReturnTitle': 'பணம் திரும்ப அளித்தல்',
      'saveEntry': 'பதிவை சேமி',
      'saveReturn': 'திரும்ப அளித்ததை சேமி',
      'city': 'நகரம்',
      'name': 'பெயர்',
      'spouseName': 'துணைவர்',
      'education': 'கல்வி',
      'occupation': 'பணி',
      'amount': 'தொகை',
      'initial': 'முன்னெழுத்து',
      'cityInitial': 'நகர முன்னெழுத்து',

      // Settings
      'settings': 'அமைப்புகள்',
      'language': 'மொழி',
      'appLanguage': 'செயலியின் மொழி',

      // Profile Screen
      'profile': 'சுயவிவரம்',
      'personalInformation': 'தனிப்பட்ட தகவல்கள்',
      'actionsAndSettings': 'செயல்கள் & அமைப்புகள்',
      'appSettings': 'செயலி அமைப்புகள்',
      'logout': 'வெளியேறு',

      // Return Details Screen
      'returnList': 'திரும்ப அளித்த பட்டியல்',
      'returnDetails': 'திரும்ப அளித்த விவரங்கள்',

      // Report/Statement Screen
      'statementReport': 'அறிக்கை',

      // ✨✨ Ledger Screen - புதிய வார்த்தைகள் ✨✨
      'ledger': 'கணக்கு',
      'memberLedger': 'உறுப்பினர் கணக்கு ஏடு',
      'searchPlaceholder': 'பெயர், ஊர் அல்லது மொபைல் மூலம் தேடவும்',
      'noResults': 'தேடலுக்கு ஏற்ற முடிவுகள் இல்லை.',
      'noLedgerData': 'கணக்கு விவரங்கள் எதுவும் இல்லை.',
      'memberDetails': 'உறுப்பினர் விவரங்கள்',
      'mobile': 'கைபேசி', // ✨ New
      'notes': 'குறிப்புகள்',
      'transactionList': 'பரிவர்த்தனை பட்டியல்',
      'balanceAmount': 'மீதமுள்ள தொகை', // ✨ New
      'totalCredit': 'மொத்த வரவு',
      'totalDebit': 'திருப்பி தந்தது',
      'credit': 'வரவு', // ✨ New
      'debit': 'திருப்பி தந்தது', // ✨ New
      'noTransactions': 'இந்த உறுப்பினருக்கு பரிவர்த்தனைகள் எதுவும் இல்லை.',
    },
  };

  // --- General Getters ---
  String get welcomeBack => _localizedValues[locale.languageCode]!['welcomeBack']!;
  String get loginToContinue => _localizedValues[locale.languageCode]!['loginToContinue']!;
  String get mobileNumber => _localizedValues[locale.languageCode]!['mobileNumber']!;
  String get password => _localizedValues[locale.languageCode]!['password']!;
  String get login => _localizedValues[locale.languageCode]!['login']!;
  String get overview => _localizedValues[locale.languageCode]!['overview']!;
  String get quickActions => _localizedValues[locale.languageCode]!['quickActions']!;
  String get report => _localizedValues[locale.languageCode]!['report']!;
  String get newEntry => _localizedValues[locale.languageCode]!['newEntry']!;
  String get addCollection => _localizedValues[locale.languageCode]!['addCollection']!;
  String get members => _localizedValues[locale.languageCode]!['members']!;
  String get addReturn => _localizedValues[locale.languageCode]!['addReturn']!;
  String get topContributors => _localizedValues[locale.languageCode]!['topContributors']!;
  String get memberList => _localizedValues[locale.languageCode]!['memberList']!;
  String get searchByName => _localizedValues[locale.languageCode]!['searchByName']!;
  String get addCollectionTitle => _localizedValues[locale.languageCode]!['addCollectionTitle']!;
  String get addReturnTitle => _localizedValues[locale.languageCode]!['addReturnTitle']!;
  String get saveEntry => _localizedValues[locale.languageCode]!['saveEntry']!;
  String get saveReturn => _localizedValues[locale.languageCode]!['saveReturn']!;
  String get city => _localizedValues[locale.languageCode]!['city']!;
  String get name => _localizedValues[locale.languageCode]!['name']!;
  String get spouseName => _localizedValues[locale.languageCode]!['spouseName']!;
  String get education => _localizedValues[locale.languageCode]!['education']!;
  String get occupation => _localizedValues[locale.languageCode]!['occupation']!;
  String get amount => _localizedValues[locale.languageCode]!['amount']!;
  String get initial => _localizedValues[locale.languageCode]!['initial']!;
  String get cityInitial => _localizedValues[locale.languageCode]!['cityInitial']!;
  String get settings => _localizedValues[locale.languageCode]!['settings']!;
  String get language => _localizedValues[locale.languageCode]!['language']!;
  String get appLanguage => _localizedValues[locale.languageCode]!['appLanguage']!;
  String get profile => _localizedValues[locale.languageCode]!['profile']!;
  String get personalInformation => _localizedValues[locale.languageCode]!['personalInformation']!;
  String get actionsAndSettings => _localizedValues[locale.languageCode]!['actionsAndSettings']!;
  String get appSettings => _localizedValues[locale.languageCode]!['appSettings']!;
  String get logout => _localizedValues[locale.languageCode]!['logout']!;
  String get returnList => _localizedValues[locale.languageCode]!['returnList']!;
  String get returnDetails => _localizedValues[locale.languageCode]!['returnDetails']!;
  String get statementReport => _localizedValues[locale.languageCode]!['statementReport']!;

  // ✨✨ Ledger Screen Getters - புதிய getters ✨✨
  String get ledger => _localizedValues[locale.languageCode]!['ledger']!;
  String get memberLedger => _localizedValues[locale.languageCode]!['memberLedger']!;
  String get searchPlaceholder => _localizedValues[locale.languageCode]!['searchPlaceholder']!;
  String get noResults => _localizedValues[locale.languageCode]!['noResults']!;
  String get noLedgerData => _localizedValues[locale.languageCode]!['noLedgerData']!;
  String get memberDetails => _localizedValues[locale.languageCode]!['memberDetails']!;
  String get mobile => _localizedValues[locale.languageCode]!['mobile']!; // ✨ New
  String get notes => _localizedValues[locale.languageCode]!['notes']!;
  String get transactionList => _localizedValues[locale.languageCode]!['transactionList']!;
  String get balanceAmount => _localizedValues[locale.languageCode]!['balanceAmount']!; // ✨ New
  String get totalCredit => _localizedValues[locale.languageCode]!['totalCredit']!;
  String get totalDebit => _localizedValues[locale.languageCode]!['totalDebit']!;
  String get credit => _localizedValues[locale.languageCode]!['credit']!; // ✨ New
  String get debit => _localizedValues[locale.languageCode]!['debit']!; // ✨ New
  String get noTransactions => _localizedValues[locale.languageCode]!['noTransactions']!;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ta'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return Future.value(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) {
    return false;
  }
}
