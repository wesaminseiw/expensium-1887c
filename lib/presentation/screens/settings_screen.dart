import 'package:expensium/logic/cubits/budget_cubit/budget_cubit.dart';
import 'package:expensium/logic/cubits/combined_cubit/combined_cubit.dart';
import 'package:expensium/logic/cubits/user_actions_cubit/user_actions_cubit.dart';
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
            } else if (state is UserActionsDeleteUserDataSuccessState) {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/add_budget');
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
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Settings',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
              onPressed: () {
                context
                    .read<BudgetCubit>()
                    .updateBudget(newBudgetController: _newBudgetController);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_rounded),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(
              left: 24,
              right: 24,
              top: 36,
              bottom: 128,
            ),
            child: BlocBuilder<BudgetCubit, BudgetState>(
              builder: (context, state) {
                _newBudgetController.text =
                    state.budget.toStringAsFixed(2).toString();
                return Material(
                  elevation: 16,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 24, left: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Update your budget, current is ${state.budget.toStringAsFixed(2)} LE',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        textField(
                          controller: _newBudgetController,
                          hintText: 'Enter your new budget..',
                        ),
                        const SizedBox(height: 24),
                        submitButton(
                          context,
                          label: 'Logout',
                          onTap: () {
                            context.read<UserActionsCubit>().signOut(context);
                          },
                        ),
                        const SizedBox(height: 24),
                        submitButton(
                          context,
                          label: 'WIPE ALL DATA',
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text(
                                    'Are you sure you want to delete all data? This action cannot be undone.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        context
                                            .read<UserActionsCubit>()
                                            .deleteUserData();
                                      },
                                      child: const Text('Yes'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        submitButton(
                          context,
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
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        context
                                            .read<UserActionsCubit>()
                                            .deleteUser(context);
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
