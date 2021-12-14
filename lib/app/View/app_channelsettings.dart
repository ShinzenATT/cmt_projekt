import 'dart:ui';

import 'package:cmt_projekt/viewmodel/vm.dart';
import 'package:flutter/material.dart';
import 'package:gradient_ui_widgets/gradient_ui_widgets.dart';
import 'package:provider/provider.dart';

class AppChannelSettings extends StatelessWidget {
  AppChannelSettings({Key? key}) : super(key: key);
  final categoryList = ['Sport', 'Rock', 'Jazz', 'Pop', 'Tjööt'];

  DropdownMenuItem<String> categoryItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.account_circle_outlined,
                          size: 40,
                        ),
                      ),
                      Text(
                        context.read<VM>().getEmail() ?? 'Gäst',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: context.watch<VM>().channelName,
                      decoration: const InputDecoration(
                        labelText: 'Namn på radiokanal',
                        suffixIcon: Icon(Icons.note_alt_outlined),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Kategori',
                        border: OutlineInputBorder(),
                      ),
                      value: context.watch<VM>().getCategory,
                      isExpanded: true,
                      validator: (value) => null,
                      autovalidateMode: AutovalidateMode.always,
                      items: categoryList.map(categoryItem).toList(),
                      onChanged: (value) {
                        context.read<VM>().setCategory(value);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  child: GradientElevatedButton.icon(
                    onPressed: () {
                      context.read<VM>().setChannelSettings();
                    },
                    gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.greenAccent,
                          Colors.blueAccent,
                        ]),
                    icon: Padding(
                      padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.2,
                          left: MediaQuery.of(context).size.width * 0.2),
                      child: const Text(
                        'Gå Live',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    label: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
