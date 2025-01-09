import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../viewmodel/auth_view_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final userModel = authViewModel.userModel;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              authViewModel.logout(context);
            },
          ),
        ],
      ),
      body: Center(
        child: userModel != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Welcome, ${userModel.displayName}!'),
                  Text('Email: ${userModel.email}'),
                ],
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}