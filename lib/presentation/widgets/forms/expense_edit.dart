import 'package:expense_tracker/domain/expense.dart';
import 'package:flutter/material.dart';

class ExpenseEdit extends StatefulWidget {
  final void Function(Expense expense) onSubmit;

  const ExpenseEdit({super.key, required this.onSubmit});

  @override
  State<ExpenseEdit> createState() => _ExpenseEditState();
}

class _ExpenseEditState extends State<ExpenseEdit> {
  final titleController = TextEditingController(text: 'New Expense');
  final amountController = TextEditingController(text: '0.0');
  DateTime? selectedDate = DateTime.now();
  Category selectedCategory = Category.other;

  void _selectDate() async {
    final initialDate = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(
        initialDate.year - 1,
        initialDate.month,
        initialDate.day,
      ),
      lastDate: DateTime(
        initialDate.year + 1,
        initialDate.month,
        initialDate.day,
      ),
    );

    if (pickedDate != null && pickedDate != initialDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void _submit() {
    final title = titleController.text.trim();
    final amount = double.tryParse(amountController.text) ?? 0;

    if (title.isEmpty || amount <= 0 || selectedDate == null) {
      // Show an error message or handle invalid input
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text(
      //       'Title must not be empty; amount must be greater than 0; a date must be selected.',
      //     ),
      //   ),
      // );

      showDialog(context: context, builder: (ctx)  => 
        AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text(
            'Title must not be empty; amount must be greater than 0; a date must be selected.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Ok'),
            ),
          ],
        ),
      );
      return;
    }
    
    Expense expense = Expense(
      title: title,
      amount: amount,
      date: selectedDate!,
      category: selectedCategory,
    );

    widget.onSubmit(expense);
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 48, 16, 16),
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
              const SizedBox(width: 8.0),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        selectedDate != null
                            ? dateFormatter.format(selectedDate!)
                            : DateTime.now().toString(),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(child: const Text('Select Date')),
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
              DropdownButton(
                items: Category.values
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category.name),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value is Category) {
                    setState(() {
                      selectedCategory = value;
                    });
                  }
                },
                value: selectedCategory,
              ),
              const SizedBox(width: 50.0),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Add Expense'),
              ),
              TextButton(
                onPressed: () => {
                  Navigator.pop(context), // Close the modal without saving
                },
                child: Expanded(child: const Text('Cancel')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
