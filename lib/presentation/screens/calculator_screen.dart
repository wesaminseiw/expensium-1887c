import 'dart:developer';
import 'package:expensium/data/models/expense_model.dart';
import 'package:expensium/data/models/income_model.dart';
import 'package:expensium/data/models/transaction_model.dart';
import 'package:expensium/logic/cubits/budget_cubit/budget_cubit.dart';
import 'package:expensium/logic/cubits/combined_cubit/combined_cubit.dart';
import 'package:expensium/presentation/styles/colors.dart';
import 'package:expensium/presentation/widgets/custom_bottom_appbar.dart';
import 'package:expensium/presentation/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  int currentIndex = 1;
  List<Transaction> summationList = [];
  final TextEditingController _totalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BudgetCubit, BudgetState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: tertiaryColor,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      const SizedBox(height: 48),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Here can you calculate\nyour budget changes',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Click on the expenses or incomes\nyou want to calculate and the app\nwill automatically calculate it',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 64),
                      state.isLoading == false
                          ? Expanded(
                              child: BlocBuilder<CombinedCubit, CombinedState>(
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
                                                      onTap: () {
                                                        Transaction newTransaction = Transaction(data.id, data.amount * -1);

                                                        if (!summationList.any((transaction) => transaction.id == newTransaction.id)) {
                                                          setState(() {
                                                            summationList.add(newTransaction);
                                                          });

                                                          double total = summationList.fold(0, (a, b) => a + b.amount);
                                                          _totalController.text = total.toString();

                                                          log(summationList.toString());
                                                          log(total.toString());

                                                          shortTimeSnackBar(context, content: 'Added "${data.title}" to summation');
                                                        } else {
                                                          shortTimeSnackBar(context, content: '"${data.title}" is already added to summation');
                                                        }
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
                                                      onTap: () {
                                                        double income = data.amount; // Assuming data.amount is the income value
                                                        Transaction newTransaction =
                                                            Transaction(data.id, income); // Create new transaction with income

                                                        // Check if this transaction already exists based on ID
                                                        if (!summationList.any((transaction) => transaction.id == newTransaction.id)) {
                                                          setState(() {
                                                            summationList.add(newTransaction);
                                                          });

                                                          // Calculate total after adding the new transaction
                                                          double total = summationList.fold(0, (a, b) => a + b.amount);
                                                          _totalController.text = total.toString();

                                                          log(summationList.toString());
                                                          log(total.toString());

                                                          shortTimeSnackBar(context, content: 'Added "${data.title}" to summation');
                                                        } else {
                                                          shortTimeSnackBar(context, content: '"${data.title}" is already added to summation');
                                                        }
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
                    ],
                  ),
                ),
                Material(
                  elevation: 100,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  color: quaternaryColor,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      color: quaternaryColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                              color: secondTextColor,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${_totalController.text.isNotEmpty ? _totalController.text : 0.0} LE',
                            style: TextStyle(
                              color: firstTextColor,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    if (summationList.isNotEmpty && _totalController.text.isNotEmpty) {
                                      summationList.clear();
                                      setState(() {
                                        _totalController.text = '';
                                      });
                                      shortTimeSnackBar(context, content: 'Cleared total');
                                    } else {
                                      shortTimeSnackBar(context, content: 'Total is already empty');
                                    }
                                  },
                                  child: Container(
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: secondaryColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Clear',
                                        style: TextStyle(
                                          color: tertiaryColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 22,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: CustomBottomAppBar(currentIndex: currentIndex),
        );
      },
    );
  }
}
