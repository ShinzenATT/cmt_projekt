import 'package:alfred/alfred.dart';

import 'package:cmt_projekt/constants.dart';

import 'controllers/channel.dart';
import 'controllers/channel_viewers.dart';
import 'helpers/database_queries.dart';
import 'controllers/account.dart';

/// A public instance of the Orm db helper which also establishes a db connection. Used by controllers.
late final DatabaseQueries db;

/// creates a connection to the db and starts the http server
void main() async {
  db = DatabaseQueries();
  DatabaseServer();
}

/// A class for handling server functions where it links controller methods with urls
/// and starts the server at port 5604.
class DatabaseServer {
  /// an instance of the http server framework which links urls to handler functions
  final server = Alfred();

  /// creates the routes adn starts the server at port 5604. **See Also** [initRoutes]
  DatabaseServer(){
    initRoutes();

    server.listen(5604, '0.0.0.0')
        .then((s) =>
        logger.i('Database server served under http://${s.address.address}:${s.port} \n'
            '(0.0.0.0 means all ips are accepted, which includes localhost)'
        ));
  }

  /// This function links url paths with handler functions using Alfred the HTTP framework.
  ///
  /// The handler functions may be defined in this method or supplied from a (controller) class
  /// as long as the methods follow the format, [(HttpRequest req, HttpResponse res) => dynamic].
  ///
  /// **Example of route definitions:**
  /// ```dart
  /// server.get('/', (req, res) => 'API is running!'):
  ///
  /// server.post('/account/register' (req, res) async {
  ///
  ///     // get creation info from client
  ///     final QueryModel body = QueryModel.fromJson(await req.bodyAsJsonMap);
  ///
  ///     // send to db and get info of new account
  ///     final Map<String, dynamic> data = await db.createAccount(
  ///                                  body.email!,
  ///                                  body.password!,
  ///                                  body.phone!,
  ///                                  body.username!
  ///                                );
  ///
  ///     return data; // do a JSON response to client with info of new account
  /// });
  ///
  /// // defines the method on a different class instead of main file
  /// server.delete("/channel", AccountController.makeOffline);
  /// ```
  initRoutes(){

    server.post("/account/register", AccountController.register);
    server.post("/account/login", AccountController.login);

    server.get("/channel", ChannelController.getChannels);
    server.post('/channel', ChannelController.addChannel);
    server.delete("/channel", ChannelController.makeOffline);

    server.post("/channel/viewers", ChannelViewersController.addViewer);
    server.delete("/channel/viewers", ChannelViewersController.deleteViewer);
    server.delete("/channel/viewers/all", ChannelViewersController.deleteAllViewers);

    // this should be last so it can list all urls properly
    server.get('/', (req, res) async => {
      'info': 'Here are the following urls available on the server',
      'routes': server.routes.map((e) => {'path': e.route, 'method': e.method.name}).toList()
    });
  }
}


