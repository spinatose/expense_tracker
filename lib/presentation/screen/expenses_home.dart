import 'package:expense_tracker/presentation/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/domain/expense.dart';
import 'package:flutter/material.dart';

class ExpensesHome extends StatefulWidget {
  const ExpensesHome({super.key});

  @override
  State<ExpensesHome> createState() => _ExpensesHomeState();
}

class _ExpensesHomeState extends State<ExpensesHome> {
  final List<Expense> _expenses = [
    Expense(
      title: 'Groceries',
      amount: 50.0,
      date: DateTime.now(),
      category: Category.food,
    ),
    Expense(
      title: 'Bus Ticket',
      amount: 2.5,
      date: DateTime.now(),
      category: Category.travel,
    ),
    Expense(
      title: 'Movie Night',
      amount: 15.0,
      date: DateTime.now(),
      category: Category.leisure,
    ),
    Expense(
      title: 'Electricity Bill',
      amount: 75.0,
      date: DateTime.now(),
      category: Category.bills,
    ),
  ];

  // void _addExpense(String expense) {
  //   setState(() {
  //     _expenses.add(expense);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses Tracker'),
      ),
      body: Column(
        children: [
          Text('Chart'),
          ExpensesList(expenses: _expenses),
        ],
      ),
    );
  }
}