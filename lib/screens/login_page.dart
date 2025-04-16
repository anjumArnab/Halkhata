import 'package:flutter/material.dart';
import 'package:halkhata/screens/registration_page.dart';
import 'package:halkhata/widgets/custom_app_bar.dart';
import 'package:halkhata/widgets/custom_button.dart';
import 'package:halkhata/widgets/custom_text_button.dart';
import 'package:halkhata/widgets/custom_text_form_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers for the text fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Container(
        color: const Color(0xFFF9EFD7), // Light cream background color
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Center(
                        child: Text(
                          "লগইন", // "Login" in Bengali
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Email field
                      const Text(
                        "ইমেইল", // "Email" in Bengali
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextFormField(
                        controller: _emailController,
                        hintText: "you@example.com",
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          // You can add more email validation here
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Password field
                      const Text(
                        "পাসওয়ার্ড", // "Password" in Bengali
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextFormField(
                        controller: _passwordController,
                        hintText: "••••••••",
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),

                      // Login button
                      CustomButton(
                        onPressed: _handleLogin,
                        text: "লগইন",
                      ),
                      const SizedBox(height: 24),

                      // Registration link
                      Center(
                        child: CustomTextButton(
                          onPressed: () => _navigateToRegistration(context),
                          text: "অ্যাকাউন্ট নেই? নিবন্ধন করুন",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Mock functions for handling dynamic behaviors
  void _handleLogin() {
    // This would authenticate the user against a backend service
    
  }

  void _navigateToRegistration(BuildContext context) {
    // This would navigate to the registration Page

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const RegistrationPage(),
      ),
    );
    
  }
}
