// lib/data/models/ledger_model.dart

// ஒவ்வொரு தனிப்பட்ட வரவு-செலவு பரிவர்த்தனைக்கான மாடல்
class LedgerEntry {  final String billDate;
final int amount;
final int returnAmount;

LedgerEntry({
  required this.billDate,
  required this.amount,
  required this.returnAmount,
});

factory LedgerEntry.fromJson(Map<String, dynamic> json) {
  return LedgerEntry(
    billDate: json['billdate'] ?? '',
    amount: json['Amount'] ?? 0,
    returnAmount: json['Returnamount'] ?? 0,
  );
}
}

// உறுப்பினரின் விவரங்களுடன், ledger பட்டியலையும் கொண்ட முக்கிய மாடல்
class LedgerViewModel {
  final String cityName;
  final String memMobileNo;
  final String memName;
  final String memEdu;
  final String memIni;
  final String memSpouse;
  final String memWork;
  final List<LedgerEntry> ledger;

  LedgerViewModel({
    required this.cityName,
    required this.memMobileNo,
    required this.memName,
    required this.memEdu,
    required this.memIni,
    required this.memSpouse,
    required this.memWork,
    required this.ledger,
  });

  factory LedgerViewModel.fromJson(Map<String, dynamic> json) {
    // 'ledger' பட்டியலை LedgerEntry பொருளாக மாற்றுதல்
    var ledgerList = (json['ledger'] as List<dynamic>?)
        ?.map((entryJson) => LedgerEntry.fromJson(entryJson))
        .toList() ?? [];

    return LedgerViewModel(
      cityName: json['CityName'] ?? '',
      memMobileNo: json['memMobileNo'] ?? '',
      memName: json['memName'] ?? '',
      memEdu: json['MemEdu'] ?? '',
      memIni: json['memIni'] ?? '',
      memSpouse: json['memSpouse'] ?? '',
      memWork: json['memWork'] ?? '',
      ledger: ledgerList,
    );
  }
}
