import 'dart:convert';
import 'dart:io';

import 'package:youtube_playlist/models/channel_model.dart';
import 'package:youtube_playlist/models/video_model.dart';
import 'package:youtube_playlist/utilities/keys.dart';
import 'package:http/http.dart' as http;

class APIService {

  APIService._instantiate();

  static final APIService instance = APIService._instantiate();

  final String _baseUrl = 'www.googleapis.com';
  String _nextPageToken = '';

  Future<Channel> fetchChannel({required String channelId}) async {

    Map<String, String> parameters = {
      'part': 'snippet, contentDetails, statistics',
      'id': channelId,
      'key': API_KEY,
    };

    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/channels',
      parameters,
    );

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {

      Map<String, dynamic> data = json.decode(response.body)['items'][0];
      Channel channel = Channel.fromJSON(data);

      channel.videos = await fetchVideosFromPlaylist(playlistId: channel.uploadPlaylistId ?? "");
      return channel;
    }
    else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  Future<List<Video>> fetchVideosFromPlaylist({required String playlistId}) async {
    
    Map<String, String> parameters = {
      'part': 'snippet',
      'playlistId': playlistId,
      'maxResults': '8',
      'pageToken': _nextPageToken,
      'key': API_KEY,
    };

    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/playlistItems',
      parameters,
    );

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {

      Map<String, dynamic> data = json.decode(response.body);
      _nextPageToken = data['nextPageToken'] ?? '';
      List<dynamic> videoJson = data['items'];

      List<Video> videos = [];
      videoJson.forEach(
        (json) => videos.add(
          Video.fromJSON(json['snippet']),
        ),
      );
      return videos;
    }
    else {
      throw json.decode(response.body)['error']['message'];
    }
  }
  
}