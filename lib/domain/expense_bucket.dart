import 'package:expense_tracker/domain/expense.dart';

class ExpenseBucket {
  final Category category;
  final List<Expense> expenses;

  ExpenseBucket({
    required this.category,
    required this.expenses,
  });

  ExpenseBucket.forCategory({
    List<Expense> allExpenses = const [],
    required this.category,
  }) : expenses = allExpenses.where((expense) => expense.category == category).toList();

  double get totalAmount {
    return expenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }
}