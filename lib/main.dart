import 'package:flutter/material.dart';
import 'package:halkhata/screens/homepage.dart';
import 'package:halkhata/services/hive_db.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive - simpler approach
  await Hive.initFlutter();
  
  // Initialize database service
  await LoanDatabaseService.init();
  
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
      home: const HomePage(),
    );
  }
}