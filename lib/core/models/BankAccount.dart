class BankAccount {
  final String? objectId;
  final String? iban;
  final String? bic;

  BankAccount({
    this.objectId,
    this.iban,
    this.bic,
  });

  factory BankAccount.fromJson(json) {
    return BankAccount(
      objectId: json['objectId'],
      iban: json['iban'],
      bic: json['bic'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'objectId': objectId,
      'iban': iban,
      'bic': bic,
    };
  }

  static Future<BankAccount> fromMap(bankAccount) {
    return Future.value(BankAccount.fromJson(bankAccount));
  }
}
