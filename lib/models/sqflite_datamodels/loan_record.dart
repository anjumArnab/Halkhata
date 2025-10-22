import '/models/sqflite_datamodels/transaction_record.dart';

class LoanRecord {
  final int? id;
  final String name;
  final double amount;
  final DateTime date;
  final double remainingAmount;
  final bool isReceived;
  List<TransactionRecord>? transactions;

  LoanRecord({
    this.id,
    required this.name,
    required this.amount,
    required this.date,
    required this.remainingAmount,
    required this.isReceived,
    this.transactions,
  });

  // Convert to Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'date': date.millisecondsSinceEpoch,
      'remainingAmount': remainingAmount,
      'isReceived': isReceived ? 1 : 0,
    };
  }

  // Create from Map (database query result)
  factory LoanRecord.fromMap(Map<String, dynamic> map) {
    return LoanRecord(
      id: map['id'] as int?,
      name: map['name'] as String,
      amount: map['amount'] as double,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      remainingAmount: map['remainingAmount'] as double,
      isReceived: map['isReceived'] == 1,
    );
  }

  // Factory constructor for easy creation
  factory LoanRecord.create({
    required String name,
    required double amount,
    required DateTime date,
    required double remainingAmount,
    required bool isReceived,
  }) {
    return LoanRecord(
      name: name,
      amount: amount,
      date: date,
      remainingAmount: remainingAmount,
      isReceived: isReceived,
    );
  }

  // Copy with method for updates
  LoanRecord copyWith({
    int? id,
    String? name,
    double? amount,
    DateTime? date,
    double? remainingAmount,
    bool? isReceived,
    List<TransactionRecord>? transactions,
  }) {
    return LoanRecord(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      remainingAmount: remainingAmount ?? this.remainingAmount,
      isReceived: isReceived ?? this.isReceived,
      transactions: transactions ?? this.transactions,
    );
  }
}
