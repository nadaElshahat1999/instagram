/// username : ""
/// email : ""
/// phone : ""
/// profileImageUrl : ""
/// userId : ""

class MyUser {
  MyUser({
      String? username, 
      String? email, 
      String? phone, 
      String? profileImageUrl, 
      String? userId,}){
    _username = username;
    _email = email;
    _phone = phone;
    _profileImageUrl = profileImageUrl;
    _userId = userId;
}

  MyUser.fromJson(dynamic json) {
    _username = json['username'];
    _email = json['email'];
    _phone = json['phone'];
    _profileImageUrl = json['profileImageUrl'];
    _userId = json['userId'];
  }
  String? _username;
  String? _email;
  String? _phone;
  String? _profileImageUrl;
  String? _userId;

  String? get username => _username;
  String? get email => _email;
  String? get phone => _phone;
  String? get profileImageUrl => _profileImageUrl;
  String? get userId => _userId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['username'] = _username;
    map['email'] = _email;
    map['phone'] = _phone;
    map['profileImageUrl'] = _profileImageUrl;
    map['userId'] = _userId;
    return map;
  }

}