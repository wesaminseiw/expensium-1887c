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
        _newBudgetController.text = state.budget.toStringAsFixed(2);
        return MultiBlocListener(
          listeners: [
            BlocListener<UserActionsCubit, UserActionsState>(
              listener: (context, state) {
                if (state is UserActionsSignOutSuccessState || state is UserActionsDeleteUserSuccessState) {
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
                  shortTimeSnackBar(context, content: 'Budget updated successfully!');
                }
              },
            ),
          ],
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              backgroundColor: tertiaryColor,
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
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32), // Space for better alignment
                    Text(
                      'Settings',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 28,
                        color: secondTextColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Manage your budget and user settings below.',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Budget Update Section
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: quaternaryColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Update Your Budget',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: secondTextColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Current Budget Text
                          Text(
                            'Current Budget: ${state.budget.toStringAsFixed(2)} LE',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Color.fromARGB(255, 0, 115, 4),
                            ),
                          ),
                          const SizedBox(height: 16),
                          textField(
                            controller: _newBudgetController,
                            hintText: 'Enter your new budget...',
                            fillColor: quaternaryColor,
                            filled: true,
                            borderSide: BorderSide.none,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: submitButton(
                              context,
                              buttonColor: secondaryColor,
                              textColor: tertiaryColor,
                              label: 'Save',
                              onTap: () {
                                context.read<BudgetCubit>().updateBudget(newBudgetController: _newBudgetController);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // User Actions Section
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: quaternaryColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'User Actions',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: secondTextColor,
                            ),
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
                          const SizedBox(height: 16),
                          // Delete Account Button with modified design
                          submitButton(
                            context,
                            buttonColor: const Color.fromARGB(255, 169, 0, 0),
                            textColor: tertiaryColor,
                            label: 'DELETE ACCOUNT',
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Delete Account'),
                                    content: const Text('Are you sure you want to delete your account? This action cannot be undone.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(),
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
