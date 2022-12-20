import 'package:cmt_projekt/apis/database_api.dart';

import 'package:flutter/material.dart';

/// The AppModel holds all the variables and data that has relevance for the
/// entire application, or at least many parts of it.
/// It generally does not modify the data as this is supposed to be done by the
/// MainViewModel when it is needed to build the view/views.

class AppModel {

  /// Api for communicating with the database
  static final DatabaseApi _databaseAPI = DatabaseApi();
  /// Interface for communicating with the db server using [DatabaseApi] class.
  DatabaseApi get databaseApi => _databaseAPI;

  // App data constants
  /// Website title.
  final String title = 'Comment';
  /// Website subtitle.
  final String subTitle = 'Din moderna radioapp';


  /// For Categories with paired images list
  final categoryAndStandardImg = {
    'Rock':
    'https://images.unsplash.com/photo-1459305272254-33a7d593a851?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
    'Sport':
    'https://images.unsplash.com/photo-1448387473223-5c37445527e7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80',
    'Jazz':
    'https://images.unsplash.com/photo-1415201364774-f6f0bb35f28f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80,',
    'Pop':
    'https://images.unsplash.com/photo-1513151233558-d860c5398176?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
    'Tjööt':
    'https://images.unsplash.com/photo-1577563908411-5077b6dc7624?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80',
    'Livsstil':
    'https://images.unsplash.com/photo-1524863479829-916d8e77f114?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80',
    'Ekonomi':
    'https://images.unsplash.com/photo-1607863680198-23d4b2565df0?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80',
    'Hälsa':
    'https://images.unsplash.com/photo-1535914254981-b5012eebbd15?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80',
    'Träning':
    'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=871&q=80',
    'Relationer':
    'https://images.unsplash.com/photo-1579208570378-8c970854bc23?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=922&q=80'
  };

  //For Channelsettings used by [GoLiveSettings]
  /// channel name text field
  TextEditingController channelName = TextEditingController();
}
