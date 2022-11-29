import 'dart:core';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:cmt_projekt/model/query_model.dart';
import '../environment.dart';


/// Api for fetching and sending data from the database.
class DatabaseApi {
  /// A local stream for sending data such as logged in account to various parts of the application
  StreamController<QueryModel> streamController = StreamController<QueryModel>.broadcast();
  /// A local stream for sending a list of channels to various parts of the application
  StreamController<List<QueryModel>> channelController = StreamController<List<QueryModel>>.broadcast();


  /// Makes a HTTP Get request to the path on the server specified by [localServer]
  /// in environment.dart on port 5604.
  ///
  /// **Returns** [Future<dynamic>] that is a processed version of the response body,
  /// depending on the content-type header the returned value is String, a decoded
  /// JSON Map of type [Map<String, dynamic>] or null on a empty body.
  ///
  /// **Throws** [HttpReqException] when the HTTP status code is 400 or above
  /// (includes the 400-499 client errors and 500-599 server errors).
  ///
  /// **Throws** [TimeoutException] when no response has been received after 20 seconds
  ///
  /// **Throws** [_ClientSocketException] when a connection cannot be established to the server
  ///
  /// **Example usage:**
  /// ```Dart
  ///   final data;
  ///   try {
  ///       data = await DatabaseAPI.getRequest('/channel');
  ///     }
  ///       on HttpReqException catch(e){
  ///         print(e.message);
  ///     }
  ///       catch(e){
  ///         print(e);
  ///     }
  ///   return data;
  /// ```
  static dynamic getRequest(String path) async {
    final res = await http.get(Uri.http(localServer + ':5604', path), headers: {'Accept': 'application/json'})
        .timeout(const Duration(seconds: 20));
    if(res.statusCode >= 400){
      throw HttpReqException(res.statusCode.toString() + ' - ' + res.body, res);
    }

    if(res.headers['content-type']?.startsWith('application/json') ?? false){
      return jsonDecode(res.body);
    }

    return res.body.isEmpty ? null : res.body ;
  }

  /// Makes a HTTP Post request to the path on the server specified by [localServer]
  /// in environment.dart on port 5604.
  ///
  /// **Parameter** [body] is converted to JSON using jsonEncode and is sent to
  /// the server in the request body.
  ///
  /// **Returns** [Future<dynamic>] that is a processed version of the response body,
  /// depending on the content-type header the returned value is String, a decoded
  /// JSON Map of type [Map<String, dynamic>] or null on a empty body.
  ///
  /// **Throws** [HttpReqException] when the HTTP status code is 400 or above
  /// (includes the 400-499 client errors and 500-599 server errors).
  ///
  /// **Throws** [TimeoutException] when no response has been received after 20 seconds
  ///
  /// **Throws** [_ClientSocketException] when a connection cannot be established to the server
  ///
  /// **Example usage:**
  /// ```Dart
  ///   final data;
  ///   try {
  ///       data = await DatabaseAPI.postRequest(
  ///         '/account/register',
  ///         {
  ///          email: 'email@mail.com',
  ///           phone: '123456789',
  ///           password: 'password',
  ///           username: 'user'
  ///       );
  ///     }
  ///       on HttpReqException catch(e){
  ///         print(e.message);
  ///     }
  ///       catch(e){
  ///         print(e);
  ///     }
  ///   return data;
  /// ```
  static dynamic postRequest(String path, dynamic body) async {
    final res = await http.post(Uri.http(localServer + ':5604', path),
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
        body: jsonEncode(body))
        .timeout(const Duration(seconds: 20));
    if(res.statusCode >= 400){
      throw HttpReqException(res.statusCode.toString() + ' - ' + res.body, res);
    }

    if(res.headers['content-type']?.startsWith('application/json') ?? false){
      return jsonDecode(res.body);
    }

    return res.body.isEmpty ? null : res.body ;
  }

  /// Makes a HTTP Put request to the path on the server specified by [localServer]
  /// in environment.dart on port 5604.
  ///
  /// **Parameter** [body] is converted to JSON using jsonEncode and is sent to
  /// the server in the request body.
  ///
  /// **Returns** [Future<dynamic>] that is a processed version of the response body,
  /// depending on the content-type header the returned value is String, a decoded
  /// JSON Map of type [Map<String, dynamic>] or null on a empty body.
  ///
  /// **Throws** [HttpReqException] when the HTTP status code is 400 or above
  /// (includes the 400-499 client errors and 500-599 server errors).
  ///
  /// **Throws** [TimeoutException] when no response has been received after 20 seconds
  ///
  /// **Throws** [_ClientSocketException] when a connection cannot be established to the server
  ///
  /// **Example usage:**
  /// ```Dart
  ///   final data;
  ///   try {
  ///       data = await DatabaseAPI.postRequest(
  ///         '/account/register',
  ///         {
  ///          email: 'email@mail.com',
  ///           phone: '123456789',
  ///           password: 'password',
  ///           username: 'user'
  ///       );
  ///     }
  ///       on HttpReqException catch(e){
  ///         print(e.message);
  ///     }
  ///       catch(e){
  ///         print(e);
  ///     }
  ///   return data;
  /// ```
  static dynamic putRequest(String path, dynamic body) async {
    final res = await http.put(Uri.http(localServer + ':5604', path),
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
        body: jsonEncode(body))
        .timeout(const Duration(seconds: 20));
    if(res.statusCode >= 400){
      throw HttpReqException(res.statusCode.toString() + ' - ' + res.body, res);
    }

    if(res.headers['content-type']?.startsWith('application/json') ?? false){
      return jsonDecode(res.body);
    }

    return res.body.isEmpty ? null : res.body ;
  }

