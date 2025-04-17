import 'package:halkhata/models/loan_record.dart';
import 'package:hive/hive.dart';

part 'hive_models.g.dart';

@HiveType(typeId: 0)
class HiveLoanRecord extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  double amount;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  double remainingAmount;

  @HiveField(4)
  List<HiveTransaction> transactions;

  @HiveField(5)
  String id; // Unique identifier

  @HiveField(6)
  bool isLoanReceived; // true if loan received, false if loan given

  @HiveField(7)
  String? description;

  HiveLoanRecord({
    required this.name,
    required this.amount,
    required this.date,
    required this.remainingAmount,
    required this.id,
    required this.isLoanReceived,
    this.description,
    List<HiveTransaction>? transactions,
  }) : transactions = transactions ?? [];

  // Convert to LoanRecord for UI
  LoanRecord toLoanRecord() {
    return LoanRecord(
      name: name,
      amount: amount,
      date: date,
      remainingAmount: remainingAmount,
      transactions: transactions.map((t) => t.toTransaction()).toList(),
    );
  }

  // Create from LoanRecord
  static HiveLoanRecord fromLoanRecord(
      LoanRecord record, String id, bool isLoanReceived) {
    return HiveLoanRecord(
      name: record.name,
      amount: record.amount,
      date: record.date,
      remainingAmount: record.remainingAmount,
      id: id,
      isLoanReceived: isLoanReceived,
      transactions: record.transactions
          .map((t) => HiveTransaction.fromTransaction(t))
          .toList(),
    );
  }
}

@HiveType(typeId: 1)
class HiveTransaction {
  @HiveField(0)
  double amount;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  String? note;

  HiveTransaction({
    required this.amount, 
    required this.date, 
    this.note,
  });

  // Convert to Transaction for UI
  Transaction toTransaction() {
    return Transaction(
      amount: amount,
      date: date,
    );
  }

  // Create from Transaction
  static HiveTransaction fromTransaction(Transaction transaction) {
    return HiveTransaction(
      amount: transaction.amount,
      date: transaction.date,
    );
  }
}