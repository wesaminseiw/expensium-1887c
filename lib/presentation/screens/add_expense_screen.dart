import 'package:expensium/logic/cubits/combined_cubit/combined_cubit.dart';
import 'package:expensium/logic/cubits/expense_cubit/expense_cubit.dart';
import 'package:expensium/logic/cubits/budget_cubit/budget_cubit.dart';
import 'package:expensium/presentation/widgets/snackbar.dart';
import 'package:expensium/presentation/widgets/submit_button.dart';
import 'package:expensium/presentation/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('yyyy/MM/dd');

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExpenseCubit, ExpenseState>(
      listener: (context, state) {
        if (state is AddExpenseSuccessState) {
          snackBar(context, content: 'Added expense successfully!');
          Navigator.pop(context);
          context.read<BudgetCubit>().getBudgetValue();
          context.read<CombinedCubit>().getIncomesAndExpenses();
        } else if (state is AddExpenseFailureState) {
          snackBar(context, content: 'Failed to add expense!');
        } else if (state is AddExpenseFailureEmptyFieldsState) {
          snackBar(context, content: 'The fields above cannot be empty!');
        } else if (state is AddExpenseFailureNoSufficientFundsState) {
          snackBar(
            context,
            content: 'The expense amount is larger than your budget!',
          );
        }
      },
      builder: (context, state) {
        return state.isLoading == false
            ? GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Scaffold(
                  appBar: AppBar(
                    title: const Text(
                      'Add Expense',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  body: Column(
                    children: [
                      const SizedBox(height: 36),
                      textField(
                        controller: _titleController,
                        hintText: 'Title..',
                      ),
                      const SizedBox(height: 24),
                      textField(
                        controller: _amountController,
                        hintText: 'Amount..',
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 24),
                      textField(
                        controller: _dateController,
                        hintText: 'Date..',
                        readOnly: true,
                        onTap: () async {
                          final DateTime? selectedDate = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now().subtract(
                              const Duration(days: 365),
                            ),
                            lastDate: DateTime(2100),
                            initialDate: DateTime.now(),
                          );
                          if (selectedDate != null) {
                            final String formattedDate =
                                _dateFormat.format(selectedDate);
                            _dateController.text = formattedDate;
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      submitButton(
                        context,
                        label: 'Add',
                        onTap: () async {
                          // then add the expense
                          context.read<ExpenseCubit>().addExpense(
                                title: _titleController.text,
                                amountController: _amountController,
                                dateController: _dateController,
                              );
                        },
                      ),
                    ],
                  ),
                ),
              )
            : const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
      },
    );
  }
}
