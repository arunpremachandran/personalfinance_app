import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NewExpense extends StatefulWidget {

   final Function addList;

   NewExpense(this.addList);

  @override
  _NewExpenseState createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final itemController = TextEditingController();
  final amountController = TextEditingController();
  DateTime? _selectedDate;

  Void ? submitData(){
    if(amountController.text.isEmpty){
      return null;
    }
    final enteredTitle = itemController.text;
    final enteredAmount = double.parse(amountController.text);

    if(enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null ){
      return null;
    }
    widget.addList(
        enteredTitle,
        enteredAmount,
        _selectedDate
    );

    Navigator.of(context).pop();
  }

  void presentDatePicker(){
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if(pickedDate == null){
        return null;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Card(
          elevation: 5,
          child: Container(
            padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10,
            ),
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                      labelText: 'Item'
                  ),
                  controller: itemController,
                  onSubmitted: (_) => submitData(),
                ),
                TextField(
                  decoration: InputDecoration(
                      labelText: '\$ amount'
                  ),
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  onSubmitted: (_) => submitData() ,
                ),
                SizedBox(
                  height: 3,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(_selectedDate == null ? 'No date Choosen': 'Picked date: ${DateFormat.yMd().format(_selectedDate!)}',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    TextButton(onPressed: presentDatePicker, child: const Text('Choose Date')),
                  ],
                ),
                ElevatedButton(
                  onPressed: submitData,
                  child: const Text('Add',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}


