import 'package:basic_banking_application/home.dart';
import 'package:basic_banking_application/model/Model.dart';
import 'package:flutter/material.dart';
import 'package:faker/faker.dart';
import 'database_helper.dart';
import 'dart:math';

final dbHelper = DatabaseHelper();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dbHelper.init();
  generateCustomer();
  runApp(MyApp());
}

 Future<void> generateCustomer() async {
  await DatabaseHelper().queryRowCount().then((value) {
    if (value < 10) {
      List<CustomerModel> list = [];

      for (int i = 0; i < 10; i++) {
        var name = faker.person.firstName() + " " + faker.person.lastName();
        var fatherName =
            faker.person.firstName() + " " + faker.person.lastName();
        var email = faker.internet.email();
        var phone = faker.phoneNumber.toString();
        String address = faker.address.streetAddress() +
            "," +
            faker.address.city() +
            "," +
            faker.address.country() +
            "," +
            faker.address.zipCode();

        double balance = Random().nextInt(10000).toDouble();

        CustomerModel model = CustomerModel(
            customerId: i,
            customerName: name,
            customerFatherName: fatherName,
            customerMotherName: "",
            customerDateOfBirth: "21/10/2001",
            customerAddress: address,
            customerPhone: phone,
            customerEmail: email,
            customerAccountNumber: "12$i",
            balance: balance);

        list.add(model);
      }

      print(list.length);

      list.forEach((data) {
        var map = data.toJson();
        DatabaseHelper().insert(map);
      });
    }
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Banking App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}
