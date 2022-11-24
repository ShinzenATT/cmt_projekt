import 'dart:core';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:cmt_projekt/model/query_model.dart';
import '../environment.dart';


/// Api for fetching and sending data from the database.
class DatabaseApi {
  //static final DatabaseApi _databaseApi = DatabaseApi._internal();
  StreamController<QueryModel> streamController = StreamController<QueryModel>.broadcast();
  StreamController<List<QueryModel>> channelController = StreamController<List<QueryModel>>.broadcast();

  /*factory DatabaseApi() {
    return _databaseApi;
  }*/
  /*DatabaseApi._internal() {
    init();
    poller();
  }

  void init() {
    channel = WebSocketChannel.connect(Uri.parse('ws://' + localServer + ':5604'));
    channel.stream.listen((message) => onMessage(message));
  }

  void poller() async {
    while (true) {
      pollingBool = false;
      await Future.delayed(const Duration(seconds: 7), () {
        try {
          channel.sink.add(jsonEncode(QueryModel.polling()));
        } on WebSocketChannelException catch (e) {
          logger.e('Connection to server lost', [e]);
        }
        if (!pollingBool) {
          channel.sink.close();
          init();
          sendRequest(QueryModel.getChannels());
        }
      });
    }
  }*/


  dynamic getRequest(String path) async {
    final res = await http.get(Uri.http(localServer + ':5604', path), headers: {'Accept': 'application/json'})
        .timeout(const Duration(seconds: 40));
    if(res.statusCode >= 400){
      throw HttpReqException(res.statusCode.toString() + ' - ' + res.body, res);
    }

    if(res.headers['content-type']?.startsWith('application/json') ?? false){
      return jsonDecode(res.body);
    }

    return res.body.isEmpty ? null : res.body ;
  }

  dynamic postRequest(String path, dynamic body) async {
    final res = await http.post(Uri.http(localServer + ':5604', path),
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
        body: jsonEncode(body))
        .timeout(const Duration(seconds: 40));
    if(res.statusCode >= 400){
      throw HttpReqException(res.statusCode.toString() + ' - ' + res.body, res);
    }

    if(res.headers['content-type']?.startsWith('application/json') ?? false){
      return jsonDecode(res.body);
    }

    return res.body.isEmpty ? null : res.body ;
  }

  dynamic deleteRequest(String path, dynamic body) async {
    final res = await http.delete(Uri.http(localServer + ':5604', path),
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
        body: (body != null ? jsonEncode(body) : null))
        .timeout(const Duration(seconds: 40));
    if(res.statusCode >= 400){
      throw HttpReqException(res.statusCode.toString() + ' - ' + res.body, res);
    }

    if(res.headers['content-type']?.startsWith('application/json') ?? false){
      return jsonDecode(res.body);
    }

    return res.body.isEmpty ? null : res.body ;
  }

  Future<List<QueryModel>> loadOnlineChannels() async{
    final data = (await getRequest('/channel')) as List<dynamic>;
    final List<QueryModel> r = [];

    for (var e in data) {
      r.add(QueryModel.fromJson(e));
    }

    channelController.add(r);

    return r;
  }

  Future<QueryModel> postAndSaveToStreamCtrl(String path, dynamic body) async{
    final data = QueryModel.fromJson(await postRequest(path, body));
    streamController.add(data);
    return data;
  }

  ///Method that handles all incoming messages from the database server.
  /*void onMessage(String message) async {
    if (message == "") {
      return;
    }
    String queryCode = (jsonDecode(message)['code'] as List)[0];
    if (queryCode == dbGetInfo) {
      streamController
          .add(QueryModel.fromJson((jsonDecode(message)['result'] as List)[0]));
    } else if (queryCode == dbGetOnlineChannels) {
      List<QueryModel> listOfChannels = [];
      for (int i = 0; i < (jsonDecode(message)['result'] as List).length; i++) {
        listOfChannels.add(
            (QueryModel.fromJson((jsonDecode(message)['result'] as List)[i])));
      }
      channelController.add(listOfChannels);
    } else if (queryCode == dbPing) {
      pollingBool = true;
    }
  }*/
}

class HttpReqException extends HttpException {
  late final int statusCode;
  late final String body;

  HttpReqException(String message, http.Response res) : super(message, uri: res.request?.url){
    statusCode = res.statusCode;
    body = res.body;
  }

}
