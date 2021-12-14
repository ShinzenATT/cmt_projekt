import 'package:cmt_projekt/api/navigation_handler.dart';
import 'package:cmt_projekt/viewmodel/stream_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppChannelPage extends StatefulWidget {
  const AppChannelPage({Key? key}) : super(key: key);

  @override
  _AppChannelPageState createState() => _AppChannelPageState();
}

class _AppChannelPageState extends State<AppChannelPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: context.read<StreamViewModel>().closeClient,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: AppBar(
            elevation: 0,
            centerTitle: true,
            title: Column(
              children: [Text('COMMENT'), Text('Demo')],
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
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.greenAccent,
              Colors.blueAccent,
            ],
          )),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(3),
                padding: const EdgeInsets.all(3),
                height: 80,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xFFFAF0E6),
                  border: Border.all(
                    color: Colors.indigo,
                    width: 3,
                  ),
                ),
                child: Text(context
                        .watch<StreamViewModel>()
                        .smodel
                        .recorder!
                        .isRecording
                    ? 'Playback to your headset!'
                    : 'Recorder is stopped'),
              ),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 20),
          child: FloatingActionButton(
            child: Icon(
                context.watch<StreamViewModel>().smodel.recorder!.isRecording
                    ? Icons.mic
                    : Icons.mic_off),
            onPressed: () {
              context.read<StreamViewModel>().getRecFn();
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Sök',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.house),
              label: 'Hem',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mic_none),
              label: 'Gå live!',
            ),
          ],
          onTap: (value) {
            setState(() {
              NaviHandler().setContext(context);
              NaviHandler().changePage(value);
            });
          },
          currentIndex: NaviHandler().index,
        ),
      ),
    );
  }
}
