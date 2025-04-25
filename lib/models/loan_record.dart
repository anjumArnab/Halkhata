// loan_record.dart
import 'package:halkhata/models/transaction_record.dart';

class LoanRecord {
  final int? id;
  final String name;
  final double amount;
  final DateTime date;
  double remainingAmount;
  List<Transaction> transactions;

 LoanRecord({
  this.id,
  required this.name,
  required this.amount,
  required this.date,
  required this.remainingAmount,
   List<Transaction>? transactions
}) : this.transactions = transactions ?? [];
}
