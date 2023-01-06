import 'package:cmt_projekt/models/channel_data_model.dart';
import 'package:cmt_projekt/view_models/stream_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cmt_projekt/constants.dart' as constants;
import '../../apis/prefs.dart';
import '../../view_models/main_vm.dart';
import '../../view_models/navigation_vm.dart';
import 'dart:ui';


///The page responsible for displaying what te viewer sees when listening to a stream.
class ListenChannelView extends StatelessWidget {
  /// A const constructor for [ListenChannelView]
  const ListenChannelView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: context.watch<StreamVM>().streamModel.streamClient!.msgController.stream,
      initialData: ChannelDataModel(channelid: '', category: '', channelname: ''),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
              color: Colors.black,
              child: Column(
                  children: [
                SizedBox(
                height: 200,
                width: 200,
                child: Container()
                ),
                    const Center(
                      child:
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: CircularProgressIndicator(),
                    )
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    buildActionButtonsRow(context),
                  ],
              )
          );
        } else if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Container(
                color: Colors.black,
                child: const Center(
                      child: Text("error",
                        style: TextStyle(color: Colors.white),
                    ),
                )
            );
          } else if (snapshot.hasData) {
            ChannelDataModel channel = snapshot.data;
            String description = channel.description != null?channel.description!:"";
            String profileImageUrl = channel.profileImageUrl != null? channel.profileImageUrl!.path.substring(1): "https://i.imgur.com/6CsbDPj.png";
            String channelImageUrl = channel.channelImageUrl != null? channel.channelImageUrl!.path.substring(1): "https://i.imgur.com/Jbjo0lX.png";
            return Container(
                decoration: BoxDecoration(
                  image:  DecorationImage(
                    image:  NetworkImage(channelImageUrl),
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
                                        margin: const EdgeInsets.only(left: 3, right: 3, top: 20),
                                        height: MediaQuery.of(context).size.height*0.4,
                                        alignment: Alignment.center,
                                        decoration:  BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(channelImageUrl),
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
                                        channel.channelname,
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
                                      Text(
                                        description,
                                        style: const TextStyle(
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
                                            height: MediaQuery.of(context).size.height*0.10,
                                            width: MediaQuery.of(context).size.height*0.10,
                                            alignment: Alignment.topRight,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                image: NetworkImage(profileImageUrl),
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
                        ),
                        buildActionButtonsRow(context),
                      ],
                    ),


                  ),
                )
              /*

              */
            );
          } else {
            return Container(
                color: Colors.black,
                child: const Text("No active channels",
                  style: TextStyle(color: Colors.white),
                ),
            );
          }
            } else {
              return Container(
                  color: Colors.black,
                  child: Text("State: ${snapshot.connectionState}",
                    style: const TextStyle(color: Colors.white),
                  ),
              );
            }
            },
        );

  }
   ///Two FloatingActionButton buttons used fore navigating between different streaming channels
  Widget buildActionButtonsRow(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: FloatingActionButton(
              onPressed: () async {
                _loadNextChannel(context, -1);
              },
              child: const Icon(Icons.arrow_back_ios),
              foregroundColor: Colors.white,
              backgroundColor: Colors.black.withOpacity(0.15),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(),
          ),
          Expanded(
            child: FloatingActionButton(
              onPressed: () async {
                _loadNextChannel(context, 1);
              },
              child: const Icon(Icons.arrow_forward_ios),
              foregroundColor: Colors.white,
              backgroundColor: Colors.black.withOpacity(0.15),
            ),
          )
        ]
    );
  }

  // TODO Move these non-widget methods to a view-model
  ///Load next stream.
  _loadNextChannel(BuildContext context, int step) async {
    List onlineChannels = await context.read<MainVM>().dbClient.loadOnlineChannels();
    int index = _getIndex(onlineChannels, Prefs().storedData.getString("channelName").toString());
    context.read<StreamVM>().closeClient();
    context.read<NavVM>().goBack(context);
    if (onlineChannels.isNotEmpty && index != -1) {

      if (index + step < 0){
        _setPrefs(onlineChannels.length + step, context, onlineChannels);
      }else if(index + step < onlineChannels.length){
        _setPrefs(index + step, context, onlineChannels);
      }else{
        _setPrefs(0, context, onlineChannels);
      }
      context.read<StreamVM>().startup(context, null);
      context.read<NavVM>().pushView(constants.listenChannel);
    }
  }

  ///Set Prefs to join a new stream.
  _setPrefs(int index, BuildContext context, List dataList){
    context.read<MainVM>().setJoinPrefs(
      dataList[index].channelid,
      dataList[index].channelname,
      dataList[index].username,
    );
  }

  ///Return index of the current stream of all available streams.
  ///Returns -1 if stream of some reason is not on the list.
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
