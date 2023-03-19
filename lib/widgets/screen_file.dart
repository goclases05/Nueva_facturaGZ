import 'package:flutter/material.dart';

class Screenfile extends StatelessWidget {
  Screenfile({super.key, required this.filePath});
  String filePath;

  @override
  Widget build(BuildContext context) {
    print(filePath);
    return Scaffold(
      appBar: AppBar(
        title: Text("doc"),
      ),
    );
  }
}