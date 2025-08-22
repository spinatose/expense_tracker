import 'package:expense_tracker/domain/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

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

  void _showInvalidInputDialog() {
      if (Platform.isIOS) {
      showCupertinoDialog(context: context, builder: (ctx) => CupertinoAlertDialog(
          title: Text('Invalid Input', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
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
      } else {
      showDialog(context: context, builder: (ctx)  => 
        AlertDialog(
          title: Text('Invalid Input', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
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

      _showInvalidInputDialog();

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
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
      
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 48, 16, keyboardHeight + 16),
          child: Column(
            children: [
              TextField(
                maxLength: 50,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                decoration: const InputDecoration(
                  label: Text('Title'),
                ), // Label for the title field
                //onChanged: (value) => widget.title = value, // Update title on change
                controller: titleController,
              ),
              const SizedBox(height: 8.0),
              // Responsive layout for amount and date picker
              LayoutBuilder(
                key: const ValueKey('amount_date_layout'),
                builder: (context, constraints) {
                  // If screen is narrow (portrait), stack vertically
                  if (constraints.maxWidth < 400) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          decoration: const InputDecoration(
                            label: Text('Amount'),
                            prefixText: '\$',
                          ),
                          keyboardType: TextInputType.number,
                          controller: amountController,
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                selectedDate != null
                                    ? dateFormatter.format(selectedDate!)
                                    : DateTime.now().toString(),
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: _selectDate,
                              icon: const Icon(Icons.calendar_month),
                              label: const Text('Select Date'),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                  // If screen is wide (landscape), use horizontal layout
                  return Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          decoration: const InputDecoration(
                            label: Text('Amount'),
                            prefixText: '\$',
                          ),
                          keyboardType: TextInputType.number,
                          controller: amountController,
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              selectedDate != null
                                  ? dateFormatter.format(selectedDate!)
                                  : DateTime.now().toString(),
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            TextButton.icon(
                              onPressed: _selectDate,
                              icon: const Icon(Icons.calendar_month),
                              label: const Text('Select Date'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16.0),
              // Responsive layout for category dropdown and buttons
              LayoutBuilder(
                key: const ValueKey('category_buttons_layout'),
                builder: (context, constraints) {
                  // If screen is narrow (portrait), stack vertically
                  if (constraints.maxWidth < 400) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField<Category>(
                          decoration: const InputDecoration(
                            labelText: 'Category',
                          ),
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          items: Category.values
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(
                                    category.name,
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ),
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
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _submit,
                                child: const Text('Add Expense'),
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: TextButton(
                                onPressed: () => {
                                  Navigator.pop(context),
                                },
                                child: const Text('Cancel'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                  // If screen is wide (landscape), use horizontal layout
                  return Row(
                    children: [
                      Expanded(
                        child: DropdownButton<Category>(
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          items: Category.values
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(
                                    category.name,
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ),
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
                      ),
                      const SizedBox(width: 16.0),
                      ElevatedButton(
                        onPressed: _submit,
                        child: const Text('Add Expense'),
                      ),
                      const SizedBox(width: 16.0),
                      TextButton(
                        onPressed: () => {
                          Navigator.pop(context),
                        },
                        child: const Text('Cancel'),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
