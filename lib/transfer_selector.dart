import 'dart:math';

import 'package:basic_banking_application/model/TransactionModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'home.dart';
import 'model/Model.dart';

class TransferSelector extends StatefulWidget {
  int? mainCustomerId;
  double avlBalance;

  TransferSelector(this.mainCustomerId, this.avlBalance);

  @override
  State<TransferSelector> createState() => _HomeState();
}

class _HomeState extends State<TransferSelector> {
  List<Map<String, dynamic>> customers = [];
  TextEditingController transferMoneyController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    getAllCustomer();
    super.initState();
  }

  void getAllCustomer() {
    DatabaseHelper()
        .getAllTransferCustomer(widget.mainCustomerId!)
        .then((value) {
      setState(() {
        customers = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            Column(
              children: [
                Container(
                    margin: EdgeInsets.only(top: 10, left: 20),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Transfer to:",
                      style: TextStyle(fontSize: 17, color: Colors.red),
                    )),
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
                      : Card(
                          elevation: 5,
                          shape: BeveledRectangleBorder(
                              side: BorderSide(
                                  color: Colors.blueAccent, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: ListTile(
                            onTap: () {
                              _displayTransferMoneyDialog(
                                  widget.mainCustomerId,
                                  customerModel.customerAccountNumber,
                                  widget.avlBalance);
                            },
                            title: Text("${customerModel.customerName}"),
                            leading: Icon(
                              Icons.supervised_user_circle,
                              color: Colors.green,
                              size: 40,
                            ),
                            trailing: IconButton(
                              iconSize: 40,
                              onPressed: () {
                                _displayTransferMoneyDialog(
                                    widget.mainCustomerId,
                                    customerModel.customerAccountNumber,
                                    widget.avlBalance);
                              },
                              icon: Image.asset(
                                "assets/images/transfer_icon.png",
                              ),
                            ),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "Account Number:${customerModel.customerAccountNumber}"),
                              ],
                            ),
                          ),
                        );
                })
          ],
        ),
      ),
    ));
  }

  Future<void> _displayTransferMoneyDialog(int? mainCustomerId,
      String customerAccountNumber, double availableBalance) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Enter Transfer Amount.',
              style: TextStyle(fontSize: 15),
            ),
            content: Form(
              key: formKey,
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter transfer amount';
                  } else if (transferMoneyController.text == "0") {
                    return 'Enter amount more then 0';
                  } else if (double.parse(transferMoneyController.text) >
                      availableBalance) {
                    return 'Amount not available.';
                  }
                  return null;
                },
                controller: transferMoneyController,
                decoration: InputDecoration(
                    hintText: "Enter Amount.",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Colors.grey), //<-- SEE HERE
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Colors.grey), //<-- SEE HERE
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Colors.red), //<-- SEE HERE
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Colors.grey), //<-- SEE HERE
                    )),
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                  color: Colors.red,
                  textColor: Colors.white,
                  child: const Text('CANCEL'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              MaterialButton(
                  color: Colors.green,
                  textColor: Colors.white,
                  child: const Text('TRANSFER'),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Navigator.pop(context);

                      DatabaseHelper().transferMoney(
                          mainCustomerId!,
                          customerAccountNumber,
                          double.parse(
                              transferMoneyController.text.toString()));

                      DateTime now = new DateTime.now();

                      Random random = new Random();
                      int id = random.nextInt(99999);

                      TransactionModel tm =    TransactionModel(
                          transactionId: id,
                          fromAccountNumber: mainCustomerId,
                          beneficiaryAccountNumber:
                              int.parse(customerAccountNumber),
                          transactionAmount: double.tryParse(
                              transferMoneyController.text.toString()),
                          transactionDate:
                              new DateTime(now.year, now.month, now.day)
                                  .toString(),
                          transactionType: "ONLINE");


                      var map = tm.toJson();
                      DatabaseHelper().insertInTransaction(map);

                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              contentPadding: EdgeInsets.zero,
                              title: Column(
                                children: [
                                  Image.asset("assets/images/success_gif.gif"),
                                  Text(
                                    "Transaction successful",
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ],
                              ),
                              actionsAlignment: MainAxisAlignment.center,
                              actions: [
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .popUntil((route) => route.isFirst);
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder: (context) {
                                        return Home();
                                      }));
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.green),
                                    ),
                                    child: const Text("GO TO HOME PAGE"))
                              ],
                            );
                          });
                    }
                  }),
            ],
          );
        });
  }
}
