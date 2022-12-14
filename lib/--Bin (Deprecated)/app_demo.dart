import 'package:cmt_projekt/apis/prefs.dart';
import 'package:cmt_projekt/constants.dart';
import 'package:cmt_projekt/--Bin%20(Deprecated)/demo_stream_vm.dart';
import 'package:cmt_projekt/view_models/stream_vm.dart';
import 'package:flutter/material.dart';
import 'package:gradient_ui_widgets/gradient_ui_widgets.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

/// !!! DEPRECATED !!!
/// Created by previous group and moved to deprecated to clean up
/// project structure.
/*
class StreamLoop extends StatefulWidget {
  const StreamLoop({Key? key}) : super(key: key);

  @override
  _StreamLoopState createState() => _StreamLoopState();
}

class _StreamLoopState extends State<StreamLoop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Column(
            children: const [
              Text('COMMENT'),
              Text('Demo'),
            ],
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                  Colors.greenAccent,
                  Colors.blueAccent,
                ])),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            color: Colors.white,
            child: Column(
              children: [
                TextFormField(
                  controller: context.watch<DemoStreamViewModel>().hostID,
                  decoration: const InputDecoration(
                    fillColor: Colors.white,
                    labelText: 'HostId',
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 150,
                height: 50,
                child: GradientElevatedButton(
                  child: const Text(
                    'Host',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(hostChannel);
                    Prefs().storedData.setString("intent", "h");
                    context.read<StreamViewModel>().startup(context);
                  },
                  gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.greenAccent,
                        Colors.blueAccent,
                      ]),
                ),
              ),
              SizedBox(
                width: 150,
                height: 50,
                child: GradientElevatedButton(
                  child: const Text(
                    'Join',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(hostChannel);
                    context.read<DemoStreamViewModel>().demoJoin();
                    context.read<StreamViewModel>().startup(context);
                  },
                  gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.greenAccent,
                        Colors.blueAccent,
                      ]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


 */