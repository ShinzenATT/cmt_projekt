import 'package:cmt_projekt/api/prefs.dart';
import 'package:cmt_projekt/constants.dart';
import 'package:cmt_projekt/viewmodel/stream_view_model.dart';
import 'package:flutter/material.dart';
import 'package:gradient_ui_widgets/gradient_ui_widgets.dart';
import 'package:provider/src/provider.dart';

import '../../constants.dart';

class StreamLoop extends StatefulWidget {
  @override
  _StreamLoopState createState() => _StreamLoopState();
}

class _StreamLoopState extends State<StreamLoop> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: context.read<StreamViewModel>().closeClient,
        child: Scaffold(
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
                      Colors.black,
                      Colors.blueAccent,
                    ])),
              ),
            ),
          ),
          body: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black,
                Colors.blueAccent,
              ],
            )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: context.watch<StreamViewModel>().hostID,
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
                          Navigator.of(context).pushNamed(appChannel);
                          Prefs().storedData.setString("intent", "h");
                          context.read<StreamViewModel>().startup(context);
                        },
                        gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.black,
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
                          Navigator.of(context).pushNamed(appChannel);
                          context.read<StreamViewModel>().startup(context);
                          Prefs().storedData.setString(
                              "joinChannelID",
                              context
                                  .watch<StreamViewModel>()
                                  .hostID
                                  .value
                                  .text);
                          Prefs().storedData.setString("intent", "j");
                          print(Prefs().storedData.get("intent").toString());
                        },
                        gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.black,
                              Colors.blueAccent,
                            ]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
