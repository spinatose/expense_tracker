import 'package:uuid/uuid.dart';

const Uuid uuid = Uuid();
enum Category {
  food,
  travel,
  leisure,
  bills,
  other,
}

class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  Expense({
    required this.title,
    required this.amount,
    required this.date,
    this.category = Category.other,
  }) : id = uuid.v4();

  @override
  String toString() {
    return 'Expense(id: $id, title: $title, amount: $amount, date: $date)';
  }
}