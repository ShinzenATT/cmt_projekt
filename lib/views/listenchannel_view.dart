import 'package:cmt_projekt/models/query_model.dart';
import 'package:cmt_projekt/view_models/stream_vm.dart';
import 'package:cmt_projekt/view_models/main_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

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
                    context.read<MainViewModel>().title.toUpperCase(),
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Din moderna radioapp',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
          body: buildStream(context)),
    );
  }

  Widget buildStream(BuildContext context) {
    const streamImage = "https://images.unsplash.com/photo-1633876841461-772d2b0b0e39?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1062&q=80";
    const profileImage = "https://images.unsplash.com/photo-1582750433449-648ed127bb54?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80";
    const streamDescription = "Jakten på lycka";
    return StreamBuilder(
      stream: context.watch<StreamViewModel>().smodel.streamClient!.msgController.stream,
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
              decoration: const BoxDecoration(
                image:  DecorationImage(
                  image:  NetworkImage(streamImage),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
                  child: Column(
                    children: <Widget>[
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
                                    // v information about listeners
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
                                    //------------------------------------------
                                    // v Central image of the stream, this should come from the tableau
                                    //------------------------------------------
                                    Container(
                                      margin: const EdgeInsets.only(left: 3, right: 3, top: 100),
                                      height: MediaQuery.of(context).size.height*0.4,
                                      alignment: Alignment.center,
                                      decoration:  BoxDecoration(
                                        image: const DecorationImage(
                                          image: NetworkImage(streamImage),
                                          fit: BoxFit.cover,
                                        ),
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    //------------------------------------------
                                    // v Channel name text goes here
                                    //------------------------------------------
                                    Text(
                                      channel.channelname as String,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          shadows: [
                                            Shadow(
                                                offset: Offset(-1.5, -1.5),
                                                color: Colors.black,
                                                blurRadius: 2
                                            ),
                                          ]
                                      ),
                                    ),
                                    const Divider(
                                      color: Colors.grey,
                                      thickness: 2,
                                    ),
                                    //------------------------------------------
                                    //v Description for the current stream, this should come from the tableau
                                    //------------------------------------------
                                    const Text(
                                      streamDescription,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          shadows: [
                                            Shadow(
                                                offset: Offset(-1.5, -1.5),
                                                color: Colors.black,
                                                blurRadius: 2
                                            ),
                                          ]
                                      ),
                                    ),
                                    //------------------------------------------
                                    //v channel's profile image is created here
                                    //------------------------------------------
                                    Row(
                                      children: <Widget>[
                                        const Spacer(),
                                        Container(
                                          margin: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                                          height: MediaQuery.of(context).size.height*0.12,
                                          width: MediaQuery.of(context).size.height*0.12,
                                          alignment: Alignment.topRight,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: NetworkImage(profileImage),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),


                ),
              )
              /*

              */
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
}

class ListenView extends StatefulWidget {
  const ListenView({
    Key? key,
  }) : super(key: key);

  @override
  State<ListenView> createState() => _ListenViewState();
}

class _ListenViewState extends State<ListenView> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Image.network('https://images.unsplash.com/photo-1670181741093-6503d030a0c6?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1331&q=80'),
      Container(child: Text("Stuff")),
    ]);
  }
}
