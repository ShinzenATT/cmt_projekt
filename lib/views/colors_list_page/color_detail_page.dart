import 'package:flutter/material.dart';

class ColorDetailPage extends StatelessWidget {
  const ColorDetailPage({
    Key? key,
    required this.title,
    this.materialIndex = 500}) : super(key: key);
  final String title;
  final int materialIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$title[$materialIndex]',
        ),
      ),
      body: Container(
      ),
    );
  }
}