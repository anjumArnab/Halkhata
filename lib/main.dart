import 'package:flutter/material.dart';
import 'package:halkhata/models/loan_record.dart';
import 'package:halkhata/models/transaction_record.dart';
import 'package:halkhata/screens/login_page.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register adapters
  Hive.registerAdapter(LoanRecordAdapter());
  Hive.registerAdapter(TransactionAdapter());
  
  runApp(const Halkhata());
}

class Halkhata extends StatelessWidget {
  const Halkhata({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Halkhata',
      theme: ThemeData(
        primaryColor: const Color(0xFF1A6C1A),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF1A6C1A),
          secondary: const Color(0xFFFFC107),
        ),
        scaffoldBackgroundColor: const Color(0xFFF9EFD7),
        fontFamily: 'BengaliFont',
      ),
      home: const LoginPage(),
    );
  }
}