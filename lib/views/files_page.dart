import 'package:flutter/material.dart';

class FilesPage extends StatelessWidget{
  const FilesPage({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Files'),
      ),
      body: Center(
        child: Text('Files Page'),
      ),
    );
  }
}