// lib/data/models/statement_model.dart

class StatementModel {
  final String city;          // "ஊர்"
  final String mobileNumber;  // "memMobileNo"final String description;   // "விபரம்"
  final String description;
  final int amount;         // "தொகை"
  final int paidAmount;     // "செய்ததொகை"
  final int balance;        // "மீதம்"

  StatementModel({
    required this.city,
    required this.mobileNumber,
    required this.description,
    required this.amount,
    required this.paidAmount,
    required this.balance,
  });

  factory StatementModel.fromJson(Map<String, dynamic> json) {
    return StatementModel(
      city: json['ஊர்'] ?? '',
      mobileNumber: json['memMobileNo'] ?? '',
      description: json['விபரம்'] ?? '',
      amount: json['தொகை'] ?? 0,
      paidAmount: json['செய்ததொகை'] ?? 0,
      balance: json['மீதம்'] ?? 0,
    );
  }
}

// மொத்த விவரங்களையும் வைத்திருக்க ஒரு wrapper வகுப்பு
class StatementResponse {
  final int total;
  final List<StatementModel> statements;

  StatementResponse({required this.total, required this.statements});

  factory StatementResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> data = json['data'] ?? [];
    final statements = data.map((item) => StatementModel.fromJson(item)).toList();
    return StatementResponse(
      total: json['total'] ?? 0,
      statements: statements,
    );
  }
}
