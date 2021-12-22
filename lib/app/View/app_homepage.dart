import 'package:cmt_projekt/api/navigation_handler.dart';
import 'package:cmt_projekt/constants.dart' as constants;
import 'package:cmt_projekt/model/query_model.dart';
import 'package:cmt_projekt/viewmodel/stream_vm.dart';
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
  Widget _horizontalListView(
      {required Color color,
      required List<QueryModel> channelList,
      required String categoryName}) {
    return SizedBox(
      height: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
            child: Text(
              categoryName,
              style: const TextStyle(color: Colors.black),
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: channelList.length,
              itemBuilder: (BuildContext context, int index) => _buildBox(
                  color: color, channel: channelList[index], context: context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBox(
          {required Color color,
          required QueryModel channel,
          required BuildContext context}) =>
      Container(
          margin: const EdgeInsets.all(12),
          height: 100,
          width: 150,
          color: color,
          child: Column(
            children: [
              IconButton(
                onPressed: () {
                  context.read<VM>().setJoinPrefs(channel.channelid!,
                      channel.channelName!, channel.username!);
                  context.read<StreamViewModel>().startup(context);
                  Navigator.pushNamed(context, constants.joinChannel);
                },
                icon: const Icon(Icons.one_k_plus_outlined),
              ),
              Expanded(
                  child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          channel.channelName!,
                        ),
                      ))),
            ],
          ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(constants.menu);
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
                      context.watch<VM>().getUsername() ?? 'Gäst',
                      style: const TextStyle(fontSize: 13.0),
                    ),
                  ),
                ],
              ),
            ),
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

          /// Used to fetch live channels and display them in a list.
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
                    Map<String, List<QueryModel>> categories =
                        context.read<VM>().getCategoryNumber(channels);

                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: categories.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _horizontalListView(
                              color: Colors.deepPurple,
                              channelList:
                                  categories[categories.keys.elementAt(index)]!,
                              categoryName: categories.keys.elementAt(index));
                        },
                      ),
                    );
                  } else {
                    return const Text("No active channels");
                  }
                } else {
                  return Text("State: ${snapshot.connectionState}");
                }
              }),
          /* GradientElevatedButton(
            child: const Text(
              'DEMO',
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(constants.demo);
            },
            gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.greenAccent,
                  Colors.blueAccent,
                ]),
          ), */
          /* GradientElevatedButton(
            child: const Text(
              'Refresh',
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              context.read<VM>().updateChannels();
            },
            gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.greenAccent,
                  Colors.blueAccent,
                ]),
          ) */
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

///AlertMessage då man är inloggad som gäst. Gäst får förfrågan om att skapa konto för att få tillgång till funktionalitet.
class AlertMessage extends StatelessWidget {
  const AlertMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Du har inget konto"),
      content: const Text(
          "Den här funktionen är bara tillgänglig om man är inloggad, var vänlig skapa ett konto."),
      actions: <Widget>[
        TextButton(
          child: const Text("Stäng"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text("OK"),
          onPressed: () {
            context.read<VM>().createAccountPrompt(context);
          },
        ),
      ],
    );
  }
}
