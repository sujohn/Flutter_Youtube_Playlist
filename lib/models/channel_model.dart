import 'package:youtube_playlist/models/video_model.dart';

class Channel {

  final String? id;
  final String? title;
  final String? profilePictureUrl;
  final String? subscriberCount;
  final String? videoCount;
  final String? uploadPlaylistId;
  List<Video>? videos;

  Channel({
    this.id,
    this.title,
    this.profilePictureUrl,
    this.subscriberCount,
    this.videoCount,
    this.uploadPlaylistId,
    this.videos,
  });

  factory Channel.fromJSON(Map<String, dynamic> json) {
    return Channel(
      id: json['id'],
      title: json['snippet']['title'],
      profilePictureUrl: json['snippet']['thumbnails']['default']['url'],
      subscriberCount: json['statistics']['subscriberCount'],
      videoCount: json['statistics']['videoCount'],
      uploadPlaylistId: json['contentDetails']['relatedPlaylists']['uploads'],
    );
  }
}