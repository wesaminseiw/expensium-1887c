import 'dart:math' show pi;
import 'package:expensium/data/models/expense_model.dart';
import 'package:expensium/data/models/income_model.dart';
import 'package:expensium/logic/cubits/budget_cubit/budget_cubit.dart';
import 'package:expensium/logic/cubits/combined_cubit/combined_cubit.dart';
import 'package:expensium/logic/cubits/expense_cubit/expense_cubit.dart';
import 'package:expensium/logic/cubits/get_display_name_cubit/get_display_name_cubit.dart';
import 'package:expensium/logic/cubits/get_weekly_budget_cubit/get_weekly_budget_cubit.dart';
import 'package:expensium/logic/cubits/income_cubit/income_cubit.dart';
import 'package:expensium/logic/cubits/user_actions_cubit/user_actions_cubit.dart';
import 'package:expensium/presentation/styles/colors.dart';
import 'package:expensium/presentation/widgets/custom_bottom_appbar.dart';
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
    context.read<GetDisplayNameCubit>().getDisplayName();
    context.read<BudgetCubit>().getBudgetValue();
    context.read<GetWeeklyBudgetCubit>().getWeeklyDifference();
    context.read<CombinedCubit>().getIncomesAndExpenses();
    context.read<IncomeCubit>().fetchWeeklyIncomes();
    context.read<ExpenseCubit>().fetchWeeklyExpenses();

    int currentIndex = 0;

    return MultiBlocListener(
      listeners: [
        BlocListener<IncomeCubit, IncomeState>(
          listener: (context, state) {
            if (state is DeleteIncomeSuccessState) {
              context.read<CombinedCubit>().getIncomesAndExpenses();
              context.read<BudgetCubit>().getBudgetValue();
              context.read<GetWeeklyBudgetCubit>().getWeeklyDifference();
              // context.read<BudgetCubit>().calculateBudgetChange();
              shortTimeSnackBar(context, content: 'Income deleted successfully!');
            } else if (state is AddIncomeSuccessState) {
              context.read<CombinedCubit>().getIncomesAndExpenses();
              context.read<BudgetCubit>().getBudgetValue();
              context.read<GetWeeklyBudgetCubit>().getWeeklyDifference();
              // context.read<BudgetCubit>().calculateBudgetChange();
            }
          },
        ),
        BlocListener<ExpenseCubit, ExpenseState>(
          listener: (context, state) {
            if (state is DeleteExpenseSuccessState) {
              context.read<CombinedCubit>().getIncomesAndExpenses();
              context.read<BudgetCubit>().getBudgetValue();
              context.read<GetWeeklyBudgetCubit>().getWeeklyDifference();
              // context.read<BudgetCubit>().calculateBudgetChange();
              shortTimeSnackBar(context, content: 'Expense deleted successfully!');
            } else if (state is AddExpenseSuccessState) {
              context.read<CombinedCubit>().getIncomesAndExpenses();
              context.read<BudgetCubit>().getBudgetValue();
              context.read<GetWeeklyBudgetCubit>().getWeeklyDifference();
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
        backgroundColor: tertiaryColor,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: tertiaryColor,
          title: Image.asset(
            'assets/logos/logo-no-bg.png',
            width: 10907 / 60,
            height: 2048 / 60,
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
                  color: primaryColor,
                  width: 32,
                  height: 32,
                ),
              ),
            ),
          ],
        ),
        body: BlocBuilder<BudgetCubit, BudgetState>(
          builder: (context, state) {
            return ListView(
              children: [
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Material(
                    elevation: 6,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 200,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            spreadRadius: 1,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Card elements: Chip, logo, etc.
                          Positioned(
                            left: 16,
                            top: 20,
                            child: Container(
                              width: 50,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                          const Positioned(
                            right: 16,
                            top: 20,
                            child: Row(
                              children: [
                                CircleAvatar(backgroundColor: Colors.orange, radius: 12),
                                SizedBox(width: 4),
                                CircleAvatar(backgroundColor: Colors.red, radius: 12),
                              ],
                            ),
                          ),
                          // Card Content: Budget, Income, and Expenses
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Left Center - Current Budget
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 64),
                                    const Text(
                                      'Current Budget',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    BlocBuilder<BudgetCubit, BudgetState>(
                                      builder: (context, state) {
                                        if (state is GetBudgetLoadingState) {
                                          context.read<BudgetCubit>().getBudgetValue();
                                        }
                                        return Text(
                                          state is GetBudgetSuccessState ? "${state.budget.toStringAsFixed(2)} LE" : '0.0',
                                          style: TextStyle(
                                            color: quaternaryColor,
                                            fontSize: 36,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Material(
                    borderRadius: BorderRadius.circular(16),
                    elevation: 6,
                    child: Container(
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: secondaryColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'This Week',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                BlocBuilder<GetWeeklyBudgetCubit, GetWeeklyBudgetState>(
                                  builder: (context, state) {
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.end, // Aligns the row's children to the end
                                      crossAxisAlignment: CrossAxisAlignment.center, // Center the row's children vertically
                                      children: [
                                        Text(
                                          state is GetWeeklyBudgetDifferenceSuccessState ? '${state.weeklyDifference.toString()} LE' : '0.0 LE',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 28,
                                            color: quaternaryColor,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                            const Spacer(),
                            BlocBuilder<GetWeeklyBudgetCubit, GetWeeklyBudgetState>(
                              builder: (context, state) {
                                return Transform(
                                  alignment: Alignment.center,
                                  transform: (state is GetWeeklyBudgetDifferenceSuccessState && state.income == 1)
                                      ? Matrix4.rotationZ(pi)
                                      : Matrix4.identity(),
                                  child: state is GetWeeklyBudgetDifferenceSuccessState
                                      ? (state.income == 1
                                          ? Lottie.asset(
                                              'lib/presentation/animations/green-arrow.json',
                                              width: 85,
                                              height: 85,
                                            )
                                          : (state.income == 0
                                              ? Padding(
                                                  padding: const EdgeInsets.only(right: 15),
                                                  child: Image.asset(
                                                    'assets/images/neutral.png',
                                                    width: 50,
                                                    height: 50,
                                                  ),
                                                )
                                              : Lottie.asset(
                                                  'lib/presentation/animations/red-arrow.json',
                                                  width: 85,
                                                  height: 85,
                                                )))
                                      : Padding(
                                          padding: const EdgeInsets.only(right: 15),
                                          child: Image.asset(
                                            'assets/images/neutral.png',
                                            width: 65,
                                            height: 65,
                                          ),
                                        ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 58),
                state.isLoading == false
                    ? Expanded(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16, bottom: 38),
                              child: Row(
                                children: [
                                  Text(
                                    'Transactions',
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            BlocBuilder<CombinedCubit, CombinedState>(
                              builder: (context, state) {
                                if (state is CombinedSuccessState) {
                                  if (state.combinedList.isNotEmpty) {
                                    var groupedTransactions = state.combinedList;
                                    return ListView.builder(
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: groupedTransactions.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        var group = groupedTransactions[index];
                                        var date = group['date'] as DateTime;
                                        var transactions = group['transactions'] as List<Map<String, dynamic>>;
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
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
                                                                backgroundColor: quaternaryColor,
                                                                radius: 50,
                                                                child: Lottie.asset(
                                                                  'lib/presentation/animations/delete.json',
                                                                  width: 100,
                                                                  height: 100,
                                                                ),
                                                              ),
                                                              AlertDialog(
                                                                backgroundColor: quaternaryColor,
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
                                                                      context.read<ExpenseCubit>().deleteExpense(
                                                                            expenseId: data.id,
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
                                                        Divider(
                                                          height: 0.5,
                                                          color: Colors.black.withOpacity(0.5),
                                                        ),
                                                        Container(
                                                          width: double.infinity,
                                                          height: 64,
                                                          decoration: BoxDecoration(color: tertiaryColor),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  const SizedBox(width: 16),
                                                                  CircleAvatar(
                                                                    radius: 5,
                                                                    backgroundColor: expenseColor,
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
                                                                            fontWeight: FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(height: 4),
                                                                      Text(
                                                                        DateFormat('yyyy-MM-dd').format(date),
                                                                        maxLines: 1,
                                                                        overflow: TextOverflow.ellipsis,
                                                                        style: const TextStyle(
                                                                          color: Color(0xFF878787),
                                                                          fontSize: 14,
                                                                          fontWeight: FontWeight.w600,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const Spacer(),
                                                                  Text(
                                                                    data.amount.toString(),
                                                                    style: TextStyle(
                                                                      color: expenseColor,
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
                                                        Divider(
                                                          height: 0.5,
                                                          color: Colors.black.withOpacity(0.5),
                                                        ),
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
                                                                backgroundColor: quaternaryColor,
                                                                radius: 50,
                                                                child: Lottie.asset(
                                                                  'lib/presentation/animations/delete.json',
                                                                  width: 100,
                                                                  height: 100,
                                                                ),
                                                              ),
                                                              AlertDialog(
                                                                backgroundColor: quaternaryColor,
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
                                                        Divider(
                                                          height: 0.5,
                                                          color: Colors.black.withOpacity(0.5),
                                                        ),
                                                        Container(
                                                          width: double.infinity,
                                                          height: 64,
                                                          decoration: BoxDecoration(color: tertiaryColor),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  const SizedBox(width: 16),
                                                                  CircleAvatar(
                                                                    radius: 5,
                                                                    backgroundColor: incomeColor,
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
                                                                            fontWeight: FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(height: 4),
                                                                      Text(
                                                                        DateFormat('yyyy-MM-dd').format(date),
                                                                        maxLines: 1,
                                                                        overflow: TextOverflow.ellipsis,
                                                                        style: const TextStyle(
                                                                          color: Color(0xFF878787),
                                                                          fontSize: 14,
                                                                          fontWeight: FontWeight.w600,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const Spacer(),
                                                                  Text(
                                                                    data.amount.toString(),
                                                                    style: TextStyle(
                                                                      color: incomeColor,
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
                                                        Divider(
                                                          height: 0.5,
                                                          color: Colors.black.withOpacity(0.5),
                                                        ),
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
                                                width: 90,
                                                height: 90,
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
                          ],
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
                const SizedBox(height: 48),
              ],
            );
          },
        ),
        floatingActionButton: SpeedDial(
          iconTheme: IconThemeData(color: quaternaryColor, size: 30),
          backgroundColor: secondaryColor,
          buttonSize: const Size(65, 65),
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
          child: Image.asset(
            'assets/images/money.png',
            width: 40,
            height: 40,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: CustomBottomAppBar(currentIndex: currentIndex),
      ),
    );
  }
}
