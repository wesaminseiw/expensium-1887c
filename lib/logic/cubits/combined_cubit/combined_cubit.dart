import 'package:bloc/bloc.dart';
import 'package:expensium/data/models/expense_model.dart';
import 'package:expensium/data/models/income_model.dart';
import 'package:expensium/logic/cubits/expense_cubit/expense_cubit.dart';
import 'package:expensium/logic/cubits/income_cubit/income_cubit.dart';

part 'combined_state.dart';

class CombinedCubit extends Cubit<CombinedState> {
  final ExpenseCubit expenseCubit;
  final IncomeCubit incomeCubit;

  CombinedCubit({
    required this.expenseCubit,
    required this.incomeCubit,
  }) : super(CombinedInitialState(isLoading: false));

  void getIncomesAndExpenses() async {
    emit(CombinedLoadingState(isLoading: true));

    try {
      // Fetch incomes and expenses using the respective cubits
      List<Income> incomes = await incomeCubit.fetchIncomes();
      List<Expense> expenses = await expenseCubit.fetchExpenses();

      // Combine incomes and expenses
      List<Map<String, dynamic>> combinedList = [
        ...incomes.map((income) => {'type': 'income', 'data': income}),
        ...expenses.map((expense) => {'type': 'expense', 'data': expense}),
      ];

      // Group by date
      Map<DateTime, List<Map<String, dynamic>>> groupedByDate = {};
      for (var item in combinedList) {
        DateTime date = (item['data'] as dynamic).date;
        DateTime dateOnly =
            DateTime(date.year, date.month, date.day); // Remove time part

        if (!groupedByDate.containsKey(dateOnly)) {
          groupedByDate[dateOnly] = [];
        }
        groupedByDate[dateOnly]!.add(item);
      }

      // Sort dates
      List<DateTime> sortedDates = groupedByDate.keys.toList()
        ..sort((a, b) => b.compareTo(a)); // Descending order

      // Convert to list
      List<Map<String, dynamic>> sortedGroupedTransactions = [];
      for (var date in sortedDates) {
        sortedGroupedTransactions.add({
          'date': date,
          'transactions': groupedByDate[date]!,
        });
      }

      emit(CombinedSuccessState(
        combinedList: sortedGroupedTransactions,
        isLoading: false,
      ));
    } catch (e) {
      emit(CombinedFailureState(isLoading: false));
      print(e.toString());
    }
  }
}
