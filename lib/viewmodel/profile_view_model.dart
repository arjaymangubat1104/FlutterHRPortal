import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_attendance_system/models/profile_info_model.dart';
import 'package:flutter_attendance_system/viewmodel/auth_view_model.dart';

class ProfileViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthViewModel authViewModel;
  ProfileViewModel({required this.authViewModel});

  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  
  final List<ProfileInfoModel> _profileInfoList = [
    ProfileInfoModel(title: 'Basic Information', value: {
      'First Name': 'Arjay',
      'Middle Name': 'Mangubat',
      'Last Name': '',
      'Employee ID': '',
      'Gender': '',
      'Civil Status': '',
      'Date of Birth': '',
    }),
    ProfileInfoModel(title: 'Contact Information', value: {
      'Home Address': '',
      'Provincial Address': '',
      'Personal Email': '',
      'Company Email': '',
      'Mobile No.': '',
      'Telephone No.': '',
      'Emergency Contact Person': '',
      'Emergency Contact No.': '',
    }),
    ProfileInfoModel(title: 'Work Information', value: {
      'Company': '',
      'Department': '',
      'Job Title': '',
      'Employee Type': '',
      'Immediate Supervisor': '',
      'Designed Workplace': '',
      'Employment Status': '',
      'User Type': '',
      'Job Code': '',
      'Job Grade': '',
      'Client Name': '',
      'Billabilty': '',
      'Hire Date': '',
      'Regularization Date': '',
      'Remarks': '',
    }),
    ProfileInfoModel(title: 'Government Information', value: {
      'SSS No.': '',
      'TIN': '',
      'PhilHealth No.': '',
      'Pag-IBIG No.': '',
      'GSIS No.': '',
    }),
    ProfileInfoModel(title: 'Eduational Background', value: {}),
  ];

  List<ProfileInfoModel> get profileInfoList => _profileInfoList;

  set profileInfoList(List<ProfileInfoModel> value) {
    _profileInfoList.addAll(value);
    notifyListeners();
  }

  //create a method that get user information
  Future<void> getUserInformation() async {
    try{
      String userId = authViewModel.userModel!.uid;
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(userId).get();
    if (!documentSnapshot.exists) {
      throw Exception('User information does not exist');
    }
    Map<String, dynamic> userInfo =
        documentSnapshot.data() as Map<String, dynamic>;
    _profileInfoList[0].value!['First Name'] = userInfo['first_name'];
    _profileInfoList[0].value!['Middle Name'] = userInfo['middle_name'];
    _profileInfoList[0].value!['Last Name'] = userInfo['last_name'];
    _profileInfoList[0].value!['Employee ID'] = userId;
    _profileInfoList[0].value!['Gender'] = userInfo['gender'];
    _profileInfoList[0].value!['Civil Status'] = userInfo['civil_status'];
    _profileInfoList[0].value!['Date of Birth'] = userInfo['birth_date'];
    _profileInfoList[0].value;
    notifyListeners();
    }catch(e){
      _errorMessage = e.toString();
      notifyListeners();
    }
    
  }
}
