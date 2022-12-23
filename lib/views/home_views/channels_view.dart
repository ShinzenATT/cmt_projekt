import 'package:cmt_projekt/models/channel_data_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:cmt_projekt/constants.dart' as constants;
import 'package:cmt_projekt/view_models/main_vm.dart';
import 'package:cmt_projekt/view_models/stream_vm.dart';
import '../../view_models/navigation_vm.dart';

/// The home page where the user sees a channel list of active streams
class ChannelsView extends StatefulWidget {
  /// A const constructor for [ChannelsView]
  const ChannelsView({Key? key}) : super(key: key);

  @override
  State<ChannelsView> createState() => _ChannelsViewState();
}

class _ChannelsViewState extends State<ChannelsView> {

  final _refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text(
          'Live just nu',
          style: TextStyle(fontSize: 20),
        ),
        buildStream(context),
      ],
    );
  }

  Widget buildStream(BuildContext context) {
    return StreamBuilder(
      stream:
      context.watch<MainVM>().dbClient.channelController.stream,
      initialData: 0,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

        MainVM mainVM = Provider.of<MainVM>(context);

        if (snapshot.connectionState == ConnectionState.waiting) {
          mainVM.updateChannels();
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Text("error");
          } else if (snapshot.hasData) {
            List<ChannelDataModel> channels = snapshot.data;
            Map<String, List<ChannelDataModel>> categories =
            mainVM.getCategoryNumber(channels);
            return Expanded(
              child: SmartRefresher(
                header: const ClassicHeader(
                  releaseText: "Släpp för att uppdatera",
                  refreshingText: "Uppdaterar radiokanaler",
                  completeText: 'Radiokanaler uppdaterade',
                  idleText: "Dra ner för att uppdatera radiokanaler",
                ),
                controller: _refreshController,
                onRefresh: () async {
                  mainVM.updateChannels();
                  _refreshController.refreshCompleted();
                },
                child: getChannelsContent(categories),
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

  Widget _horizontalListView(
      {required String image,
        required List<ChannelDataModel> channelList,
        required String categoryName}) {
    return SizedBox(
      height: 185,
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
                  image:
                  context.read<MainVM>().categoryImageList[categoryName]!,
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
        required ChannelDataModel channel,
        required BuildContext context}) =>
      InkWell(
        onTap: () {
          context.read<MainVM>().setJoinPrefs(
            channel.channelid,
            channel.channelname,
            channel.username,
          );
          context.read<StreamVM>().startup(context, null);
          context.read<NavVM>().pushView(constants.listenChannel);
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
                    channel.channelname,
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
        ),
      );

  Widget getChannelsContent(Map<String, List<ChannelDataModel>> categories) {
    if (categories.isNotEmpty) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: categories.length,
          itemBuilder: (BuildContext context, int index) {
            return _horizontalListView(
                image: "ds",
                channelList: categories[categories.keys.elementAt(index)]!,
                categoryName: categories.keys.elementAt(index));
          });
    } else {
      return const Center(
          child: Text(
            "No active channels at the moment",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ));
    }
  }
}
