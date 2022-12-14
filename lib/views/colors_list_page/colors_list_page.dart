import 'package:flutter/material.dart';

class ColorsListPage extends StatelessWidget {
  ColorsListPage({
    Key? key,
    required this.title,
    this.onPush}) : super(key: key);

  final String title;
  final ValueChanged<int>? onPush;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            title,
          ),
        ),
        body: Container(
          color: Colors.white,
          child: _buildList(),
        ));
  }

  final List<int> materialIndices = [
    900,
    800,
    700,
    600,
    500,
    400,
    300,
    200,
    100,
    50
  ];

  Widget _buildList() {
    return ListView.builder(
        itemCount: materialIndices.length,
        itemBuilder: (BuildContext content, int index) {
          int materialIndex = materialIndices[index];
          return Container(
            child: ListTile(
              title: Text('$materialIndex',
                  style: const TextStyle(fontSize: 24.0)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => onPush?.call(materialIndex),
            ),
          );
        });
  }
}