import 'package:alfred/alfred.dart';

import 'package:cmt_projekt/constants.dart';

import 'controllers/channel.dart';
import 'controllers/channel_viewers.dart';
import 'helpers/database_queries.dart';
import 'controllers/account.dart';

late final DatabaseQueries db;

void main() async {
  db = DatabaseQueries();
  DatabaseServer();
}

class DatabaseServer {
  final server = Alfred();

  DatabaseServer(){
    initRoutes();

    server.listen(5604, '0.0.0.0')
        .then((s) =>
        logger.i('Database server served under http://${s.address.address}:${s.port} \n'
            '(0.0.0.0 means all ips are accepted, which includes localhost)'
        ));
  }

  initRoutes(){
    server.post("account/register", AccountController.register);
    server.post("account/login", AccountController.login);

    server.get("/channel", ChannelController.getChannels);
    server.post('/channel', ChannelController.addChannel);
    server.delete("/channel", ChannelController.makeOffline);

    server.post("/channel/viewers", ChannelViewersController.addViewer);
    server.delete("/channel/viewers", ChannelViewersController.deleteViewer);
    server.delete("/channel/viewers/all", ChannelViewersController.deleteAllViewers);
  }
}


