// lib/data/models/function_model.dart

class FunctionModel {
  final String funcId;
  final String cloudId;
  final String funcName;
  final String funcHead;
  final String personName;
  final String funcLocation;
  final String funcFooter;
  final String funcDate;
  final String funcTime;
  final String billNo;
  final num totalCollection;

  FunctionModel({
    required this.funcId,
    required this.cloudId,
    required this.funcName,
    required this.funcHead,
    required this.personName,
    required this.funcLocation,
    required this.funcFooter,
    required this.funcDate,
    required this.funcTime,
    required this.billNo,
    required this.totalCollection,
  });

  factory FunctionModel.fromJson(Map<String, dynamic> json) {
    return FunctionModel(
      funcId: json['Funcid'] ?? '',
      cloudId: json['Cloudid'] ?? '',
      funcName: json['FuncName'] ?? '',
      funcHead: json['FuncHead'] ?? '',
      personName: json['PersonName'] ?? '',
      funcLocation: json['FuncLocation'] ?? '',
      funcFooter: json['FuncFooter'] ?? '',
      funcDate: json['FuncDate'] ?? '',
      funcTime: json['FuncTime'] ?? '',
      billNo: json['BillNo'] ?? '',
      totalCollection: json['TotalCollection'] ?? 0,
    );
  }
}
