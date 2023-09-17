import 'dart:async';
import 'dart:convert';
import 'package:domus_buddies/pet/post_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;


import '../services/image_services.dart';

class AsMinhasPubliccoesService extends ChangeNotifier {
  List<PostInfo> feeds = List.empty();

  Future<void> fetchFeed(String authToken, String username) async {
    final Uri uri = Uri.parse('http://domusbuddies.eu:8083/api/v1/feed/$username');
    final Map<String, String> headers = {
      'Authorization': 'Bearer $authToken',
    };
    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        feeds = parseFeed(response.body);
        for(PostInfo postInfo in feeds){
          postInfo.fileInBytes =  await ImageServices().fetchImage(authToken, postInfo.filename) ?? List.empty();
          //print(postInfo.fileInBytes);
        }
        notifyListeners();
      } else {
        //print('Error fetching feed: ${response.statusCode}');
        //print('Error fetching feed: ${response.reasonPhrase}');
      }
    } catch (error) {
      //print('Error fetching feed: $error');
    }
  }

  List<PostInfo> parseFeed(String jsonString) {
    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed.map<PostInfo>((json) => PostInfo.fromJson(json)).toList();
  }

}