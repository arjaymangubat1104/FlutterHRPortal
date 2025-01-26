import 'package:flutter/material.dart';
import 'package:flutter_attendance_system/widgets/loading_indicator.dart';
import 'package:flutter_attendance_system/widgets/prompt_dialog_box.dart';
import 'package:provider/provider.dart';
import '../viewmodel/auth_view_model.dart';
import '../viewmodel/theme_view_model.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _displayNameController = TextEditingController();

  bool _isObscure = true;

  bool _showSpinner = false;

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final themeViewModel = Provider.of<ThemeViewModel>(context);

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 100),
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
                            Icon(Icons.error_outline, color: Colors.red),
                            Text(
                              authViewModel.errorMessage!,
                              style: TextStyle(color: Colors.red, fontSize: 10),
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
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                    prefixIcon: Icon(Icons.text_fields_outlined),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.grey), // Default border color
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.grey), // Enabled border color
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.grey,
                          width: 2.0), // Focused border color
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
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.grey), // Default border color
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.grey), // Enabled border color
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.grey,
                          width: 2.0), // Focused border color
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
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                        icon: Icon(_isObscure
                            ? Icons.visibility_off
                            : Icons.visibility)),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.grey), // Default border color
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.grey), // Enabled border color
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.grey,
                          width: 2.0), // Focused border color
                    ),
                  ),
                  obscureText: _isObscure,
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _showSpinner = true;
                      });
                      if (_emailController.text.isEmpty) {
                        authViewModel.setErrorMessage('Email cannot be empty');
                      } else if (_passwordController.text.isEmpty) {
                        authViewModel
                            .setErrorMessage('Password cannot be empty');
                      } else if (_displayNameController.text.isEmpty) {
                        authViewModel
                            .setErrorMessage('Display Name cannot be empty');
                      } else {
                        try {
                          await authViewModel.register(
                            _emailController.text,
                            _passwordController.text,
                            _displayNameController.text,
                          );
                          if (authViewModel.isSuccessSignUp) {
                            Navigator.pop(context);
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return PromptDialogBox(
                                      icon: Icons.check_circle,
                                      title: 'Successfully Registered',
                                      content:
                                          'Congrats! You have successfully registered',
                                      buttonText: 'OK',
                                      isSuccess: authViewModel.isSuccessSignUp,
                                      onPressed: () {
                                        Navigator.pop(context);
                                        authViewModel.isSuccessSignUp = false;
                                      });
                                });
                          }
                          // Handle successful registration
                        } finally {
                          setState(() {
                            _showSpinner = false;
                          });
                        }
                      }
                      setState(() {
                        _showSpinner = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeViewModel.currentTheme.buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: Size(double.infinity, 56),
                    ),
                    child: Center(
                      child: Text(
                        'Register',
                        style: TextStyle(
                          color: themeViewModel.currentTheme.boxTextColor,
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
                          color: themeViewModel.currentTheme.textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_showSpinner)
            ModalBarrier(
              color: Colors.black.withOpacity(0.5),
              dismissible: false,
            ),
          if (_showSpinner)
            Dialog.fullscreen(
              backgroundColor: Colors.black.withOpacity(0.5),
              child: Center(
                child: CustomLoadingIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
