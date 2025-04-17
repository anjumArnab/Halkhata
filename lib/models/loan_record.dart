class LoanRecord {
  final String id;
  final String name;
  final double amount;
  final DateTime date;
  double remainingAmount;
  final List<Transaction> transactions;

  LoanRecord({
    this.id = '',
    required this.name,
    required this.amount,
    required this.date,
    required this.remainingAmount,
    List<Transaction>? transactions,
  }) : transactions = transactions ?? [];
}

class Transaction {
  final double amount;
  final DateTime date;

  Transaction({
    required this.amount,
    required this.date,
  });
}
