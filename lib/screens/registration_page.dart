import 'package:flutter/material.dart';
import 'package:halkhata/screens/login_page.dart';
import 'package:halkhata/widgets/custom_app_bar.dart';
import 'package:halkhata/widgets/custom_button.dart';
import 'package:halkhata/widgets/custom_text_button.dart';
import 'package:halkhata/widgets/custom_text_form_field.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
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
                          "নিবন্ধন", // "Registration" in Bengali
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
                      // For Email Field
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
                      // For Password Field
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

                      // Registration button
                      CustomButton(
                        onPressed: _handleRegistration,
                        text: "নিবন্ধন",
                      ),
                      const SizedBox(height: 24),

                      // Login link
                      Center(
                        child: CustomTextButton(
                          onPressed: () => _navigateToLogin(context),
                          text: "ইতিমধ্যে অ্যাকাউন্ট আছে? লগইন করুন",
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
  void _handleRegistration() {
    // This would register the user with a backend service
    // For example:
    // authService.register(_emailController.text, _passwordController.text)
    //   .then((success) => {
    //     if (success) {
    //       Navigator.of(context).pushReplacement(
    //         MaterialPageRoute(builder: (context) => HomeScreen())
    //       )
    //     } else {
    //       // Show error message
    //     }
    //   });
  }

  void _navigateToLogin(BuildContext context) {
    // This would navigate back to the login page

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }
}
