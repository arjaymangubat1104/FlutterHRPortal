import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/auth_view_model.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (authViewModel.errorMessage != null)
              Text(
                authViewModel.errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            TextField(
              controller: _displayNameController,
              decoration: InputDecoration(
                labelText: 'Display Name',
                hintText: 'Enter your display name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_displayNameController.text.isEmpty) {
                  authViewModel.setErrorMessage('Display Name cannot be empty');
                } else if (_emailController.text.isEmpty) {
                  authViewModel.setErrorMessage('Email cannot be empty');
                } else if (_passwordController.text.isEmpty) {
                  authViewModel.setErrorMessage('Password cannot be empty');
                } else {
                  await authViewModel.register(
                    _emailController.text,
                    _passwordController.text,
                    _displayNameController.text,
                    context,
                  );
                }
              },
              child: Text('Register'),
            ),
            TextButton(
              onPressed: () {
                authViewModel.clearErrorMessage();
                Navigator.pop(context);
              },
              child: Text('Back to Login'),
            ),
          ],
        ),
      ),
    );
  }
}