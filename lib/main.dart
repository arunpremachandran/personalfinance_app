import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance/widgets/chart.dart';
import 'package:personal_finance/widgets/expense_list.dart';
import 'package:personal_finance/widgets/new_expense.dart';
import 'model/expense.dart';
import 'package:flutter/foundation.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Finance',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
          titleLarge: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
            fontSize: 15
          ),
        ),
        appBarTheme: AppBarTheme(
         titleTextStyle: TextStyle(
           fontFamily: 'OpenSans',
           fontWeight: FontWeight.bold,
           fontSize: 20
         ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showChart = false;
  final List<Expense> _expense= [
    // Expense(
    //     id: 1,
    //     title: 'Grocery expense',
    //     amount: 64.99,
    //     date: DateTime.now()
    // ),
    // Expense(
    //     id: 1,
    //     title: 'Home expense',
    //     amount: 64.99,
    //     date: DateTime.now()
    // ),
  ];

  List <Expense> get  _recentTransactions{
    return _expense.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
            Duration(days: 7),
        ),
      );
    }).toList();
  }

  void deleteItem(String id){
    setState(() {
      _expense.removeWhere((ex) => ex.id == id);
    });
  }

  void addList(String exTitle, double exAmount, DateTime selectedDate){
    final newEx = Expense(
      id: DateTime.now().toString(),
      amount: exAmount,
      title: exTitle,
      date: selectedDate,
    );

    setState(() {
      _expense.add(newEx);
    });
  }
  void startAddNewTransaction(BuildContext ctx){
    showModalBottomSheet(context: ctx, builder:(_){
        return  GestureDetector(
            onTap: () {},
            child: NewExpense(addList),
            behavior: HitTestBehavior.opaque,
        );
    });
  }

  Widget _buildLandscapeContent(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Show Chart'),
        Switch.adaptive(value: _showChart, onChanged: (val)=>{
          setState((){
            _showChart = val;
          })
        }),
      ],
    );
  }

  Widget _buildPortraitContent(MediaQueryData mediaQuery, AppBar appbar){
    return Container(
      height: (MediaQuery.of(context).size.height - appbar.preferredSize.height - mediaQuery.padding.top) * 0.3,
      child:  Chart(_recentTransactions),
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final mediaQuery = MediaQuery.of(context);
    var appbar = AppBar(
      title: Text('Personal Finance'),
    );
    final expListWidget = Container(
      height: (MediaQuery.of(context).size.height - appbar.preferredSize.height - mediaQuery.padding.top) * 0.5,
      child: ExpenseList(_expense, deleteItem),
    );
    return Scaffold(
          resizeToAvoidBottomInset : true,
          appBar: appbar,
          body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  if(isLandscape) _buildLandscapeContent(),
                   if(!isLandscape) _buildPortraitContent(mediaQuery, appbar),
                   if(!isLandscape) expListWidget,
                   if(isLandscape) _showChart ?
                   Container(
                    height: (MediaQuery.of(context).size.height - appbar.preferredSize.height - mediaQuery.padding.top) * 0.6,
                    child:  Chart(_recentTransactions),
                  ) : expListWidget,
                  SizedBox(
                    height: (MediaQuery.of(context).size.height - appbar.preferredSize.height - mediaQuery.padding.top) * 0.1,
                  ),
                ]
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () => startAddNewTransaction(context),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
  }
}

