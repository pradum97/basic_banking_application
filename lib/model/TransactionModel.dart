class TransactionModel {
  int? transactionId;
  int? fromAccountNumber;
  int? beneficiaryAccountNumber;
  double? transactionAmount;
  String? transactionDate;
  String? transactionType;

  TransactionModel({
   required this.transactionId,
  required  this.fromAccountNumber,
   required this.beneficiaryAccountNumber,
   required this.transactionAmount,
   required this.transactionDate,
   required this.transactionType,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      transactionId: json['transactionId'],
      fromAccountNumber: json['fromAccountNumber'],
      beneficiaryAccountNumber: json['beneficiaryAccountNumber'],
      transactionAmount: json['transactionAmount'].toDouble(),
      transactionDate: json['transactionDate'],
      transactionType: json['transactionType'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transactionId'] = this.transactionId;
    data['fromAccountNumber'] = this.fromAccountNumber;
    data['beneficiaryAccountNumber'] = this.beneficiaryAccountNumber;
    data['transactionAmount'] = this.transactionAmount;
    data['transactionDate'] = this.transactionDate;
    data['transactionType'] = this.transactionType;
    return data;
  }
}