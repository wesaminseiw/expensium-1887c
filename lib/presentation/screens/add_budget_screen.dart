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
          longTimeSnackBar(context, content: 'Added budget successfully!');
        } else if (state is AddBudgetFailureState) {
          setState(() {
            isLoading = false;
          });
          longTimeSnackBar(context, content: 'Failed to add budget, try again later.');
        } else if (state is AddBudgetFailureEmptyFieldsState) {
          setState(() {
            isLoading = false;
          });
          longTimeSnackBar(context, content: 'Budget cannot be empty!');
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: tertiaryColor,
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 64),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/logos/logo-mini-no-bg.png',
                        width: 96,
                        height: 96,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Final step,',
                        style: TextStyle(
                          color: secondaryColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Add your initial budget to start using the app!',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 36),
                    ],
                  ),
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
      ),
    );
  }
}
