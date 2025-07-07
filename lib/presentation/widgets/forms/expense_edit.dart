import 'package:expense_tracker/domain/expense.dart';
import 'package:flutter/material.dart';

class ExpenseEdit extends StatefulWidget {
  final void Function(String title, double amount, DateTime date) onSubmit;

  ExpenseEdit({super.key, required this.onSubmit});

  @override
  State<ExpenseEdit> createState() => _ExpenseEditState();
}

class _ExpenseEditState extends State<ExpenseEdit> {
  final titleController = TextEditingController(text: 'New Expense');
  final amountController = TextEditingController(text: '0.0');
  final dateController = TextEditingController(
    text: dateFormatter.format(DateTime.now()),
  );

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            maxLength: 50,
            decoration: const InputDecoration(
              label: Text('Title'),
            ), // Label for the title field
            //onChanged: (value) => widget.title = value, // Update title on change
            controller: titleController,
          ),
          const SizedBox(height: 8.0),
          Row(children: [
            Expanded(child: 
              TextField(
                decoration: const InputDecoration(
                  label: Text('Amount'),
                  prefixText: '\$',
                ),
                keyboardType: TextInputType.number,
                //onChanged: (value) => widget.amount = double.tryParse(value) ?? 0.0, // Update amount on change
                controller: amountController,
              ),
            ),
          ]),
          const SizedBox(height: 16.0),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  final title = titleController.text;
                  final amount = double.tryParse(amountController.text) ?? 0;
                  final date =
                      DateTime.tryParse(dateController.text) ?? DateTime.now();
                  widget.onSubmit(title, amount, date);
                },
                child: const Text('Add Expense'),
              ),
              TextButton(onPressed: () => {
                Navigator.pop(context) // Close the modal without saving
              }, child: const Text('Cancel')),
            ],
          ),
        ],
      ),
    );
  }
}
