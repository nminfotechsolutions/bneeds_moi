// lib/data/models/new_entry_model.dart

class NewEntryModel {
  final String cloudId;
  final String billDate;
  final String cityIni;
  final String cityName;
  final String memMobileNo;
  final String memName;
  final String memEdu;
  final String memIni;
  final String memSpouse;
  final String memWork;
  final double amount;

  NewEntryModel({
    required this.cloudId,
    required this.billDate,
    required this.cityIni,
    required this.cityName,
    required this.memMobileNo,
    required this.memName,
    required this.memEdu,
    required this.memIni,
    required this.memSpouse,
    required this.memWork,
    required this.amount,
  });

  // இந்த மாடலை JSON ஆக மாற்றும் முறை
  Map<String, dynamic> toJson() {
    return {
      'Cloudid': cloudId,
      'Billdate': billDate,
      'CityIni': cityIni,
      'cityName': cityName,
      'memMobileNo': memMobileNo,
      'MemName': memName,
      'MemEdu': memEdu,
      'memIni': memIni,
      'memSpouse': memSpouse,
      'memWork': memWork,
      'Amount': amount,
    };
  }
}
