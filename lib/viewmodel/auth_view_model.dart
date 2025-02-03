import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_attendance_system/viewmodel/schedule_view_model.dart';
import '../models/user_model.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ScheduleViewModel scheduleViewModel = ScheduleViewModel();

  UserModel? _userModel;
  String? _errorMessage;
  bool _isSuccessSignUp = false;

  UserModel? get userModel => _userModel;
  String? get errorMessage => _errorMessage;
  bool get isSuccessSignUp => _isSuccessSignUp;

  set isSuccessSignUp(bool value) {
    _isSuccessSignUp = value;
    notifyListeners();
  }

  Future<void> register(
      String email,
      String password,
      String userName,
      String firstName,
      String middleName,
      String lastName,
      String gender,
      String civilStatus,
      String birthDate) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      // Store user information in Firestore
      _userModel = UserModel(
          uid: user!.uid,
          email: email,
          userName: userName,
          firstName: firstName,
          middleName: middleName,
          lastName: lastName,
          gender: gender,
          civilStatus: civilStatus,
          birthDate: birthDate);
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(_userModel!.toMap());
      await scheduleViewModel.saveDefaultSchedule(user.uid);

      notifyListeners();
      _isSuccessSignUp = true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getFirebaseAuthErrorMessage(e);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> login(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      // Fetch user information from Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(user!.uid)
          .get();
      if (userDoc.exists) {
        _userModel = UserModel.fromFirebase(
            userDoc.data() as Map<String, dynamic>, user.uid);
      }

      _errorMessage = null;
      notifyListeners();
      Navigator.pushReplacementNamed(context, '/intro');
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getFirebaseAuthErrorMessage(e);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  String _getFirebaseAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'The email address is badly formatted.';
      case 'user-disabled':
        return 'The user account has been disabled.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'The email address is already in use by another account.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'weak-password':
        return 'The password is too weak.';
      default:
        return 'Incorrect email or password.';
    }
  }

  Future<void> logout(BuildContext context) async {
    await _auth.signOut();
    await FirebaseFirestore.instance.terminate();
    await FirebaseFirestore.instance.clearPersistence();
    _userModel = null;
    notifyListeners();
    Navigator.pushReplacementNamed(context, '/login');
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
