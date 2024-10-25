import 'package:expensium/logic/cubits/budget_cubit/budget_cubit.dart';
import 'package:expensium/logic/cubits/combined_cubit/combined_cubit.dart';
import 'package:expensium/logic/cubits/user_actions_cubit/user_actions_cubit.dart';
import 'package:expensium/presentation/styles/colors.dart';
import 'package:expensium/presentation/widgets/snackbar.dart';
import 'package:expensium/presentation/widgets/submit_button.dart';
import 'package:expensium/presentation/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _newBudgetController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BudgetCubit, BudgetState>(
      builder: (context, state) {
        _newBudgetController.text = state.budget.toStringAsFixed(2).toString();
        return MultiBlocListener(
          listeners: [
            BlocListener<UserActionsCubit, UserActionsState>(
              listener: (context, state) {
                if (state is UserActionsSignOutSuccessState) {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/login');
                } else if (state is UserActionsDeleteUserSuccessState) {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
            ),
            BlocListener<BudgetCubit, BudgetState>(
              listener: (context, state) {
                if (state is UpdateBudgetSuccessState) {
                  context.read<CombinedCubit>().getIncomesAndExpenses();
                  context.read<BudgetCubit>().getBudgetValue();
                  snackBar(context, content: 'Budget updated successfully!');
                }
              },
            ),
          ],
          child: Scaffold(
            backgroundColor: tertiaryColor,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: tertiaryColor,
              title: Text(
                'Settings',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: firstTextColor,
                  fontSize: 28,
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: GestureDetector(
                    onTap: () {
                      context.read<BudgetCubit>().updateBudget(newBudgetController: _newBudgetController);
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
              ],
              automaticallyImplyLeading: false,
            ),
            body: Stack(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 48),
                    Row(
                      children: [
                        const SizedBox(width: 16),
                        Text(
                          'Update Your Budget',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: secondTextColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Current Budget: ',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: secondTextColor,
                          ),
                        ),
                        Text(
                          state.budget.toStringAsFixed(2),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: secondTextColor,
                          ),
                        ),
                        Text(
                          ' LE',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: secondTextColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    textField(
                      controller: _newBudgetController,
                      hintText: 'Enter your new budget..',
                      fillColor: quaternaryColor,
                      filled: true,
                      borderSide: BorderSide.none,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),
                    Row(
                      children: [
                        const SizedBox(width: 16),
                        Text(
                          'User Actions',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: secondTextColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    submitButton(
                      context,
                      buttonColor: secondaryColor,
                      textColor: tertiaryColor,
                      label: 'Logout',
                      onTap: () {
                        context.read<UserActionsCubit>().signOut(context);
                      },
                    ),
                    const SizedBox(height: 24),
                    submitButton(
                      context,
                      buttonColor: const Color.fromARGB(255, 182, 12, 0),
                      textColor: tertiaryColor,
                      label: 'DELETE ACCOUNT',
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                'Are you sure you want to delete all your account? This action cannot be undone.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                    await context.read<UserActionsCubit>().deleteUser(context);
                                  },
                                  child: const Text('Yes'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
