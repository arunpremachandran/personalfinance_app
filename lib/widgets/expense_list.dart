import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/expense.dart';

class ExpenseList extends StatelessWidget{
  final List<Expense> expenses;
  final Function deleteItem;
  ExpenseList(this.expenses, this.deleteItem);

  @override
  Widget build(BuildContext context) {
    return expenses.isEmpty ? LayoutBuilder(builder: (ctx, constraints){
      return Column(
        children: <Widget>[
          SizedBox(
            height: 5,
          ),
          Center(
            child: Text(
              'No tansactions added yet!',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: constraints.maxHeight * 0.6,
            child: Image.asset('assets/images/waiting.png',
              fit: BoxFit.cover,
            ),
          ),
        ],
      );
    }) : ListView.builder(
        itemBuilder: (exps, index){
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
            elevation: 6,
            child: ListTile(
              leading: CircleAvatar(
                radius: 20,
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: FittedBox(
                    child: Text('\$ ${expenses[index].amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              title: Text(expenses[index].title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              subtitle: Text(DateFormat.yMMMd().format(expenses[index].date),
              ),
              trailing: MediaQuery.of(context).size.width > 400 ? TextButton.icon(onPressed: () => deleteItem(expenses[index].id),
                icon:Icon(Icons.delete_forever, color: Theme.of(context).errorColor,),
                label: Text('Delete item', style: TextStyle(color: Theme.of(context).errorColor)),) :
              IconButton(onPressed: () => deleteItem(expenses[index].id),
                icon: Icon(Icons.delete_forever, color: Theme.of(context).errorColor),)
            ),
          );
        },
        itemCount: expenses.length,
      );
  }
}

