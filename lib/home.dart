import 'package:basic_banking_application/transfer_selector.dart';
import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'database_helper.dart';
import 'model/Model.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> customers = [];

  @override
  void initState() {
    getAllCustomer();
    super.initState();
  }

  void getAllCustomer() {
    DatabaseHelper().queryAllRows().then((value) {
      setState(() {
        customers = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("HOME PAGE")
        ,
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            Column(
              children: [
                Container(
                    margin: EdgeInsets.only(top: 10),
                    alignment: Alignment.topCenter,
                    child: Text("ALL CUSTOMER")),
                Divider(
                  thickness: 2,
                ),
              ],
            ),
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: customers.length,
                itemBuilder: (contex, i) {
                  CustomerModel customerModel =
                      CustomerModel.fromJson(customers[i]);

                  return customers.length < 1
                      ? Container(
                          alignment: Alignment.center,
                          child: const Text("Customer Not Available."),
                        )
                      : Padding(
                        padding:  EdgeInsets.only(left: 5,right: 5),
                        child: Card(
                            elevation: 5,
                          shape:  BeveledRectangleBorder(
                                side: BorderSide(color: Colors.blueAccent, width: 1),
                                borderRadius:  BorderRadius.all(Radius.circular(5))),
                            child: Container(
                              margin: EdgeInsets.all(0),
                              child: ListTile(
                                onTap: (){

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TransferSelector(customerModel.customerId,customerModel.balance),
                                      ));
                                },
                                title: Text("${customerModel.customerName}"),
                                leading: Icon(
                                  Icons.supervised_user_circle,
                                  color: Colors.deepPurple,
                                  size: 40,
                                ),
                                subtitle: Text(
                                    "AC Number:${customerModel.customerAccountNumber}"),

                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "₹",style: TextStyle(
                                        color:customerModel.balance <1 ? Colors.red: Colors.green
                                    ),),

                                    Text(
                                      "${customerModel.balance}",style: TextStyle(
                                         color:customerModel.balance <1 ? Colors.red: Colors.green
                                    ),),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      );
                })
          ],
        ),
      ),
    ));
  }
}
