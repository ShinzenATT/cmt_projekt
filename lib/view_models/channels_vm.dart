import '../apis/database_api.dart';
import '../models/query_model.dart';

class ChannelsVM {

  ///Api for communicating with the database
  final DatabaseApi _databaseAPI = DatabaseApi();

  List<QueryModel> _channels = [];

  Future<List<QueryModel>> updateChannels() async {
    _channels = await _databaseAPI.loadOnlineChannels();
    return getChannels();
  }

  List<QueryModel> getChannels() { return _channels; }

  /*
  bool streamConnected = false;
  bool streamError = false;

  Future<void> buildStream() async {

    StreamBuilder(
      stream: _databaseAPI.channelController.stream,
      initialData: 0,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          streamConnected = false;
          _databaseAPI.loadOnlineChannels();
        } else if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.done) {
          streamConnected = true;
          if (snapshot.hasError) {
            return const Text("error");
          } else if (snapshot.hasData) {
            List<QueryModel> channels = snapshot.data;
            Map<String, List<QueryModel>> categories =
            context.read<MainVM>().getCategoryNumber(channels);
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
                  context.read<MainVM>().updateChannels();
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
    )
  }

   */

}