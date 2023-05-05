import 'package:basic_banking_application/model/TransactionModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'database_helper.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({Key? key}) : super(key: key);

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  List<Map<String, dynamic>> history = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(

      appBar: AppBar(
        title: Text("Transaction History"),
      ),

      body:history.length < 1?Center(
        child: Text("History Not Available"),
      ): ListView.builder(
          itemCount: history.length,
          itemBuilder: (context,index){

            TransactionModel tm =
            TransactionModel.fromJson(history[index]);
            
            return Padding(
              padding: EdgeInsets.all(10),
            child:Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(

                    children: [

                      Row(
                        children: [

                          Text("Transaction Id : ",style: TextStyle(fontWeight: FontWeight.bold),),
                          Text(tm.transactionId.toString())
                        ],
                      ),

                      SizedBox(height: 7,),

                      Row(
                        children: [

                          Text("Debit From: ",style: TextStyle(fontWeight: FontWeight.bold),),
                          Text(tm.fromAccountNumber.toString())
                        ],
                      ),

                      SizedBox(height: 7,),

                      Row(
                        children: [

                          Text("Credit To: ",style: TextStyle(fontWeight: FontWeight.bold),),
                          Text(tm.beneficiaryAccountNumber.toString())
                        ],
                      ),

                      SizedBox(height: 7,),

                      Row(
                        children: [
                          Text("Transaction Amount: ",style: TextStyle(fontWeight: FontWeight.bold),),
                          Text(tm.transactionAmount.toString())
                        ],
                      ),

                      SizedBox(height: 7,),

                      Row(
                        children: [
                          Text("Transaction Type: ",style: TextStyle(fontWeight: FontWeight.bold),),
                          Text(tm.transactionType.toString())
                        ],
                      ),

                      SizedBox(height: 7,),

                      Row(
                        children: [
                          Text("Transaction Date: ",
                            style: TextStyle(fontWeight: FontWeight.bold),),
                          Text(tm.transactionDate.toString().replaceAll("00:00:00.000", ""))
                        ],
                      )
                    ],
                ),
              ),
            ),);

      }),
    ));
  }

  @override
  void initState() {
    getAllCustomer();
    super.initState();
  }

  void getAllCustomer() {
    DatabaseHelper().getAllTransactionHistory().then((value) {
      setState(() {
        history = value;

        print(value);
      });
    });
  }

}
