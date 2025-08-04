import 'package:expense_tracker/presentation/screen/expenses_home.dart';
import 'package:flutter/material.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: Color.fromARGB(255, 96, 59, 181)
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expenses Tracker',
      theme: ThemeData().copyWith(colorScheme: kColorScheme),
      home: const ExpensesHome(
        // This home is the widget that will be displayed when the app starts.
        // You can change this to any widget you want, such as a custom home
        // page or a navigation drawer.
        key: Key('expenses_home'),
      ),
    );
  }
}
