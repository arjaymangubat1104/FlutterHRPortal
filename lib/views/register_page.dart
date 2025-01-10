import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/auth_view_model.dart';

class RegisterPage extends StatefulWidget {

  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _displayNameController = TextEditingController();

  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(
              'lib/assets/logo.png',
              height: 300,
            ),
            if (authViewModel.errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.red[100],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline, 
                          color: Colors.red
                        ),
                        Text(
                          authViewModel.errorMessage!,
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Register',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Please enter your details to register',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
             TextField(
              controller: _displayNameController,
              decoration: InputDecoration(
                labelText: 'Display Name',
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                hintText: 'Enter your display name',
                prefixIcon: Icon(
                  Icons.text_fields_outlined
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey), // Default border color
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey), // Enabled border color
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 2.0), // Focused border color
                ),
              ),
            ),
            SizedBox(height: 10),
             TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                hintText: 'Enter your email',
                prefixIcon: Icon(
                  Icons.email
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey), // Default border color
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey), // Enabled border color
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 2.0), // Focused border color
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                hintText: 'Enter your password',
                prefixIcon: Icon(
                  Icons.lock
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  }, 
                  icon: Icon(
                    _isObscure ? Icons.visibility_off : Icons.visibility
                  )
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey), // Default border color
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey), // Enabled border color
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 2.0), // Focused border color
                ),
              ),
              obscureText: _isObscure,
            ),
            SizedBox(height: 20),
           SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_emailController.text.isEmpty) {
                    authViewModel.setErrorMessage('Email cannot be empty');
                  } else if (_passwordController.text.isEmpty) {
                    authViewModel.setErrorMessage('Password cannot be empty');
                  } else if(_displayNameController.text.isEmpty) {
                    authViewModel.setErrorMessage('Display Name cannot be empty');
                  } else {
                    await authViewModel.register(
                      _displayNameController.text,
                      _emailController.text,
                      _passwordController.text,
                      context,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: Size(double.infinity, 56),
                ),
                child: Center(
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    authViewModel.clearErrorMessage();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}