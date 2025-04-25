import 'package:hive/hive.dart';
import 'transaction_record.dart';

part 'loan_record.g.dart';

@HiveType(typeId: 1)
class LoanRecord extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  double remainingAmount;

  @HiveField(4)
  HiveList<Transaction>? transactions;

  LoanRecord({
    required this.name,
    required this.amount,
    required this.date,
    required this.remainingAmount,
    this.transactions,
  });

  // Factory constructor for easy creation with default empty HiveList
  factory LoanRecord.create({
    required String name,
    required double amount,
    required DateTime date,
    required double remainingAmount,
    Box<Transaction>? transactionsBox,
  }) {
    final loan = LoanRecord(
      name: name,
      amount: amount,
      date: date,
      remainingAmount: remainingAmount,
      transactions: transactionsBox != null ? HiveList(transactionsBox) : null,
    );
    return loan;
  }
}