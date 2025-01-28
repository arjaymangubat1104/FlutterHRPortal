import 'package:flutter/material.dart';

class ProfileInfoModel {
  final IconData icon;
  final String title;
  final Map<String, String>? value;

  ProfileInfoModel({
    required this.icon,
    required this.title,
    required this.value,
  });

}