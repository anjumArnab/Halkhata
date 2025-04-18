import 'package:flutter/material.dart';
import 'package:halkhata/screens/homepage.dart';

void main() async {
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
