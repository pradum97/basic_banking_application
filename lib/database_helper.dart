import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const _databaseName = "MyDatabase.db";
  static const _databaseVersion = 1;
  static const table = 'tbl_customers';

  String customerId = "customer_id";
  String customerName = "customer_name";
  String customerFatherName = "customer_father_name";
  String customerMotherName = "customer_mother_name";
  String customerDateOfBirth = "customer_dob";
  String customerAddress = "customer_address";
  String customerPhone = "customer_phone";
  String customerEmail = "customer_email";
  String customerAccountNumber = "customer_account_number";
  String balance = "balance";

  static Database? _db;

  Future<void> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);

    _db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $customerId INTEGER PRIMARY KEY,
            $customerName TEXT NOT NULL,
            $customerFatherName TEXT NOT NULL,
            $customerMotherName TEXT NOT NULL,
            $customerDateOfBirth TEXT NOT NULL,
            $customerAddress TEXT NOT NULL,
            $customerPhone TEXT NOT NULL,
            $customerEmail TEXT NOT NULL,
            $customerAccountNumber TEXT UNIQUE NOT NULL,
            $balance NUMERIC NOT NULL
          )
          ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    return await _db!.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    return await _db!.query(table);
  }

  Future<List<Map<String, dynamic>>> getAllTransferCustomer(
      int customer_id) async {
    return await await _db!.rawQuery(
        'SELECT * FROM $table where $customerId NOT IN ($customer_id)');
  }

  Future<List<Map<String, dynamic>>> getCustomerById(int customer_id) async {
    return await await _db!.rawQuery(
        'SELECT COUNT(*) FROM $table where $customerId = $customer_id');
  }

  Future<int> queryRowCount() async {
    final results = await _db!.rawQuery('SELECT COUNT(*) FROM $table');
    return Sqflite.firstIntValue(results) ?? 0;
  }

  Future<double> checkBalanceByCustomerId(int customer_id) async {
    final results = await _db!.rawQuery(
        'SELECT $balance FROM $table where $customerId = $customer_id');
    List<Map<String, dynamic>> data = results;
    return double.parse(data[0][balance].toString());
  }

  Future<void> transferMoney(int mainCustomerId,
      String beneficiaryAccountNumber, double transferMoney) async {
    await _db!.rawUpdate(
        "UPDATE $table set $balance = $balance-? where $customerId = ?",
        [transferMoney, mainCustomerId]);

    await _db!.rawUpdate(
        "UPDATE $table set $balance = $balance + ? where $customerAccountNumber = ?",
        [transferMoney, beneficiaryAccountNumber]);
  }
}
