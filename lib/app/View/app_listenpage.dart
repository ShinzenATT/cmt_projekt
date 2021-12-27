import 'package:cmt_projekt/api/prefs.dart';

import 'package:cmt_projekt/model/query_model.dart';

import 'package:cmt_projekt/viewmodel/stream_vm.dart';
import 'package:cmt_projekt/viewmodel/vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/*
  The page responsible for displaying what the viewer sees
  when listening to a stream.
 */
class AppListenPage extends StatelessWidget {
  const AppListenPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    Future<bool> willPopCallback() async {
      context.read<StreamViewModel>().closeClient();
      return context.read<VM>().willPopCallback();
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
                  context.read<VM>().title.toUpperCase(),

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
        body: Container(
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
                          (Prefs().storedData.getString("channelName")!),
                          style: const TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                      ),
                    ),
                    Text(
                      (Prefs().storedData.getString("hostUsername")!),
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
                    const Icon(
                      Icons.person,
                      color: Colors.white,
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
                              QueryModel? channel =
                              context.read<VM>().getChannel(snapshot.data,
                                  Prefs().storedData.getString("channelName")!);
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  channel != null ? channel.total.toString() : "0", //Här ska countern läggas in för aktiva lyssnare.
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              );
                            } else {
                              return const Text("No active channels");
                            }
                          } else {
                            return Text("State: ${snapshot.connectionState}");
                          }
                        }),

                    const Text(

                      'lyssnare', //Här ska countern läggas in för aktiva lyssnare.
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Container(

                margin: const EdgeInsets.only(left:3,right:3,top:100),

                height: MediaQuery.of(context).size.height * 0.4,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.play_arrow_outlined,
                      color: Colors.white,
                      size: MediaQuery.of(context).size.height * 0.2,
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.white,
                      indent: MediaQuery.of(context).size.width * 0.05,
                      endIndent: MediaQuery.of(context).size.width * 0.05,
                    ),

                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Här ska det stå om kanalen sänder',
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
        ),
      ),
    );
  }
}
