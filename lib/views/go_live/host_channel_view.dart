import 'package:cmt_projekt/models/channel_data_model.dart';
import 'package:cmt_projekt/models/query_model.dart';
import 'package:cmt_projekt/view_models/stream_vm.dart';
import 'package:cmt_projekt/widgets/go_live_settings_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


///The page responsible for displaying what the host sees when streaming.
class HostChannelView extends StatefulWidget {
  const HostChannelView({Key? key}) : super(key: key);

  @override
  _HostChannelViewState createState() => _HostChannelViewState();
}

class _HostChannelViewState extends State<HostChannelView> {

  @override
  Widget build(BuildContext context) {

    StreamVM streamVM = Provider.of<StreamVM>(context);

    return Scaffold(
      body: StreamBuilder(
            stream: context.watch<StreamVM>().streamModel.streamClient!.msgController.stream,
            initialData: QueryModel.fromJson(
                {"total": 0, "channelname": "", "username": ""}),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return const Text("error");
                } else if (snapshot.hasData) {
                  ChannelDataModel channel = snapshot.data;
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
                                    channel.channelname,
                                    style: const TextStyle(
                                      color: Colors.greenAccent,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  channel.username,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
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
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  channel.total.toString(),
                                  //Här ska countern läggas in för aktiva lyssnare.
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              const Text(
                                'lyssnare',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(3),
                          padding: const EdgeInsets.all(3),
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: double.infinity,
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
                                size: MediaQuery.of(context).size.height * 0.15,
                              ),
                              Divider(
                                thickness: 1,
                                color: Colors.white,
                                indent:
                                    MediaQuery.of(context).size.width * 0.05,
                                endIndent:
                                    MediaQuery.of(context).size.width * 0.05,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    liveNotification(context),
                                    descriptionBox(context),
                                  ],
                                ),
                              ),
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
            }),
        floatingActionButton: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 20),
          child: FloatingActionButton(
            child: Icon(
                streamVM.streamModel.recorder!.isRecording
                    ? Icons.mic
                    : Icons.mic_off),
            onPressed: () {
              streamVM.getRecFn();
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
  }

  Widget descriptionBox(BuildContext context) {
    /*
    if (context.watch<VM>().hasChannelDescription()) {
      return SizedBox(
          width: double.infinity,
          child: Text(
            context.watch<VM>().getChannelDescription().toString(),
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ));
    } else {
     */

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: const GoLiveSettings().build
          );
        },
        child: const Text("Lägg till information"),
      ),
    );
  }

  Widget liveNotification(BuildContext context) {
    if (!context.watch<StreamVM>().streamModel.recorder!.isRecording) {
      return const Text(
        'Sändningen är pausad',
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      );
    }
    return Column();
  }
}
