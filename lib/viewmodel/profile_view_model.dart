import 'package:flutter/material.dart';
import 'package:flutter_attendance_system/models/profile_info_model.dart';
import 'package:flutter_attendance_system/models/user_model.dart';

class ProfileViewModel extends ChangeNotifier{

  final List<ProfileInfoModel> _profileInfoList = [
    ProfileInfoModel(
      icon: Icons.person,
      title: 'Basic Information',
      value: {
        'First Name': '',
        'Middle Name': '',
        'Last Name': '',
        'Employee ID': '',
        'Gender': '',
        'Civil Status': '',
        'Date of Birth': '',
      }
    ),
    ProfileInfoModel(
      icon: Icons.work,
      title: 'Work Information',
      value: {
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
      }
    ),
    ProfileInfoModel(
      icon: Icons.location_city,
      title: 'Government Information',
      value: {
        'SSS No.': '',
        'TIN': '',
        'PhilHealth No.': '',
        'Pag-IBIG No.': '',
        'GSIS No.': '',
      }
    ),
    ProfileInfoModel(
      icon: Icons.school, 
      title: 'Eduational Background', 
      value: {

      }
    ),
    ProfileInfoModel(
      icon: Icons.phone, 
      title: 'Contact Information', 
      value: {
        'Home Address': '',
        'Provincial Address': '',
        'Personal Email': '',
        'Company Email': '',
        'Mobile No.': '',
        'Telephone No.': '',
        'Emergency Contact Person': '',
        'Emergency Contact No.': '',
      }
   )
    
  ];

  List<ProfileInfoModel> get profileInfoList => _profileInfoList;

  set profileInfoList(List<ProfileInfoModel> value){
    _profileInfoList.addAll(value);
    notifyListeners();
  }

  UserModel? _userModel;
  UserModel? get userModel => _userModel;
  
  
}