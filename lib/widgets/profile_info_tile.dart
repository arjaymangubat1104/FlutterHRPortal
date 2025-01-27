import 'package:flutter/material.dart';

class ProfileInfoTile extends StatelessWidget{
  final String title;
  final IconData icon;

  ProfileInfoTile({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Icon(icon),
      title: Text(title),
      children: [
        Text(
          'This is the content of the tile',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        )
      ],
    );
  }
}