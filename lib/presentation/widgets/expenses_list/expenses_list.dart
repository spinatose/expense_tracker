import 'package:expense_tracker/presentation/widgets/expenses_list/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:expense_tracker/domain/expense.dart';

class ExpensesList extends StatelessWidget {
  final List<Expense> expenses;

  const ExpensesList({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (context, index) => ExpenseItem(expense: expenses[index]),
      ),
    );
  }
}
