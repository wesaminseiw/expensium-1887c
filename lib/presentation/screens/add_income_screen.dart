import 'package:expensium/logic/cubits/combined_cubit/combined_cubit.dart';
import 'package:expensium/logic/cubits/income_cubit/income_cubit.dart';
import 'package:expensium/logic/cubits/budget_cubit/budget_cubit.dart';
import 'package:expensium/presentation/widgets/snackbar.dart';
import 'package:expensium/presentation/widgets/submit_button.dart';
import 'package:expensium/presentation/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AddIncomeScreen extends StatefulWidget {
  const AddIncomeScreen({super.key});

  @override
  State<AddIncomeScreen> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('yyyy/MM/dd');

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<IncomeCubit, IncomeState>(
      listener: (context, state) {
        if (state is AddIncomeSuccessState) {
          snackBar(context, content: 'Added income successfully!');
          Navigator.pop(context);
          context.read<BudgetCubit>().getBudgetValue();
          context.read<CombinedCubit>().getIncomesAndExpenses();
        } else if (state is AddIncomeFailureState) {
          snackBar(context, content: 'Failed to add income!');
        } else if (state is AddIncomeFailureEmptyFieldsState) {
          snackBar(context, content: 'The fields above cannot be empty!');
        }
      },
      builder: (context, state) {
        return state.isLoading == false
            ? GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Scaffold(
                  appBar: AppBar(
                    title: const Text(
                      'Add Income',
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
                          // then add the income
                          context.read<IncomeCubit>().addIncome(
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
