import 'package:expensium/app/router.dart';
import 'package:expensium/logic/cubits/budget_cubit/budget_cubit.dart';
import 'package:expensium/presentation/styles/colors.dart';
import 'package:expensium/presentation/widgets/circular_indicator.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BudgetCubit, BudgetState>(
      listener: (context, state) {
        if (state is AddBudgetLoadingState) {
        } else if (state is AddBudgetSuccessState) {
          longTimeSnackBar(context, content: 'Added budget successfully!');
          AppRouter.offHome();
        } else if (state is AddBudgetFailureState) {
          longTimeSnackBar(context, content: 'Failed to add budget, try again later.');
        } else if (state is AddBudgetFailureEmptyFieldsState) {
          longTimeSnackBar(context, content: 'Budget cannot be empty!');
        }
      },
      builder: (context, state) {
        return GestureDetector(
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
                  state.isLoading == false
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
                      : loading(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
