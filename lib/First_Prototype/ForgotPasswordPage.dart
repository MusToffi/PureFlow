import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  Future<void> _requestPasswordReset(BuildContext context) async {
    final email = _emailController.text;

    // Endpoint to handle password reset requests
    const url = 'http://localhost:8080/flutter_auth_api/forgot_password.php';

    final response = await http.post(Uri.parse(url), body: {
      'email': email,
    });

    final responseData = json.decode(response.body);

    if (responseData['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset link sent to your email.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${responseData['message']}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Enter your email'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _requestPasswordReset(context),
              child: Text('Send Reset Link'),
            ),
          ],
        ),
      ),
    );
  }
}
