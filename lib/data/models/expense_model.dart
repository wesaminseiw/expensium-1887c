import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
  });

  // Convert an Expense to a Map for Firestore (using Timestamp for the date)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': Timestamp.fromDate(date), // Use Firestore's Timestamp
    };
  }

  // Convert Firestore Map (with Timestamp) to an Expense object
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      amount: (map['amount'] as num).toDouble(),
      date:
          (map['date'] as Timestamp).toDate(), // Convert Timestamp to DateTime
    );
  }

  // Format date for UI display
  String get formattedDate {
    return DateFormat('yyyy/MM/dd').format(date);
  }
}
