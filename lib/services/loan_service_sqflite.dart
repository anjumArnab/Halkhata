import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/sqflite_datamodels/transaction_record.dart';
import '../models/sqflite_datamodels/loan_record.dart';

class LoanService {
  static const String _databaseName = 'halkhata.db';
  static const int _databaseVersion = 1;

  static const String _loansTable = 'loans';
  static const String _transactionsTable = 'transactions';

  static LoanService? _instance;
  static Database? _database;

  // Private constructor for singleton
  LoanService._();

  // Singleton instance
  static LoanService get instance {
    _instance ??= LoanService._();
    return _instance!;
  }

  // Get database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize database
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onConfigure: _onConfigure,
    );
  }

  // Enable foreign keys
  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  // Create tables
  Future<void> _onCreate(Database db, int version) async {
    // Create loans table
    await db.execute('''
      CREATE TABLE $_loansTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        amount REAL NOT NULL,
        date INTEGER NOT NULL,
        remainingAmount REAL NOT NULL,
        isReceived INTEGER NOT NULL
      )
    ''');

    // Create transactions table with foreign key
    await db.execute('''
      CREATE TABLE $_transactionsTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        loanId INTEGER NOT NULL,
        amount REAL NOT NULL,
        date INTEGER NOT NULL,
        FOREIGN KEY (loanId) REFERENCES $_loansTable (id) ON DELETE CASCADE
      )
    ''');

    // Create indexes for better performance
    await db.execute('''
      CREATE INDEX idx_loan_id ON $_transactionsTable (loanId)
    ''');

    await db.execute('''
      CREATE INDEX idx_loan_isReceived ON $_loansTable (isReceived)
    ''');
  }

  // Initialize service
  Future<void> init() async {
    await database;
  }

  // Create new loan
  Future<LoanRecord> createLoan({
    required String name,
    required double amount,
    required DateTime date,
    required bool isReceived,
  }) async {
    final db = await database;

    final loan = LoanRecord.create(
      name: name,
      amount: amount,
      date: date,
      remainingAmount: amount,
      isReceived: isReceived,
    );

    final id = await db.insert(
      _loansTable,
      loan.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return loan.copyWith(id: id, transactions: []);
  }

  // Add transaction to loan
  Future<TransactionRecord> addTransactionRecord({
    required LoanRecord loan,
    required double amount,
    required DateTime date,
  }) async {
    final db = await database;

    if (loan.id == null) {
      throw Exception('Loan must have an ID to add transactions');
    }

    if (amount <= 0) {
      throw Exception('Transaction amount must be greater than 0');
    }

    if (amount > loan.remainingAmount) {
      throw Exception('Transaction amount cannot exceed remaining loan amount');
    }

    // Start transaction
    return await db.transaction((txn) async {
      final transaction = TransactionRecord(
        loanId: loan.id!,
        amount: amount,
        date: date,
      );

      // Insert transaction
      final transactionId = await txn.insert(
        _transactionsTable,
        transaction.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // Update loan's remaining amount
      final newRemainingAmount = loan.remainingAmount - amount;
      await txn.update(
        _loansTable,
        {'remainingAmount': newRemainingAmount},
        where: 'id = ?',
        whereArgs: [loan.id],
      );

      return transaction.copyWith(id: transactionId);
    });
  }

  // Get all loans received
  Future<List<LoanRecord>> getLoansReceived() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      _loansTable,
      where: 'isReceived = ?',
      whereArgs: [1],
      orderBy: 'date DESC',
    );

    List<LoanRecord> loans = [];
    for (var map in maps) {
      final loan = LoanRecord.fromMap(map);
      loan.transactions = await _getTransactionsForLoan(loan.id!);
      loans.add(loan);
    }

    return loans;
  }

  // Get all loans given
  Future<List<LoanRecord>> getLoansGiven() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      _loansTable,
      where: 'isReceived = ?',
      whereArgs: [0],
      orderBy: 'date DESC',
    );

    List<LoanRecord> loans = [];
    for (var map in maps) {
      final loan = LoanRecord.fromMap(map);
      loan.transactions = await _getTransactionsForLoan(loan.id!);
      loans.add(loan);
    }

    return loans;
  }

  // Get all loans (both received and given)
  Future<List<LoanRecord>> getAllLoans() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      _loansTable,
      orderBy: 'date DESC',
    );

    List<LoanRecord> loans = [];
    for (var map in maps) {
      final loan = LoanRecord.fromMap(map);
      loan.transactions = await _getTransactionsForLoan(loan.id!);
      loans.add(loan);
    }

    return loans;
  }

  // Get transactions for a specific loan
  Future<List<TransactionRecord>> _getTransactionsForLoan(int loanId) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      _transactionsTable,
      where: 'loanId = ?',
      whereArgs: [loanId],
      orderBy: 'date DESC',
    );

    return maps.map((map) => TransactionRecord.fromMap(map)).toList();
  }

  // Get a single loan by ID
  Future<LoanRecord?> getLoanById(int id) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      _loansTable,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) return null;

    final loan = LoanRecord.fromMap(maps.first);
    loan.transactions = await _getTransactionsForLoan(id);

    return loan;
  }

  // Update loan
  Future<int> updateLoan(LoanRecord loan) async {
    final db = await database;

    if (loan.id == null) {
      throw Exception('Loan must have an ID to update');
    }

    return await db.update(
      _loansTable,
      loan.toMap(),
      where: 'id = ?',
      whereArgs: [loan.id],
    );
  }

  // Delete transaction
  Future<void> deleteTransactionRecord(
      TransactionRecord transaction, LoanRecord loan) async {
    final db = await database;

    if (transaction.id == null) {
      throw Exception('Transaction must have an ID to delete');
    }

    if (loan.id == null) {
      throw Exception('Loan must have an ID');
    }

    await db.transaction((txn) async {
      // Delete the transaction
      await txn.delete(
        _transactionsTable,
        where: 'id = ?',
        whereArgs: [transaction.id],
      );

      // Update loan's remaining amount
      final newRemainingAmount = loan.remainingAmount + transaction.amount;
      await txn.update(
        _loansTable,
        {'remainingAmount': newRemainingAmount},
        where: 'id = ?',
        whereArgs: [loan.id],
      );
    });
  }

  // Delete loan
  Future<void> deleteLoan(LoanRecord loan) async {
    final db = await database;

    if (loan.id == null) {
      throw Exception('Loan must have an ID to delete');
    }

    // Foreign key cascade will automatically delete related transactions
    await db.delete(
      _loansTable,
      where: 'id = ?',
      whereArgs: [loan.id],
    );
  }

  // Calculate total received
  Future<double> calculateTotalReceived() async {
    final db = await database;

    final result = await db.rawQuery('''
      SELECT SUM(amount) as total
      FROM $_loansTable
      WHERE isReceived = 1
    ''');

    final total = result.first['total'];
    return (total as num?)?.toDouble() ?? 0.0;
  }

  // Calculate total given
  Future<double> calculateTotalGiven() async {
    final db = await database;

    final result = await db.rawQuery('''
      SELECT SUM(amount) as total
      FROM $_loansTable
      WHERE isReceived = 0
    ''');

    final total = result.first['total'];
    return (total as num?)?.toDouble() ?? 0.0;
  }

  // Calculate total remaining amount for received loans
  Future<double> calculateTotalRemainingReceived() async {
    final db = await database;

    final result = await db.rawQuery('''
      SELECT SUM(remainingAmount) as total
      FROM $_loansTable
      WHERE isReceived = 1
    ''');

    final total = result.first['total'];
    return (total as num?)?.toDouble() ?? 0.0;
  }

  // Calculate total remaining amount for given loans
  Future<double> calculateTotalRemainingGiven() async {
    final db = await database;

    final result = await db.rawQuery('''
      SELECT SUM(remainingAmount) as total
      FROM $_loansTable
      WHERE isReceived = 0
    ''');

    final total = result.first['total'];
    return (total as num?)?.toDouble() ?? 0.0;
  }

  // Get loan statistics
  Future<Map<String, dynamic>> getLoanStatistics() async {
    final totalReceived = await calculateTotalReceived();
    final totalGiven = await calculateTotalGiven();
    final totalRemainingReceived = await calculateTotalRemainingReceived();
    final totalRemainingGiven = await calculateTotalRemainingGiven();

    return {
      'totalReceived': totalReceived,
      'totalGiven': totalGiven,
      'totalRemainingReceived': totalRemainingReceived,
      'totalRemainingGiven': totalRemainingGiven,
      'totalPaidReceived': totalReceived - totalRemainingReceived,
      'totalPaidGiven': totalGiven - totalRemainingGiven,
      'netBalance': totalRemainingReceived - totalRemainingGiven,
    };
  }

  // Search loans by name
  Future<List<LoanRecord>> searchLoansByName(String name,
      {bool? isReceived}) async {
    final db = await database;

    String whereClause = 'name LIKE ?';
    List<dynamic> whereArgs = ['%$name%'];

    if (isReceived != null) {
      whereClause += ' AND isReceived = ?';
      whereArgs.add(isReceived ? 1 : 0);
    }

    final List<Map<String, dynamic>> maps = await db.query(
      _loansTable,
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: 'date DESC',
    );

    List<LoanRecord> loans = [];
    for (var map in maps) {
      final loan = LoanRecord.fromMap(map);
      loan.transactions = await _getTransactionsForLoan(loan.id!);
      loans.add(loan);
    }

    return loans;
  }

  // Clear all data
  Future<void> clearAllData() async {
    final db = await database;

    await db.transaction((txn) async {
      await txn.delete(_transactionsTable);
      await txn.delete(_loansTable);
    });
  }

  // Close database
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
