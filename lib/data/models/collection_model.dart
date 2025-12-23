// lib/data/models/collection_model.dart

class CollectionModel {
  final String? billNo;
  final String cityName;
  final String memMobileNo;
  final String memIni;
  final String memName;
  final String memSpouse;
  final String memWork;
  final String memEdu;
  final int amount;

  CollectionModel({
    this.billNo,
    required this.cityName,
    required this.memMobileNo,
    required this.memIni,
    required this.memName,
    required this.memSpouse,
    required this.memWork,
    required this.memEdu,
    required this.amount,
  });

  factory CollectionModel.fromJson(Map<String, dynamic> json) {
    return CollectionModel(
      billNo: json['BillNo'], // இது null ஆக இருக்கலாம்
      cityName: json['cityName'] ?? '',
      memMobileNo: json['memMobileNo'] ?? '',
      memIni: json['memIni'] ?? '',
      memName: json['MemName'] ?? '',
      memSpouse: json['memSpouse'] ?? '',
      memWork: json['memWork'] ?? '',
      memEdu: json['MemEdu'] ?? '',
      amount: json['Amount'] ?? 0,
    );
  }
}

