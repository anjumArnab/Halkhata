class TransactionRecord {
  final int? id;
  final int loanId;
  final double amount;
  final DateTime date;

  TransactionRecord({
    this.id,
    required this.loanId,
    required this.amount,
    required this.date,
  });

  // Convert to Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'loanId': loanId,
      'amount': amount,
      'date': date.millisecondsSinceEpoch,
    };
  }

  // Create from Map (database query result)
  factory TransactionRecord.fromMap(Map<String, dynamic> map) {
    return TransactionRecord(
      id: map['id'] as int?,
      loanId: map['loanId'] as int,
      amount: map['amount'] as double,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
    );
  }

  // Copy with method for updates
  TransactionRecord copyWith({
    int? id,
    int? loanId,
    double? amount,
    DateTime? date,
  }) {
    return TransactionRecord(
      id: id ?? this.id,
      loanId: loanId ?? this.loanId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
    );
  }
}
