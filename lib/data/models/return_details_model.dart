// lib/data/models/return_details_model.dart

class ReturnDetailsModel {
  final String rtnId;
  final String cloudId;
  final String billDate;
  final String cityName;
  final String memMobileNo;
  final String memName;final String memSpouse;
  final String memWork;
  final String memEdu;
  final String memIni;
  final int amount;

  ReturnDetailsModel({
    required this.rtnId,
    required this.cloudId,
    required this.billDate,
    required this.cityName,
    required this.memMobileNo,
    required this.memName,
    required this.memSpouse,
    required this.memWork,
    required this.memEdu,
    required this.memIni,
    required this.amount,
  });

  factory ReturnDetailsModel.fromJson(Map<String, dynamic> json) {
    return ReturnDetailsModel(
      rtnId: json['Rtnid'] ?? '',
      cloudId: json['Cloudid'] ?? '',
      billDate: json['Billdate'] ?? '',
      cityName: json['cityName'] ?? '',
      memMobileNo: json['memMobileNo'] ?? '',
      memName: json['MemName'] ?? '',
      memSpouse: json['memSpouse'] ?? '',
      memWork: json['memWork'] ?? '',
      memEdu: json['MemEdu'] ?? '',
      memIni: json['memIni'] ?? '',
      amount: json['Amount'] ?? 0,
    );
  }
}
