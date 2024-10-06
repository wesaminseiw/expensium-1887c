import 'dart:math';

import 'package:expensium/data/models/expense_model.dart';
import 'package:expensium/data/models/income_model.dart';
import 'package:expensium/logic/cubits/budget_cubit/budget_cubit.dart';
import 'package:expensium/logic/cubits/combined_cubit/combined_cubit.dart';
import 'package:expensium/logic/cubits/expense_cubit/expense_cubit.dart';
import 'package:expensium/logic/cubits/get_display_name_cubit/get_display_name_cubit.dart';
import 'package:expensium/logic/cubits/income_cubit/income_cubit.dart';
import 'package:expensium/logic/cubits/user_actions_cubit/user_actions_cubit.dart';
import 'package:expensium/presentation/styles/colors.dart';
import 'package:expensium/presentation/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // context.read<BudgetCubit>().startDebugTimer();
    context.read<GetDisplayNameCubit>().getDisplayName();
    context.read<BudgetCubit>().getBudgetValue();
    context.read<CombinedCubit>().getIncomesAndExpenses();
    context.read<IncomeCubit>().fetchWeeklyIncomes();
    context.read<ExpenseCubit>().fetchWeeklyExpenses();
    // context.read<BudgetCubit>().calculateBudgetChange();

    return MultiBlocListener(
      listeners: [
        BlocListener<IncomeCubit, IncomeState>(
          listener: (context, state) {
            if (state is DeleteIncomeSuccessState) {
              context.read<CombinedCubit>().getIncomesAndExpenses();
              context.read<BudgetCubit>().getBudgetValue();
              // context.read<BudgetCubit>().calculateBudgetChange();
              snackBar(context, content: 'Income deleted successfully!');
            } else if (state is AddIncomeSuccessState) {
              context.read<CombinedCubit>().getIncomesAndExpenses();
              context.read<BudgetCubit>().getBudgetValue();
              // context.read<BudgetCubit>().calculateBudgetChange();
            }
          },
        ),
        BlocListener<ExpenseCubit, ExpenseState>(
          listener: (context, state) {
            if (state is DeleteExpenseSuccessState) {
              context.read<CombinedCubit>().getIncomesAndExpenses();
              context.read<BudgetCubit>().getBudgetValue();
              // context.read<BudgetCubit>().calculateBudgetChange();
              snackBar(context, content: 'Expense deleted successfully!');
            } else if (state is AddExpenseSuccessState) {
              context.read<CombinedCubit>().getIncomesAndExpenses();
              context.read<BudgetCubit>().getBudgetValue();
              // context.read<BudgetCubit>().calculateBudgetChange();
            }
          },
        ),
        BlocListener<UserActionsCubit, UserActionsState>(
          listener: (context, state) {
            if (state is UserActionsDeleteUserSuccessState) {
              Navigator.pushReplacementNamed(context, '/login');
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
          title: BlocBuilder<GetDisplayNameCubit, GetDisplayNameState>(
            builder: (context, state) {
              return Text(
                'Expensium',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: firstTextColor,
                  fontSize: 28,
                ),
              );
            },
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/settings',
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Image.asset(
                  'assets/images/settings.png',
                  width: 32,
                  height: 32,
                ),
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/home_screen.png',
                fit: BoxFit.cover,
              ),
            ),
            BlocBuilder<BudgetCubit, BudgetState>(
              builder: (context, state) {
                return ListView(
                  children: [
                    const SizedBox(height: 64),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BlocBuilder<BudgetCubit, BudgetState>(
                          builder: (context, state) {
                            if (state is GetBudgetLoadingState) {
                              context.read<BudgetCubit>().getBudgetValue();
                            }
                            return Text(
                              state is GetBudgetSuccessState ? state.budget.toStringAsFixed(2).toString() : '0.0',
                              style: TextStyle(
                                color: secondTextColor,
                                fontSize: 48,
                                fontWeight: FontWeight.w700,
                              ),
                            );
                          },
                        ),
                        Text(
                          ' LE',
                          style: TextStyle(
                            color: secondTextColor,
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Column(
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 16),
                            Text(
                              'This Week:',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: secondTextColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Material(
                              elevation: 6,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.436,
                                height: 128,
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    Transform(
                                      alignment: Alignment.center,
                                      transform: Matrix4.rotationZ(pi),
                                      child: Lottie.asset(
                                        'lib/presentation/animations/green-arrow.json',
                                        width: 82,
                                        height: 82,
                                      ),
                                    ),
                                    BlocBuilder<IncomeCubit, IncomeState>(
                                      builder: (context, state) {
                                        return Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              state is FetchWeeklyIncomeSuccessState ? state.totalIncomes.toString() : '0.00',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22,
                                                color: secondTextColor,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              ' LE',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 22,
                                                color: secondTextColor,
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Material(
                              elevation: 6,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.436,
                                height: 128,
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    Lottie.asset(
                                      'lib/presentation/animations/red-arrow.json',
                                      width: 82,
                                      height: 82,
                                    ),
                                    BlocBuilder<ExpenseCubit, ExpenseState>(
                                      builder: (context, state) {
                                        return Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              state is FetchWeeklyExpenseSuccessState ? state.totalExpenses.toString() : '0.00',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22,
                                                color: secondTextColor,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              ' LE',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 22,
                                                color: secondTextColor,
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 48),
                        BlocBuilder<GetDisplayNameCubit, GetDisplayNameState>(
                          builder: (context, state) {
                            return Row(
                              children: [
                                const SizedBox(width: 16),
                                Text(
                                  state is GetDisplayNameSuccessState ? state.username.toUpperCase() : 'Your',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: secondTextColor,
                                  ),
                                ),
                                Text(
                                  state is GetDisplayNameSuccessState ? '\'s Transactions' : ' Transactions',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: secondTextColor,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        // Row(
                        //   children: [
                        //     const SizedBox(width: 16),
                        //     Material(
                        //       elevation: 6,
                        //       borderRadius: BorderRadius.circular(12),
                        //       child: Container(
                        //         width: MediaQuery.of(context).size.width - 32,
                        //         height: 50,
                        //         decoration: BoxDecoration(
                        //           color: backgroundColor,
                        //           borderRadius: BorderRadius.circular(12),
                        //         ),
                        //         child: Row(
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           children: [
                        //             Text(
                        //               'Your budget has changed by ',
                        //               style: TextStyle(
                        //                 color: secondTextColor,
                        //                 fontSize: 14,
                        //                 fontWeight: FontWeight.w500,
                        //               ),
                        //             ),
                        //             Text(
                        //               state is GetBudgetSuccessState ? '${state.budgetChange?.toStringAsFixed(2).toString()}%' : '0%',
                        //               style: TextStyle(
                        //                 color: secondTextColor,
                        //                 fontSize: 14,
                        //                 fontWeight: FontWeight.bold,
                        //               ),
                        //             ),
                        //             Text(
                        //               ' this week.',
                        //               style: TextStyle(
                        //                 color: secondTextColor,
                        //                 fontSize: 14,
                        //                 fontWeight: FontWeight.w500,
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //     const SizedBox(width: 16),
                        //   ],
                        // ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    state.isLoading == false
                        ? Expanded(
                            child: BlocBuilder<CombinedCubit, CombinedState>(
                              builder: (context, state) {
                                if (state is CombinedSuccessState) {
                                  if (state.combinedList.isNotEmpty) {
                                    var groupedTransactions = state.combinedList;
                                    return ListView.separated(
                                      physics: const NeverScrollableScrollPhysics(),
                                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                                      itemCount: groupedTransactions.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        var group = groupedTransactions[index];
                                        var date = group['date'] as DateTime;
                                        var transactions = group['transactions'] as List<Map<String, dynamic>>;
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Date Header
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 16,
                                                bottom: 16,
                                              ),
                                              child: Material(
                                                borderRadius: BorderRadius.circular(12),
                                                elevation: 6,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: tertiaryColor,
                                                    borderRadius: BorderRadius.circular(6),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                    child: Text(
                                                      '${DateFormat('EEEE').format(date)}, ${DateFormat('yyyy-MM-dd').format(date)}',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                        color: secondTextColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            // Transactions for this date
                                            ...transactions.map((item) {
                                              var type = item['type']; // 'income' or 'expense'
                                              var data = item['data']; // Income or Expense object

                                              if (type == 'expense' && data is Expense) {
                                                return Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                                  child: GestureDetector(
                                                    onLongPress: () async {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              CircleAvatar(
                                                                backgroundColor: backgroundColor,
                                                                radius: 50,
                                                                child: Lottie.asset(
                                                                  'lib/presentation/animations/delete.json',
                                                                  width: 100,
                                                                  height: 100,
                                                                ),
                                                              ),
                                                              AlertDialog(
                                                                backgroundColor: backgroundColor,
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(6),
                                                                ),
                                                                title: Row(
                                                                  children: [
                                                                    Text(
                                                                      'Deletion of ',
                                                                      style: TextStyle(
                                                                        color: secondTextColor,
                                                                        fontWeight: FontWeight.w600,
                                                                        fontSize: 20,
                                                                      ),
                                                                    ),
                                                                    Flexible(
                                                                      child: SizedBox(
                                                                        width: 200, // Adjust width as needed
                                                                        child: Text(
                                                                          data.title,
                                                                          maxLines: 1,
                                                                          overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
                                                                          style: TextStyle(
                                                                            color: secondTextColor,
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 20,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed: () {
                                                                      context.read<IncomeCubit>().deleteIncome(
                                                                            incomeId: data.id,
                                                                            amount: data.amount,
                                                                          );
                                                                      context.read<CombinedCubit>().getIncomesAndExpenses();
                                                                      Navigator.of(context).pop();
                                                                    },
                                                                    child: Text(
                                                                      'Delete',
                                                                      style: TextStyle(
                                                                        color: secondTextColor,
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Column(
                                                      children: [
                                                        Material(
                                                          borderRadius: BorderRadius.circular(12),
                                                          elevation: 6,
                                                          child: Container(
                                                            width: double.infinity,
                                                            height: 64,
                                                            decoration: BoxDecoration(
                                                              color: Colors.white,
                                                              borderRadius: BorderRadius.circular(12),
                                                            ),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    const SizedBox(width: 16),
                                                                    Image.asset(
                                                                      'assets/images/decrease.png',
                                                                      width: 42,
                                                                      height: 42,
                                                                    ),
                                                                    const SizedBox(width: 16),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          data.title,
                                                                          maxLines: 1,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          style: TextStyle(
                                                                            color: secondTextColor,
                                                                            fontSize: 16,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          DateFormat('yyyy-MM-dd').format(date),
                                                                          maxLines: 1,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          style: TextStyle(
                                                                            color: Colors.grey.shade500,
                                                                            fontSize: 16,
                                                                            fontWeight: FontWeight.w500,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    const Spacer(),
                                                                    Text(
                                                                      '- ${data.amount}',
                                                                      style: TextStyle(
                                                                        color: secondTextColor,
                                                                        fontSize: 16,
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      ' LE',
                                                                      style: TextStyle(
                                                                        color: secondTextColor,
                                                                        fontSize: 16,
                                                                        fontWeight: FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(width: 16),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(height: 16),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              } else if (type == 'income' && data is Income) {
                                                return Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                  ),
                                                  child: GestureDetector(
                                                    onLongPress: () async {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              CircleAvatar(
                                                                backgroundColor: backgroundColor,
                                                                radius: 50,
                                                                child: Lottie.asset(
                                                                  'lib/presentation/animations/delete.json',
                                                                  width: 100,
                                                                  height: 100,
                                                                ),
                                                              ),
                                                              AlertDialog(
                                                                backgroundColor: backgroundColor,
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(6),
                                                                ),
                                                                title: Row(
                                                                  children: [
                                                                    Text(
                                                                      'Deletion of ',
                                                                      style: TextStyle(
                                                                        color: secondTextColor,
                                                                        fontWeight: FontWeight.w600,
                                                                        fontSize: 20,
                                                                      ),
                                                                    ),
                                                                    Flexible(
                                                                      child: SizedBox(
                                                                        width: 200, // Adjust width as needed
                                                                        child: Text(
                                                                          data.title,
                                                                          maxLines: 1,
                                                                          overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
                                                                          style: TextStyle(
                                                                            color: secondTextColor,
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 20,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed: () {
                                                                      context.read<IncomeCubit>().deleteIncome(
                                                                            incomeId: data.id,
                                                                            amount: data.amount,
                                                                          );
                                                                      context.read<CombinedCubit>().getIncomesAndExpenses();
                                                                      Navigator.of(context).pop();
                                                                    },
                                                                    child: Text(
                                                                      'Delete',
                                                                      style: TextStyle(
                                                                        color: secondTextColor,
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Column(
                                                      children: [
                                                        Material(
                                                          borderRadius: BorderRadius.circular(12),
                                                          elevation: 6,
                                                          child: Container(
                                                            width: double.infinity,
                                                            height: 64,
                                                            decoration: BoxDecoration(
                                                              color: Colors.white,
                                                              borderRadius: BorderRadius.circular(12),
                                                            ),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    const SizedBox(width: 16),
                                                                    Image.asset(
                                                                      'assets/images/increase.png',
                                                                      width: 42,
                                                                      height: 42,
                                                                    ),
                                                                    const SizedBox(width: 16),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        SizedBox(
                                                                          width: MediaQuery.of(context).size.width * 0.45,
                                                                          child: Text(
                                                                            data.title,
                                                                            maxLines: 1,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            style: TextStyle(
                                                                              color: secondTextColor,
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          DateFormat('yyyy-MM-dd').format(date),
                                                                          maxLines: 1,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          style: TextStyle(
                                                                            color: Colors.grey.shade500,
                                                                            fontSize: 16,
                                                                            fontWeight: FontWeight.w500,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    const Spacer(),
                                                                    Text(
                                                                      '+ ${data.amount}',
                                                                      style: TextStyle(
                                                                        color: secondTextColor,
                                                                        fontSize: 16,
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      ' LE',
                                                                      style: TextStyle(
                                                                        color: secondTextColor,
                                                                        fontSize: 16,
                                                                        fontWeight: FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(width: 16),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(height: 16),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                return const ListTile(
                                                  title: Text('Unknown transaction type'),
                                                );
                                              }
                                            }),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                } else if (state is CombinedLoadingState) {
                                  const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return Center(
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 36),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            children: [
                                              Image.asset(
                                                'assets/images/empty.png',
                                                width: 100,
                                                height: 100,
                                              ),
                                              const SizedBox(height: 16),
                                              Text(
                                                'No transactions yet',
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w600,
                                                  color: secondTextColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                        : const Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                              ],
                            ),
                          ),
                    const SizedBox(height: 72),
                  ],
                );
              },
            ),
          ],
        ),
        floatingActionButton: SpeedDial(
          iconTheme: IconThemeData(color: backgroundColor, size: 30),
          backgroundColor: primaryColor,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.money_off),
              label: "Add Expense",
              backgroundColor: tertiaryColor,
              labelBackgroundColor: tertiaryColor,
              labelStyle: TextStyle(
                color: secondTextColor,
                fontWeight: FontWeight.w600,
              ),
              onTap: () {
                Navigator.pushNamed(context, '/add_expense');
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.attach_money_rounded),
              label: "Add Income",
              backgroundColor: tertiaryColor,
              labelBackgroundColor: tertiaryColor,
              labelStyle: TextStyle(
                color: secondTextColor,
                fontWeight: FontWeight.w600,
              ),
              onTap: () {
                Navigator.pushNamed(context, '/add_income');
              },
            ),
          ],
          label: Text(
            'Add',
            style: TextStyle(
              color: firstTextColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          child: Image.asset(
            'assets/images/money.png',
            width: 40,
            height: 40,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
  // TODO: Add tests.
}
