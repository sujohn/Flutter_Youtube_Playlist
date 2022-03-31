class Video {

  final String? id;
  final String? title;
  final String? thumbnailUrl;
  final String? channelTitle;

  Video({this.id, this.title, this.thumbnailUrl, this.channelTitle});

  factory Video.fromJSON(Map<String, dynamic> json) {
    return Video(
      id: json['resourceId']['videoId'],
      title: json['title'],
      thumbnailUrl: json['thumbnails']['high']['url'],
      channelTitle: json['channelTitle'],
    );
  }
}