  /// Makes a HTTP Patch request to the path on the server specified by [localServer]
  /// in environment.dart on port 5604.
  ///
  /// **Parameter** [body] is converted to JSON using jsonEncode and is sent to
  /// the server in the request body.
  ///
  /// **Returns** [Future<dynamic>] that is a processed version of the response body,
  /// depending on the content-type header the returned value is String, a decoded
  /// JSON Map of type [Map<String, dynamic>] or null on a empty body.
  ///
  /// **Throws** [HttpReqException] when the HTTP status code is 400 or above
  /// (includes the 400-499 client errors and 500-599 server errors).
  ///
  /// **Throws** [TimeoutException] when no response has been received after 20 seconds
  ///
  /// **Throws** [_ClientSocketException] when a connection cannot be established to the server
  ///
  /// **Example usage:**
  /// ```Dart
  ///   final data;
  ///   try {
  ///       data = await DatabaseAPI.postRequest(
  ///         '/account/register',
  ///         {
  ///          email: 'email@mail.com',
  ///           phone: '123456789',
  ///           password: 'password',
  ///           username: 'user'
  ///       );
  ///     }
  ///       on HttpReqException catch(e){
  ///         print(e.message);
  ///     }
  ///       catch(e){
  ///         print(e);
  ///     }
  ///   return data;
  /// ```
  static dynamic patchRequest(String path, dynamic body) async {
    final res = await http.patch(Uri.http(localServer + ':5604', path),
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
        body: jsonEncode(body))
        .timeout(const Duration(seconds: 20));
    if(res.statusCode >= 400){
      throw HttpReqException(res.statusCode.toString() + ' - ' + res.body, res);
    }

    if(res.headers['content-type']?.startsWith('application/json') ?? false){
      return jsonDecode(res.body);
    }

    return res.body.isEmpty ? null : res.body ;
  }

  /// Makes a HTTP Delete request to the path on the server specified by [localServer]
  /// in environment.dart on port 5604.
  ///
  /// **Optional Parameter** [body] is converted to JSON using jsonEncode and is sent to
  /// the server in the request body, if it's null then no body is sent.
  ///
  /// **Returns** [Future<dynamic>] that is a processed version of the response body,
  /// depending on the content-type header the returned value is String, a decoded
  /// JSON Map of type [Map<String, dynamic>] or null on a empty body.
  ///
  /// **Throws** [HttpReqException] when the HTTP status code is 400 or above
  /// (includes the 400-499 client errors and 500-599 server errors).
  ///
  /// **Throws** [TimeoutException] when no response has been received after 20 seconds
  ///
  /// **Throws** [_ClientSocketException] when a connection cannot be established to the server
  ///
  /// **Example usage:**
  /// ```Dart
  ///   try {
  ///       await DatabaseAPI.deleteRequest(
  ///         '/channel',
  ///         {
  ///          uid: 'abcd-1234-efgh-5678'
  ///          }
  ///       );
  ///     }
  ///       on HttpReqException catch(e){
  ///         print(e.message);
  ///     }
  ///       catch(e){
  ///         print(e);
  ///     }
  /// ```
  static dynamic deleteRequest(String path, dynamic body) async {
    final res = await http.delete(Uri.http(localServer + ':5604', path),
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
        body: (body != null ? jsonEncode(body) : null))
        .timeout(const Duration(seconds: 20));
    if(res.statusCode >= 400){
      throw HttpReqException(res.statusCode.toString() + ' - ' + res.body, res);
    }

    if(res.headers['content-type']?.startsWith('application/json') ?? false){
      return jsonDecode(res.body);
    }

    return res.body.isEmpty ? null : res.body ;
  }

  /// Does a Get request to /channel and sends a [List<QueryModel>] to [channelController].
  ///
  /// **Returns** [Future<List<QueryModel>>] that is a list of channels available.
  ///
  /// **See Also** [getRequest]
  Future<List<QueryModel>> loadOnlineChannels() async{
    final data = (await getRequest('/channel')) as List<dynamic>;
    final List<QueryModel> r = [];

    for (var e in data) {
      r.add(QueryModel.fromJson(e));
    }

    channelController.add(r);

    return r;
  }

  /// Does a Post request based on the specified path and saves the result to the [streamController],
  ///
  /// **Returns** [Future<QueryModel>] that is a parsed version of the response body, usually is for account info.
  ///
  /// **See Also** [postRequest]
  Future<QueryModel> postAndSaveToStreamCtrl(String path, dynamic body) async{
    final data = QueryModel.fromJson(await postRequest(path, body));
    streamController.add(data);
    return data;
  }
}

/// Exception class that extends [HttpException], it also contains [statusCode] and response [body].
class HttpReqException extends HttpException {
  /// The HTTP status code from the request
  late final int statusCode;
  /// The HTTP response body when the exception was generated.
  late final String body;

  /// Creates a new Exception instance.
  ///
  /// **Param** [message] the exception message.
  ///
  /// **Param** [res] the [http.Response] object from a request done by the [http] class.
  /// [statusCode], [body] and [uri] is extracted from this.
  HttpReqException(String message, http.Response res) : super(message, uri: res.request?.url){
    statusCode = res.statusCode;
    body = res.body;
  }

}
