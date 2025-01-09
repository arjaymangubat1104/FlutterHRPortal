import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserModel? _userModel;
  String? _errorMessage;

  UserModel? get userModel => _userModel;
  String? get errorMessage => _errorMessage;

  Future<void> register(String email, String password, String displayName, BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      // Store user information in Firestore
      _userModel = UserModel(uid: user!.uid, email: email, displayName: displayName);
      await _firestore.collection('users').doc(user.uid).set(_userModel!.toMap());

      notifyListeners();
      Navigator.pop(context);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> login(String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      // Fetch user information from Firestore
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user!.uid).get();
      if (userDoc.exists) {
        _userModel = UserModel.fromFirebase(userDoc.data() as Map<String, dynamic>, user.uid);
      }

      _errorMessage = null;
      notifyListeners();
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        _errorMessage = 'Wrong password provided.';
      } else {
        _errorMessage = 'An error occurred. Please try again.';
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> logout(BuildContext context) async {
    await _auth.signOut();
    _userModel = null;
    notifyListeners();
    Navigator.pushReplacementNamed(context, '/');
  }

  void clearErrorMessage() {
    _errorMessage = null;
    notifyListeners();
  }

  void setErrorMessage(String message) {
    _errorMessage = message;
    notifyListeners();
  }
}

