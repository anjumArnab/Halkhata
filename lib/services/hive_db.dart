import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/hive_models.dart';
import '../models/loan_record.dart';

class LoanDatabaseService {
  static const String _loansBoxName = 'loans';
  
  // Initialize Hive
  static Future<void> init() async {
    // Register adapters
    Hive.registerAdapter(HiveLoanRecordAdapter());
    Hive.registerAdapter(HiveTransactionAdapter());
    
    // Open box
    await Hive.openBox<HiveLoanRecord>(_loansBoxName);
  }
  
  // Get Hive box
  static Box<HiveLoanRecord> _getLoansBox() {
    return Hive.box<HiveLoanRecord>(_loansBoxName);
  }
  
  // Generate unique ID
  static String _generateId() {
    return const Uuid().v4();
  }
  
  // Create a new loan record
  static Future<String> addLoan(LoanRecord loan, bool isLoanReceived) async {
    final box = _getLoansBox();
    final id = _generateId();
    
    final hiveLoan = HiveLoanRecord.fromLoanRecord(loan, id, isLoanReceived);
    await box.put(id, hiveLoan);
    
    return id;
  }
  
  // Get all loans received
  static List<LoanRecord> getLoansReceived() {
    final box = _getLoansBox();
    
    return box.values
        .where((loan) => loan.isLoanReceived)
        .map((hiveLoan) => hiveLoan.toLoanRecord())
        .toList();
  }
  
  // Get all loans given
  static List<LoanRecord> getLoansGiven() {
    final box = _getLoansBox();
    
    return box.values
        .where((loan) => !loan.isLoanReceived)
        .map((hiveLoan) => hiveLoan.toLoanRecord())
        .toList();
  }
  
  // Get total amounts
  static Map<String, double> getTotalAmounts() {
    final box = _getLoansBox();
    double totalReceived = 0;
    double totalGiven = 0;
    
    for (var loan in box.values) {
      if (loan.isLoanReceived) {
        totalReceived += loan.amount;
      } else {
        totalGiven += loan.amount;
      }
    }
    
    return {
      'totalReceived': totalReceived,
      'totalGiven': totalGiven,
    };
  }
  
  // Get a specific loan by ID
  static LoanRecord? getLoanById(String id) {
    final box = _getLoansBox();
    final hiveLoan = box.get(id);
    
    return hiveLoan?.toLoanRecord();
  }
  
  // Update a loan record
  static Future<void> updateLoan(String id, LoanRecord updatedLoan) async {
    final box = _getLoansBox();
    final hiveLoan = box.get(id);
    
    if (hiveLoan != null) {
      hiveLoan.name = updatedLoan.name;
      hiveLoan.amount = updatedLoan.amount;
      hiveLoan.date = updatedLoan.date;
      hiveLoan.remainingAmount = updatedLoan.remainingAmount;
      hiveLoan.transactions = updatedLoan.transactions
          .map((t) => HiveTransaction.fromTransaction(t))
          .toList();
      
      await hiveLoan.save();
    }
  }
  
  // Add a transaction to a loan
  static Future<void> addTransactionToLoan(
      String loanId, Transaction transaction) async {
    final box = _getLoansBox();
    final hiveLoan = box.get(loanId);
    
    if (hiveLoan != null) {
      hiveLoan.transactions.add(HiveTransaction.fromTransaction(transaction));
      hiveLoan.remainingAmount -= transaction.amount;
      await hiveLoan.save();
    }
  }
  
  // Delete a loan record
  static Future<void> deleteLoan(String id) async {
    final box = _getLoansBox();
    await box.delete(id);
  }
  
  // Search loans by name
  static List<LoanRecord> searchLoansByName(String query, {bool? isLoanReceived}) {
    final box = _getLoansBox();
    final searchQuery = query.toLowerCase();
    
    var loans = box.values.where((loan) => 
      loan.name.toLowerCase().contains(searchQuery));
    
    // Filter by loan type if specified
    if (isLoanReceived != null) {
      loans = loans.where((loan) => loan.isLoanReceived == isLoanReceived);
    }
    
    return loans.map((hiveLoan) => hiveLoan.toLoanRecord()).toList();
  }
  
  // Get total remaining amounts
  static Map<String, double> getTotalRemainingAmounts() {
    final box = _getLoansBox();
    double totalRemainingReceived = 0;
    double totalRemainingGiven = 0;
    
    for (var loan in box.values) {
      if (loan.isLoanReceived) {
        totalRemainingReceived += loan.remainingAmount;
      } else {
        totalRemainingGiven += loan.remainingAmount;
      }
    }
    
    return {
      'totalRemainingReceived': totalRemainingReceived,
      'totalRemainingGiven': totalRemainingGiven,
    };
  }
}