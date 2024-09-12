import 'package:expensium/data/models/expense_model.dart';
import 'package:expensium/data/models/income_model.dart';
import 'package:expensium/logic/cubits/budget_cubit/budget_cubit.dart';
import 'package:expensium/logic/cubits/combined_cubit/combined_cubit.dart';
import 'package:expensium/logic/cubits/expense_cubit/expense_cubit.dart';
import 'package:expensium/logic/cubits/get_display_name_cubit/get_display_name_cubit.dart';
import 'package:expensium/logic/cubits/income_cubit/income_cubit.dart';
import 'package:expensium/presentation/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<GetDisplayNameCubit>().getDisplayName();
    context.read<BudgetCubit>().getBudgetValue();
    context.read<CombinedCubit>().getIncomesAndExpenses();

    return MultiBlocListener(
      listeners: [
        BlocListener<IncomeCubit, IncomeState>(
          listener: (context, state) {
            if (state is DeleteIncomeSuccessState) {
              context.read<CombinedCubit>().getIncomesAndExpenses();
              context.read<BudgetCubit>().getBudgetValue();
              snackBar(context, content: 'Income deleted successfully!');
            } else if (state is AddIncomeSuccessState) {
              context.read<CombinedCubit>().getIncomesAndExpenses();
              context.read<BudgetCubit>().getBudgetValue();
            }
          },
        ),
        BlocListener<ExpenseCubit, ExpenseState>(
          listener: (context, state) {
            if (state is DeleteExpenseSuccessState) {
              context.read<CombinedCubit>().getIncomesAndExpenses();
              context.read<BudgetCubit>().getBudgetValue();
              snackBar(context, content: 'Expense deleted successfully!');
            } else if (state is AddExpenseSuccessState) {
              context.read<CombinedCubit>().getIncomesAndExpenses();
              context.read<BudgetCubit>().getBudgetValue();
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<GetDisplayNameCubit, GetDisplayNameState>(
            builder: (context, state) {
              return Text(
                state is GetDisplayNameSuccessState
                    ? 'Welcome, ${state.username}!'
                    : 'Welcome!',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              );
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/settings',
                );
              },
              icon: const Icon(
                Icons.settings_rounded,
                color: Colors.black,
              ),
            ),
          ],
        ),
        body: BlocBuilder<BudgetCubit, BudgetState>(
          builder: (context, state) {
            return Column(
              children: [
                const SizedBox(height: 36),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(width: 24),
                                BlocBuilder<BudgetCubit, BudgetState>(
                                  builder: (context, state) {
                                    if (state is GetBudgetLoadingState) {
                                      context
                                          .read<BudgetCubit>()
                                          .getBudgetValue();
                                    }
                                    return Text(
                                      state is GetBudgetSuccessState
                                          ? state.budget
                                              .toStringAsFixed(2)
                                              .toString()
                                          : '0.0',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'LE',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // const SizedBox(height: 24),
                          // Padding(
                          //   padding: EdgeInsets.symmetric(horizontal: 48),
                          //   child: Row(
                          //     children: [
                          //       Container(
                          //         decoration: BoxDecoration(
                          //           color: Colors.white,
                          //           borderRadius: BorderRadius.circular(12),
                          //         ),
                          //         child: Padding(
                          //           padding: const EdgeInsets.all(6),
                          //           child: Text(
                          //             '+ 200 EGP',
                          //             style: TextStyle(
                          //               color: Colors.green,
                          //               fontSize: 16,
                          //               fontWeight: FontWeight.w500,
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //       Spacer(),
                          //       Container(
                          //         decoration: BoxDecoration(
                          //           color: Colors.white,
                          //           borderRadius: BorderRadius.circular(12),
                          //         ),
                          //         child: Padding(
                          //           padding: const EdgeInsets.all(6),
                          //           child: Text(
                          //             '- 500 EGP',
                          //             style: TextStyle(
                          //               color: Colors.red,
                          //               fontSize: 16,
                          //               fontWeight: FontWeight.w500,
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 36),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Latest Transactions',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                state.isLoading == false
                    ? Expanded(
                        child: BlocBuilder<CombinedCubit, CombinedState>(
                          builder: (context, state) {
                            if (state is CombinedSuccessState) {
                              if (state.combinedList.isNotEmpty) {
                                var groupedTransactions = state.combinedList;
                                return ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 8),
                                  itemCount: groupedTransactions.length,
                                  itemBuilder: (context, index) {
                                    var group = groupedTransactions[index];
                                    var date = group['date'] as DateTime;
                                    var transactions = group['transactions']
                                        as List<Map<String, dynamic>>;

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Date Header
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 16,
                                            bottom: 8,
                                            top: 8,
                                          ),
                                          child: Text(
                                            DateFormat('yyyy-MM-dd')
                                                .format(date),
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        // Transactions for this date
                                        ...transactions.map((item) {
                                          var type = item[
                                              'type']; // 'income' or 'expense'
                                          var data = item[
                                              'data']; // Income or Expense object

                                          if (type == 'expense' &&
                                              data is Expense) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16),
                                              child: GestureDetector(
                                                onLongPress: () async {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                          'Are you sure you want to delete "${data.title}" expense?',
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: const Text(
                                                                'Cancel'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              context
                                                                  .read<
                                                                      ExpenseCubit>()
                                                                  .deleteExpense(
                                                                    expenseId:
                                                                        data.id,
                                                                    amount: data
                                                                        .amount,
                                                                  );
                                                              context
                                                                  .read<
                                                                      CombinedCubit>()
                                                                  .getIncomesAndExpenses();
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: const Text(
                                                                'Yes'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Card(
                                                  elevation: 8,
                                                  color: Colors.white,
                                                  child: ListTile(
                                                    minTileHeight: 100,
                                                    leading: Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        Container(
                                                          width: 50,
                                                          height: 50,
                                                          decoration:
                                                              const BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                        const Icon(
                                                          Icons
                                                              .money_off_rounded,
                                                          color: Colors.white,
                                                          size: 28,
                                                        ),
                                                      ],
                                                    ),
                                                    title: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          data.title,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${DateFormat('yyyy-MM-dd').format(data.date)}',
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Colors
                                                                .grey.shade600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    trailing: Text(
                                                      '-${data.amount} LE',
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          } else if (type == 'income' &&
                                              data is Income) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 16,
                                              ),
                                              child: GestureDetector(
                                                onLongPress: () async {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                          'Are you sure you want to delete "${data.title}" income?',
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: const Text(
                                                                'Cancel'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              context
                                                                  .read<
                                                                      IncomeCubit>()
                                                                  .deleteIncome(
                                                                    incomeId:
                                                                        data.id,
                                                                    amount: data
                                                                        .amount,
                                                                  );
                                                              context
                                                                  .read<
                                                                      CombinedCubit>()
                                                                  .getIncomesAndExpenses();
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: const Text(
                                                                'Yes'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Card(
                                                  color: Colors.white,
                                                  elevation: 8,
                                                  child: ListTile(
                                                    minTileHeight: 100,
                                                    leading: Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        Container(
                                                          width: 50,
                                                          height: 50,
                                                          decoration:
                                                              const BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: Colors.green,
                                                          ),
                                                        ),
                                                        const Icon(
                                                          Icons
                                                              .attach_money_rounded,
                                                          color: Colors.white,
                                                          size: 28,
                                                        ),
                                                      ],
                                                    ),
                                                    title: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          data.title,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${DateFormat('yyyy-MM-dd').format(data.date)}',
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Colors
                                                                .grey.shade600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    trailing: Text(
                                                      '+${data.amount} LE',
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          } else {
                                            return const ListTile(
                                              title: Text(
                                                  'Unknown transaction type'),
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
                            return const Center(
                                child: Text(
                              'No transactions yet',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                              ),
                            ));
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
                      )

                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 16),
                //   child: Card(
                //     elevation: 8,
                //     color: Colors.white,
                //     child: ListTile(
                //       minTileHeight: 100,
                //       leading: Stack(
                //         alignment: Alignment.center,
                //         children: [
                //           Container(
                //             width: 50,
                //             height: 50,
                //             decoration: const BoxDecoration(
                //               shape: BoxShape.circle,
                //               color: Colors.red,
                //             ),
                //           ),
                //           const Icon(
                //             Icons.money_off_rounded,
                //             color: Colors.white,
                //             size: 28,
                //           ),
                //         ],
                //       ),
                //       title: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         mainAxisAlignment: MainAxisAlignment.start,
                //         children: [
                //           const Text(
                //             'Title',
                //             maxLines: 1,
                //             overflow: TextOverflow.ellipsis,
                //             style: TextStyle(
                //               fontSize: 18,
                //               fontWeight: FontWeight.bold,
                //             ),
                //           ),
                //           Text(
                //             'Subtitle',
                //             maxLines: 1,
                //             overflow: TextOverflow.ellipsis,
                //             style: TextStyle(
                //               fontSize: 14,
                //               fontWeight: FontWeight.w400,
                //               color: Colors.grey.shade600,
                //             ),
                //           ),
                //         ],
                //       ),
                //       titleAlignment: ListTileTitleAlignment.center,
                //       // subtitle: const Text('Subtitle'),
                //       trailing: const Text(
                //         '-244 LE',
                //         style: TextStyle(
                //           fontSize: 18,
                //           fontWeight: FontWeight.bold,
                //           color: Colors.red,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 12),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 16),
                //   child: Card(
                //     color: Colors.white,
                //     elevation: 8,
                //     child: ListTile(
                //       minTileHeight: 100,
                //       leading: Stack(
                //         alignment: Alignment.center,
                //         children: [
                //           Container(
                //             width: 50,
                //             height: 50,
                //             decoration: const BoxDecoration(
                //               shape: BoxShape.circle,
                //               color: Colors.green,
                //             ),
                //           ),
                //           const Icon(
                //             Icons.attach_money_rounded,
                //             color: Colors.white,
                //             size: 28,
                //           ),
                //         ],
                //       ),
                //       title: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         mainAxisAlignment: MainAxisAlignment.start,
                //         children: [
                //           const Text(
                //             'Title',
                //             maxLines: 1,
                //             overflow: TextOverflow.ellipsis,
                //             style: TextStyle(
                //               fontSize: 18,
                //               fontWeight: FontWeight.bold,
                //             ),
                //           ),
                //           Text(
                //             'Subtitle',
                //             maxLines: 1,
                //             overflow: TextOverflow.ellipsis,
                //             style: TextStyle(
                //               fontSize: 14,
                //               fontWeight: FontWeight.w400,
                //               color: Colors.grey.shade600,
                //             ),
                //           ),
                //         ],
                //       ),
                //       titleAlignment: ListTileTitleAlignment.center,
                //       // subtitle: const Text('Subtitle'),
                //       trailing: const Text(
                //         '+134 LE',
                //         style: TextStyle(
                //           fontSize: 18,
                //           fontWeight: FontWeight.bold,
                //           color: Colors.green,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // TextButton(
                //   onPressed: () async {
                //     await context.read<UserActionsCubit>().deleteUser(context);
                //   },
                //   child: const Text('Delete account'),
                // ),
                // TextButton(
                //   onPressed: () async {
                //     context.read<UserActionsCubit>().signOut(context);
                //   },
                //   child: const Text('Logout'),
                // ),
              ],
            );
          },
        ),
        floatingActionButton: SpeedDial(
          icon: Icons.add,
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Theme.of(context).colorScheme.primary,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.money_off),
              label: "Expense",
              onTap: () {
                Navigator.pushNamed(context, '/add_expense');
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.attach_money_rounded),
              label: "Income",
              onTap: () {
                Navigator.pushNamed(context, '/add_income');
              },
            ),
          ],
        ),
      ),
    );
  }
  // TODO: Add tests.
}
