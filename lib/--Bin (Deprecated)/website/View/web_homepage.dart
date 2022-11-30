import 'package:cmt_projekt/models/query_model.dart';
import 'package:cmt_projekt/view_models/stream_vm.dart';
import 'package:cmt_projekt/view_models/main_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cmt_projekt/constants.dart' as constants;

///Homepage för hemsidan.
class WebHomePage extends StatefulWidget {
  const WebHomePage({Key? key}) : super(key: key);

  @override
  _WebHomePageState createState() => _WebHomePageState();
}

class _WebHomePageState extends State<WebHomePage> {
  Widget _horizontalListView(
      {required String image,
      required List<QueryModel> channelList,
      required String categoryName}) {
    return SizedBox(
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
            child: Text(
              categoryName,
              style: const TextStyle(color: Colors.black, fontSize: 20),
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: channelList.length,
              itemBuilder: (BuildContext context, int index) => _buildBox(
                  image: context.read<MainViewModel>().categoryList[categoryName]!,
                  channel: channelList[index],
                  context: context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBox(
          {required String image,
          required QueryModel channel,
          required BuildContext context}) =>
      InkWell(
          onTap: () {
            context.read<MainViewModel>().setJoinPrefs(
                  channel.channelid!,
                  channel.channelname!,
                  channel.username!,
                );

            context.read<StreamViewModel>().startup(context);
            Navigator.pushNamed(context, constants.joinChannel);
          },
          child: Card(
            elevation: 10,
            child: Stack(
              children: [
                Image.network(
                  image,
                  fit: BoxFit.fill,
                ),
                Image.network(
                  image,
                  fit: BoxFit.fill,
                  color: Colors.black.withOpacity(0.5),
                ),
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Center(
                    child: Text(
                      channel.channelname!,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    SizedBox(
                      child: Text(channel.total.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )),
                    )
                  ],
                ),
              ],
            ),
          ));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          ///Färgtemat för appbaren på startsidan.
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                Colors.greenAccent,
                Colors.blueAccent,
              ])),
        ),

        ///En textknapp med texten COMMENT, har i dagsläget ingen funktion men tanken
        /// är att man ska hamna längst upp på startsidan igen.
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              onTap: () {},
              child: Text(
                context.read<MainViewModel>().title.toUpperCase(),
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),

      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'Live just nu',
            style: TextStyle(fontSize: 22),
          ),

          /// Used to fetch live channels and display them in a list.
          StreamBuilder(
              stream: context.watch<MainViewModel>().databaseAPI.channelController.stream,
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
                        context.read<MainViewModel>().getCategoryNumber(channels);
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: categories.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _horizontalListView(
                              image: "ds",
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
        ],
      ),

      ///The menu in the app bar on the website.
      ///Contains a header with a text and the users email.
      ///Also contains a list with different text buttons which takes the user the the profile page etc.
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Colors.blueAccent,
                    Colors.greenAccent,
                  ])),
              child: Column(
                children: [
                  const Text(
                    'HEJ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    context.read<MainViewModel>().getUsername() ?? 'Gäst',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Allmänt',
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            ListTile(
              title: const Text('Kontoinställningar'),
              onTap: () {
                // Update the state of the app.
                // ...
                context.read<MainViewModel>().profileInformation(context);
              },
            ),
            ListTile(
              title: const Text('Appinställningar'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Mitt konto',
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            ListTile(
              title: const Text('Kanalutseende'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text('Min kanal'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text('Streaming intällningar'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text('Saldo'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text('Prenumerationer & följare'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Hjälplcenter',
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            ListTile(
              title: const Text('Kontakta oss'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text('Vanliga frågor'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            TextButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text(
                'Logga ut',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                context.read<MainViewModel>().logOut(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
