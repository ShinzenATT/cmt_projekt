import 'dart:convert';

import 'package:cmt_projekt/api/navigation_handler.dart';
import 'package:cmt_projekt/constants.dart';
import 'package:cmt_projekt/model/querymodel.dart';
import 'package:cmt_projekt/viewmodel/stream_view_model.dart';
import 'package:cmt_projekt/viewmodel/vm.dart';
import 'package:flutter/material.dart';
import 'package:gradient_ui_widgets/gradient_ui_widgets.dart';
import 'package:provider/provider.dart';

class AppHomePage extends StatefulWidget {
  const AppHomePage({Key? key}) : super(key: key);

  @override
  _AppHomePageState createState() => _AppHomePageState();
}

class _AppHomePageState extends State<AppHomePage> {
  Widget _horizontalListView({required Color color, required List<QueryModel> channelList}) {
    return SizedBox(
      height: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
            child: const Text(
              'Kategori',
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: channelList.length,
              itemBuilder: (BuildContext context, int index) => _buildBox(color: color, channel: channelList[index], context: context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBox({required Color color, required QueryModel channel, required BuildContext context}) => Container(
      margin: const EdgeInsets.all(12),
      height: 100,
      width: 150,
      color: color,
      child: IconButton(
        onPressed: () {
          context.read<VM>().setJoinPrefs(channel.channelid!);
          context.read<StreamViewModel>().startup(context);
        },
        icon: const Icon(Icons.one_k_plus_outlined),
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(appMenu);
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(
                    child: Icon(Icons.account_circle_outlined),
                  ),
                  Center(
                    child: Text(
                      context.watch<VM>().getEmail() ?? 'Gäst',
                      style: const TextStyle(fontSize: 13.0),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /* actions: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(appChannel);
                  Prefs().storedData.setString("intent", "h");
                  context.read<StreamViewModel>().startup(context);
                },
                icon: const Icon(Icons.mic_none),
                iconSize: 30,
              ),
            )
          ], */
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
          elevation: 0,
          centerTitle: true,
          title: Column(
            children: [
              Text(
                context.read<VM>().title.toUpperCase(),
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Din moderna radioapp',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'Radiokanaler',
            style: TextStyle(fontSize: 18),
          ),
          StreamBuilder(
              stream: context.watch<VM>().databaseAPI.channelController.stream,
              initialData: 0,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.connectionState == ConnectionState.active ||
                    snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return const Text("error");
                  } else if (snapshot.hasData) {

                   List<QueryModel> channels = snapshot.data;


                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: 5,
                        itemBuilder: (BuildContext context, int index) {
                          return _horizontalListView(
                              color: Colors.deepPurple,
                              channelList: channels);
                        },
                      ),
                    );
                  }else{
                    return const Text("No active channels");
                  }
                }else{
                  return Text("State: ${snapshot.connectionState}");
                }
              }),
          GradientElevatedButton(
            child: const Text(
              'DEMO',
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(demo);
            },
            gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.greenAccent,
                  Colors.blueAccent,
                ]),
          ),
        ],
      ),
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
    );
  }
}
