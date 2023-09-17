

class PostInfo{
  String? appId;
  String message;
  DateTime publishDate;
  List<dynamic> userLiked;
  String username;
  String? filename;
  String? mimeType;
  List<int> fileInBytes;
  List<CommentInfo> comments;

  PostInfo({
    this.appId,
    required this.message,
    required this.publishDate,
    required this.username,
    required this.userLiked,
    this.filename,
    this.mimeType,
    required this.fileInBytes,
    required this.comments,
  });

  factory PostInfo.fromJson(Map<String?, dynamic> jsonPost) {

    var comments = jsonPost['comments'];
    List<CommentInfo> commentsList = List.empty();
    if(comments != null) {
      commentsList = List<CommentInfo>.from(comments.map((c) => CommentInfo.fromJson(c)).toList());
    }
    var likes = jsonPost['userLiked'];

    return PostInfo(
      appId: jsonPost['appId']?? "" ,
      message: jsonPost['message'],
      publishDate: DateTime.parse(jsonPost['publishDate']),
      username: jsonPost['username'],
      userLiked: jsonPost['userLiked'] != null ? likes : [],
      filename: jsonPost['filename'] ?? "",
      mimeType: jsonPost['mimeType'] ?? "",
      fileInBytes: jsonPost['fileInBytes'] ?? "" != null ? [] : [],
      comments: jsonPost['comments'] != null ? commentsList : [],
    );
  }

}

class CommentInfo{
  String? uniqueId;
  String message;
  DateTime publishDate;
  String username;

  CommentInfo({
    this.uniqueId,
    required this.message,
    required this.publishDate,
    required this.username,
  });

  factory CommentInfo.fromJson(Map<String?, dynamic> json) {
    return CommentInfo(
      uniqueId: json['uniqueId']?? "" ,
      message: json['message'],
      publishDate: DateTime.parse(json['publishDate']),
      username: json['username'],
    );
  }


}