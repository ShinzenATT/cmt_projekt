import 'package:cmt_projekt/models/query_model.dart';
import 'package:cmt_projekt/view_models/stream_vm.dart';
import 'package:cmt_projekt/view_models/main_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../apis/prefs.dart';

///The page responsible for displaying what the viewer sees when listening to a stream.
class AppListenPage extends StatelessWidget {
  const AppListenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<bool> willPopCallback() async {
      context.read<StreamViewModel>().closeClient();
      return context.read<MainViewModel>().willPopCallback();
    }
    return WillPopScope(
      onWillPop: willPopCallback,
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(80.0),
            child: AppBar(
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
                    context
                        .read<MainViewModel>()
                        .title
                        .toUpperCase(),
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Din moderna radioapp',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          body: buildStream(context),

          /// Navigate between online channels, "Swipe"
          floatingActionButton: FloatingActionButton.extended(
              onPressed: () async {
                List dataList = await context.read<MainViewModel>().databaseAPI.loadOnlineChannels().then((data) => data);
                if (dataList.isNotEmpty) {
                  int index = _getIndex(dataList, Prefs().storedData.getString("channelName").toString());

                  ///TODO Display a error message if going back to home_view?
                  ///If channel is not in dataList, return to home_view
                  if (index == -1) {
                    context.read<StreamViewModel>().closeClient();
                    context.read<MainViewModel>().willPopCallback();
                    Navigator.pop(context);
                  } else if (index + 1 < dataList.length) {
                    _setPrefs(index + 1, context, dataList);
                  } else {
                    _setPrefs(0, context, dataList);
                  }

                  ///Only for test purpose, remove this
                  print(Prefs().storedData.getString("channelName"));
                  print(Prefs().storedData.getString("category"));
                  print(dataList.length);
                  print(index);

                  ///TODO test if this load a new stream.
                  ///TODO  Display a error message if going back to home_view?
                  ///Load a new stream or move back to home_view
                  context.read<StreamViewModel>().sendUpdate(context);
                }else{
                  context.read<StreamViewModel>().closeClient();
                  context.read<MainViewModel>().willPopCallback();
                  Navigator.pop(context);
                }
              },
              label: const Text("Nästa")
          )

      ),

    );
  }

  Widget buildStream(BuildContext context) {
    return StreamBuilder(
      stream: context
          .watch<StreamViewModel>()
          .smodel
          .streamClient!
          .msgController
          .stream,
      initialData:
      QueryModel.fromJson({"total": 0, "channelname": "", "usename": ""}),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Text("error");
          } else if (snapshot.hasData) {
            QueryModel channel = snapshot.data;
            return Container(
              color: Colors.black,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              channel.channelname as String,
                              style: const TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          channel.username as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Row(
                      children: [
                        Flexible(
                            fit: FlexFit.loose,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        channel.total.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const Text(
                                        ' lyssnare',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 3, right: 3, top: 100),
                                    height: MediaQuery
                                        .of(context)
                                        .size
                                        .height *
                                        0.4,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      border: Border.all(
                                        color: Colors.white30,
                                        width: 3,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.play_arrow_outlined,
                                          color: Colors.white,
                                          size: MediaQuery
                                              .of(context)
                                              .size
                                              .height *
                                              0.2,
                                        ),
                                        Divider(
                                          thickness: 1,
                                          color: Colors.white,
                                          indent: MediaQuery
                                              .of(context)
                                              .size
                                              .width *
                                              0.05,
                                          endIndent: MediaQuery
                                              .of(context)
                                              .size
                                              .width *
                                              0.05,
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            "No information",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Text("No active channels");
          }
        } else {
          return Text("State: ${snapshot.connectionState}");
        }
      },
    );
  }
   ///Set new Prefs
  _setPrefs(int index, BuildContext context, List dataList) {
    context.read<MainViewModel>().setJoinPrefs(
      dataList[index].channelid!,
      dataList[index].channelname!,
      dataList[index].username!,
      dataList[index].category!,
    );
  }
  ///Return List index of given String
  ///If List is empty or List don't contain String return -1
  int _getIndex(List dataList, String channelName) {
    int index = 0;
    if(dataList.isNotEmpty) {
      for (var temp in dataList) {
        if (temp.channelname! == channelName) {
          break;
        } else {
          index += 1;
        }
      }
      if(index < dataList.length) {
        return index;
      }
    }
    return -1;
  }
}
