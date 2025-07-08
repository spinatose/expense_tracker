import 'package:expense_tracker/domain/expense.dart';
import 'package:flutter/material.dart';

class ExpenseEdit extends StatefulWidget {
  final void Function(String title, double amount, DateTime date) onSubmit;

  const ExpenseEdit({super.key, required this.onSubmit});

  @override
  State<ExpenseEdit> createState() => _ExpenseEditState();
}

class _ExpenseEditState extends State<ExpenseEdit> {
  final titleController = TextEditingController(text: 'New Expense');
  final amountController = TextEditingController(text: '0.0');
  final dateController = TextEditingController(
    text: dateFormatter.format(DateTime.now()),
  );

  void _selectDate() async {
    final initialDate = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != initialDate) {
      setState(() {
        dateController.text = dateFormatter.format(pickedDate);
      });
    }
  }

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
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    label: Text('Amount'),
                    prefixText: '\$',
                  ),
                  keyboardType: TextInputType.number,
                  //onChanged: (value) => widget.amount = double.tryParse(value) ?? 0.0, // Update amount on change
                  controller: amountController,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text('Select Date'),
                    IconButton(
                      onPressed: _selectDate,
                      icon: const Icon(Icons.calendar_month),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
              TextButton(
                onPressed: () => {
                  Navigator.pop(context), // Close the modal without saving
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
