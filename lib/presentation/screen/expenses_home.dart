import 'package:expense_tracker/presentation/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/domain/expense.dart';
import 'package:expense_tracker/presentation/widgets/forms/expense_edit.dart';
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
    Expense(
      title: 'Tree Service',
      amount: 600.0,
      date: DateTime.now(),
      category: Category.other,
    ),
  ];

  void _openAddExpenseModal() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return ExpenseEdit(onSubmit: (expense) => { 
          setState(() {
            _expenses.add(expense);
          }),
          Navigator.of(ctx).pop(), // Close the modal after adding the expense
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsPadding: const EdgeInsets.only(right: 40.0),
        title: const Text('Expenses Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _openAddExpenseModal,
          ),
        ],
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
