import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final dateFormatter = DateFormat.yMd();
const Uuid uuid = Uuid();

enum Category {
  food,
  travel,
  leisure,
  bills,
  other,
}

const categoryIcons = {
  Category.food: Icons.local_grocery_store_outlined,
  Category.travel: Icons.emoji_transportation,
  Category.leisure: Icons.movie,
  Category.bills: Icons.receipt,
  Category.other: Icons.question_mark,
};

class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get formattedDate {
    return dateFormatter.format(date);
  } 

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