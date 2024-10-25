import 'package:expensium/logic/cubits/budget_cubit/budget_cubit.dart';
import 'package:expensium/presentation/styles/colors.dart';
import 'package:expensium/presentation/widgets/snackbar.dart';
import 'package:expensium/presentation/widgets/submit_button.dart';
import 'package:expensium/presentation/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddBudgetScreen extends StatefulWidget {
  const AddBudgetScreen({super.key});

  @override
  State<AddBudgetScreen> createState() => _AddBudgetScreenState();
}

class _AddBudgetScreenState extends State<AddBudgetScreen> {
  final TextEditingController _budgetController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<BudgetCubit, BudgetState>(
      listener: (context, state) {
        if (state is AddBudgetLoadingState) {
          setState(() {
            isLoading = true;
          });
        } else if (state is AddBudgetSuccessState) {
          setState(() {
            isLoading = false;
          });
          snackBar(context, content: 'Added budget successfully!');
        } else if (state is AddBudgetFailureState) {
          setState(() {
            isLoading = false;
          });
          snackBar(context, content: 'Failed to add budget, try again later.');
        } else if (state is AddBudgetFailureEmptyFieldsState) {
          setState(() {
            isLoading = false;
          });
          snackBar(context, content: 'Budget cannot be empty!');
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: tertiaryColor,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: tertiaryColor,
            title: Text(
              'Add Budget',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: firstTextColor,
                fontSize: 28,
              ),
            ),
          ),
          body: Column(
            children: [
              const SizedBox(height: 64),
              Row(
                children: [
                  const SizedBox(width: 16),
                  Text(
                    'Final step! Add your initial budget',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: secondTextColor,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              textField(
                controller: _budgetController,
                hintText: 'Initial Budget..',
                keyboardType: TextInputType.number,
                fillColor: quaternaryColor,
                filled: true,
                borderSide: BorderSide.none,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              isLoading == false
                  ? submitButton(
                      context,
                      label: 'Confirm',
                      buttonColor: secondaryColor,
                      textColor: tertiaryColor,
                      onTap: () {
                        context.read<BudgetCubit>().addBudget(
                              context,
                              budgetController: _budgetController,
                            );
                      },
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
