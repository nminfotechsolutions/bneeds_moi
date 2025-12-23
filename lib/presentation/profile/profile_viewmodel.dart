
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/shared_prefrences_helper.dart';

// ProfileViewModel-ஐ வழங்குவதற்கான Provider
final profileViewModelProvider = Provider.autoDispose((ref) {
  return ProfileViewModel();
});

class ProfileViewModel {
  // Form fields-க்கான controller-கள்
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();

  ProfileViewModel() {
    // ViewModel தொடங்கும்போதே, SharedPreferences-லிருந்து தரவைப் படித்து Controller-களில் நிரப்பவும்
    loadUserData();
  }

  void loadUserData() {
    nameController.text = SharedPrefsHelper.getCustomerName() ?? '';
    mobileController.text = SharedPrefsHelper.getCustomerMobile() ?? '';
    passwordController.text = SharedPrefsHelper.getCustomerPassword() ?? '';
  }

  // சுயவிவரத்தைப் புதுப்பிக்கும் முறை (இதைச் செயல்படுத்த ஒரு API தேவை)
  Future<void> updateProfile() async {
    // இங்கே, புதுப்பிக்கப்பட்ட விவரங்களை API-க்கு அனுப்பும் தர்க்கத்தை எழுதலாம்.
    // உதாரணமாக:
    final name = nameController.text;
    final mobile = mobileController.text;
    final password = passwordController.text;

    // புதிய விவரங்களை SharedPreferences-இல் சேமித்தல்
    await SharedPrefsHelper.setCustomerName(name);
    await SharedPrefsHelper.setCustomerMobile(mobile);
    await SharedPrefsHelper.setCustomerPassword(password);

    // இங்கே API அழைப்பைச் செய்யலாம்...
    print('Profile Updated: $name, $mobile');
  }

  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    passwordController.dispose();
  }
}
