import 'package:expensium/logic/cubits/combined_cubit/combined_cubit.dart';
import 'package:expensium/logic/cubits/expense_cubit/expense_cubit.dart';
import 'package:expensium/logic/cubits/budget_cubit/budget_cubit.dart';
import 'package:expensium/logic/cubits/get_weekly_budget_cubit/get_weekly_budget_cubit.dart';
import 'package:expensium/presentation/styles/colors.dart';
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
          shortTimeSnackBar(context, content: 'Added expense successfully!');
          Navigator.pop(context);
          context.read<BudgetCubit>().getBudgetValue();
          context.read<CombinedCubit>().getIncomesAndExpenses();
          context.read<GetWeeklyBudgetCubit>().getWeeklyDifference();
        } else if (state is AddExpenseFailureState) {
          shortTimeSnackBar(context, content: 'Failed to add expense!');
        } else if (state is AddExpenseFailureEmptyFieldsState) {
          shortTimeSnackBar(context, content: 'The fields above cannot be empty!');
        } else if (state is AddExpenseFailureNoSufficientFundsState) {
          shortTimeSnackBar(
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
                  backgroundColor: tertiaryColor,
                  resizeToAvoidBottomInset: false,
                  appBar: AppBar(
                    backgroundColor: tertiaryColor,
                    leading: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 8),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Image.asset(
                          'assets/images/home.png',
                          color: primaryColor,
                          width: 28,
                          height: 28,
                        ),
                      ),
                    ),
                    automaticallyImplyLeading: false,
                  ),
                  body: Column(
                    children: [
                      const SizedBox(height: 96),
                      Row(
                        children: [
                          const SizedBox(width: 16),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Add Expense',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: secondTextColor,
                                  fontSize: 28,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Here can you add your expenses, don\'t\nforget to add all what is required',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade600,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      textField(
                        controller: _titleController,
                        hintText: 'Title..',
                        fillColor: quaternaryColor,
                        filled: true,
                        borderSide: BorderSide.none,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: textField(
                              controller: _amountController,
                              hintText: 'Amount..',
                              keyboardType: TextInputType.number,
                              fillColor: quaternaryColor,
                              filled: true,
                              borderSide: BorderSide.none,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: textField(
                              controller: _dateController,
                              hintText: 'Date..',
                              readOnly: true,
                              fillColor: quaternaryColor,
                              filled: true,
                              borderSide: BorderSide.none,
                              textAlign: TextAlign.center,
                              onTap: () async {
                                final DateTime? selectedDate = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime.now().subtract(
                                    const Duration(days: 365),
                                  ),
                                  lastDate: DateTime.now().add(const Duration(days: 1)),
                                  initialDate: DateTime.now(),
                                );
                                if (selectedDate != null) {
                                  final String formattedDate = _dateFormat.format(selectedDate);
                                  _dateController.text = formattedDate;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      submitButton(
                        context,
                        label: 'Add Expense',
                        buttonColor: secondaryColor,
                        textColor: tertiaryColor,
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
