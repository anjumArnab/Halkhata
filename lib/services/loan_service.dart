import 'package:hive/hive.dart';
import 'package:halkhata/models/loan_record.dart';
import 'package:halkhata/models/transaction_record.dart';

class LoanService {
  static const String loansReceivedBoxName = 'loansReceived';
  static const String loansGivenBoxName = 'loansGiven';
  static const String transactionsBoxName = 'transactions';

  // Boxes
  late Box<LoanRecord> _loansReceivedBox;
  late Box<LoanRecord> _loansGivenBox;
  late Box<Transaction> _transactionsBox;

  // Initialize service
  Future<void> init() async {
    // Open boxes if not already open
    if (!Hive.isBoxOpen(loansReceivedBoxName)) {
      _loansReceivedBox = await Hive.openBox<LoanRecord>(loansReceivedBoxName);
    } else {
      _loansReceivedBox = Hive.box<LoanRecord>(loansReceivedBoxName);
    }

    if (!Hive.isBoxOpen(loansGivenBoxName)) {
      _loansGivenBox = await Hive.openBox<LoanRecord>(loansGivenBoxName);
    } else {
      _loansGivenBox = Hive.box<LoanRecord>(loansGivenBoxName);
    }

    if (!Hive.isBoxOpen(transactionsBoxName)) {
      _transactionsBox = await Hive.openBox<Transaction>(transactionsBoxName);
    } else {
      _transactionsBox = Hive.box<Transaction>(transactionsBoxName);
    }
  }

  // Create new loan
  Future<LoanRecord> createLoan({
    required String name,
    required double amount,
    required DateTime date,
    required bool isReceived,
  }) async {
    final loan = LoanRecord.create(
      name: name,
      amount: amount,
      date: date,
      remainingAmount: amount,
      transactionsBox: _transactionsBox,
    );
    
    if (isReceived) {
      await _loansReceivedBox.add(loan);
    } else {
      await _loansGivenBox.add(loan);
    }
    
    return loan;
  }

  // Add transaction to loan
  Future<Transaction> addTransaction({
    required LoanRecord loan,
    required double amount,
    required DateTime date,
  }) async {
    final transaction = Transaction(
      amount: amount,
      date: date,
    );
    
    // Add to transactions box
    await _transactionsBox.add(transaction);
    
    // Initialize transactions HiveList if it's null
    if (loan.transactions == null) {
      loan.transactions = HiveList(_transactionsBox);
    }
    
    // Add to loan's transactions
    loan.transactions!.add(transaction);
    loan.remainingAmount -= amount;
    
    // Save the loan
    await loan.save();
    
    return transaction;
  }

  // Get all loans received
  List<LoanRecord> getLoansReceived() {
    return _loansReceivedBox.values.toList();
  }

  // Get all loans given
  List<LoanRecord> getLoansGiven() {
    return _loansGivenBox.values.toList();
  }

  // Calculate total received
  double calculateTotalReceived() {
    return _loansReceivedBox.values.fold(
      0.0,
      (sum, loan) => sum + loan.amount,
    );
  }

  // Calculate total given
  double calculateTotalGiven() {
    return _loansGivenBox.values.fold(
      0.0,
      (sum, loan) => sum + loan.amount,
    );
  }

  // Delete loan
  Future<void> deleteLoan(LoanRecord loan, bool isReceived) async {
    // Remove transactions from the loan
    if (loan.transactions != null) {
      for (var transaction in loan.transactions!) {
        await transaction.delete();
      }
    }
    
    // Delete the loan
    await loan.delete();
  }
}