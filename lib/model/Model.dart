class CustomerModel {
  int customerId;
  String customerName;
  String customerFatherName;
  String customerMotherName;
  String customerDateOfBirth;
  String customerAddress;
  String customerPhone;
  String customerEmail;
  String customerAccountNumber;
  double balance;

  CustomerModel({
    required this.customerId,
    required this.customerName,
    required this.customerFatherName,
    required this.customerMotherName,
    required this.customerDateOfBirth,
    required this.customerAddress,
    required this.customerPhone,
    required this.customerEmail,
    required this.customerAccountNumber,
    required this.balance
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      customerId: json['customer_id'],
      customerName: json['customer_name'],
      customerFatherName: json['customer_father_name'],
      customerMotherName: json['customer_mother_name'],
      customerDateOfBirth: json['customer_dob'],
      customerAddress: json['customer_address'],
      customerPhone: json['customer_phone'],
      customerEmail: json['customer_email'],
      customerAccountNumber: json['customer_account_number'],
      balance: double.parse(json['balance'].toString())
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_id'] = this.customerId;
    data['customer_name'] = this.customerName;
    data['customer_father_name'] = this.customerFatherName;
    data['customer_mother_name'] = this.customerMotherName;
    data['customer_dob'] = this.customerDateOfBirth;
    data['customer_address'] = this.customerAddress;
    data['customer_phone'] = this.customerPhone;
    data['customer_email'] = this.customerEmail;
    data['customer_account_number'] = this.customerAccountNumber;
    data['balance'] = this.balance;
    return data;
  }
}