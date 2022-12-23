# Servers
These are the files that are run host servers that app connects to. `lib/enviorinment.dart` needs
to be defined for the servers to work.

## Files
### server.sql
A file that contains all the table definitions that shall be used on PostgresSql database. Needed for
the `database_server.dart` to work.

### database_server.dart
Starts a HTTP server on port 5604 and connects to the database as per the `environment.dart` config.
Tools such as [Insomnia](https://insomnia.rest/) and [Postman](https://www.postman.com/) can be used to test the HTTP API without the app.
Insomnia has tools for testing websockets as well as HTTP. To find the json formats that is used check 
the `toMap` or `toJson` methods in models to find the keys and data types. For debugging websockets
then after connecting send a JSON in StreamMessage format with the intent either `h` (host) or `j` (join stream).

### stream_server.dart
Starts a websocket server on port 5605 which handles connection for audio streams and routes the audio to listeners.

## Directories
### controllers
A folder used by the database server where all the handlers for the url paths are in the controllers.

### helpers
A folders with helper classes such as `database_queries.dart` which houses methods for interacting with the database.

## Additional dependant folders in lib
### api
The `api` folder is used by both both the server and the app such as `database_api.dart` and `stream_client.dart`.

### model
Some data classes are also used by the server such as `query_model.dart` and `radio_channel.dart`.
