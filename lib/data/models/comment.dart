/// username : ""
/// userImageUrl : ""
/// userId : ""
/// comment : ""
/// commentId : ""
/// commentTime : ""

class Comment {
  Comment({
      String? username, 
      String? userImageUrl, 
      String? userId, 
      String? comment, 
      String? commentId, 
      String? commentTime,}){
    _username = username;
    _userImageUrl = userImageUrl;
    _userId = userId;
    _comment = comment;
    _commentId = commentId;
    _commentTime = commentTime;
}

  Comment.fromJson(dynamic json) {
    _username = json['username'];
    _userImageUrl = json['userImageUrl'];
    _userId = json['userId'];
    _comment = json['comment'];
    _commentId = json['commentId'];
    _commentTime = json['commentTime'];
  }
  String? _username;
  String? _userImageUrl;
  String? _userId;
  String? _comment;
  String? _commentId;
  String? _commentTime;

  String get username => _username ??'';
  String get userImageUrl => _userImageUrl ??'';
  String get userId => _userId ??'';
  String get comment => _comment ??'';
  String get commentId => _commentId ??'';
  String get commentTime => _commentTime ??'';

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['username'] = _username;
    map['userImageUrl'] = _userImageUrl;
    map['userId'] = _userId;
    map['comment'] = _comment;
    map['commentId'] = _commentId;
    map['commentTime'] = _commentTime;
    return map;
  }

}