
import 'package:flutter/material.dart';
import 'package:flutter_attendance_system/widgets/loading_indicator.dart';
import 'package:flutter_attendance_system/widgets/prompt_dialog_box.dart';
import 'package:intl/intl.dart';
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
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();

  bool _isObscure = true;

  bool _showSpinner = false;

  String _selectedGender = '';
  String _selectedCivilStatus = '';

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final themeViewModel = Provider.of<ThemeViewModel>(context);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constrains) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constrains.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
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
                                          style:
                                              TextStyle(color: Colors.red, fontSize: 10),
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
                                  style: TextStyle(
                                      fontSize: 24, fontWeight: FontWeight.bold),
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
                              controller: _userNameController,
                              decoration: InputDecoration(
                                labelText: 'User Name',
                                labelStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                hintText: 'Enter your user name',
                                prefixIcon: Icon(Icons.text_format_outlined),
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
                              controller: _firstNameController,
                              decoration: InputDecoration(
                                labelText: 'First Name',
                                labelStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                hintText: 'Enter your first name',
                                prefixIcon: Icon(Icons.text_format_outlined),
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
                              controller: _middleNameController,
                              decoration: InputDecoration(
                                labelText: 'Middle Name',
                                labelStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                hintText: 'Enter your middle name',
                                prefixIcon: Icon(Icons.text_format_outlined),
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
                              controller: _lastNameController,
                              decoration: InputDecoration(
                                labelText: 'Last Name',
                                labelStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                hintText: 'Enter your last name',
                                prefixIcon: Icon(Icons.text_format_outlined),
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
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: DropdownButton<String>(
                                      value: _selectedGender == '' ? null : _selectedGender,
                                      items: ['Male', 'Female', 'Others']
                                          .map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      hint: Text('Gender',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15
                                        ),
                                      ),
                                      underline: SizedBox(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _selectedGender = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: DropdownButton<String>(
                                      value: _selectedCivilStatus == ''
                                          ? null
                                          : _selectedCivilStatus,
                                      items: ['Single', 'Married', 'Divorced', 'Widowed']
                                          .map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      hint: Text(
                                        'Civil Status',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15
                                        ),
                                      ),
                                      underline: SizedBox(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _selectedCivilStatus = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 10),
                            TextField(
                          controller: _birthDateController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Birth Date',
                            labelStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            hintText: 'Select your birth date',
                            prefixIcon: Icon(Icons.cake),
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
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                _birthDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                              });
                            }
                          },
                        ),
                            SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    _showSpinner = true;
                                  });
                                  if (_userNameController.text.isEmpty) {
                                    authViewModel
                                        .setErrorMessage('User Name cannot be empty');
                                  } else if (_firstNameController.text.isEmpty) {
                                    authViewModel
                                        .setErrorMessage('First Name cannot be empty');
                                  } else if (_middleNameController.text.isEmpty) {
                                    authViewModel
                                        .setErrorMessage('Middle Name cannot be empty');
                                  } else if (_lastNameController.text.isEmpty) {
                                    authViewModel
                                        .setErrorMessage('Last Name cannot be empty');
                                  } else if (_emailController.text.isEmpty) {
                                    authViewModel
                                        .setErrorMessage('Email cannot be empty');
                                  } else if (_passwordController.text.isEmpty) {
                                    authViewModel
                                        .setErrorMessage('Password cannot be empty');
                                  } else if (_selectedGender.isEmpty) {
                                    authViewModel
                                        .setErrorMessage('Gender cannot be empty');
                                  } else if (_selectedCivilStatus.isEmpty) {
                                    authViewModel
                                        .setErrorMessage('Civil status cannot be empty');
                                  } else if (_birthDateController.text.isEmpty) {
                                    authViewModel
                                        .setErrorMessage('Birth date cannot be empty');
                                  } else {
                                    try {
                                      await authViewModel.register(
                                        _emailController.text,
                                        _passwordController.text,
                                        _userNameController.text,
                                        _firstNameController.text,
                                        _middleNameController.text,
                                        _lastNameController.text,
                                        _selectedGender,
                                        _selectedCivilStatus,
                                        _birthDateController.text,
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
                                                  isSuccess:
                                                      authViewModel.isSuccessSignUp,
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
                                  backgroundColor:
                                      themeViewModel.currentTheme.buttonColor,
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
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}
