import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/auth_view_model.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    // Clear error message when the page is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authViewModel.clearErrorMessage();
    });

    return Scaffold(
      appBar: AppBar(title: Text('Login')),
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
                if (_emailController.text.isEmpty) {
                  authViewModel.setErrorMessage('Email cannot be empty');
                } else if (_passwordController.text.isEmpty) {
                  authViewModel.setErrorMessage('Password cannot be empty');
                } else {
                  await authViewModel.login(
                    _emailController.text,
                    _passwordController.text,
                    context,
                  );
                }
              },
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () {
                authViewModel.clearErrorMessage();
                Navigator.pushNamed(context, '/register');
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}