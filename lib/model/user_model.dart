class UserModel {
  final String? token;
  final UserData? user;

  UserModel({this.token, this.user});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      token: json['token'],
      user: json['user'] != null ? UserData.fromJson(json['user']) : null,
    );
  }
}

class UserData {
  final int? id;
  final String? name;
  final String? email;

  UserData({this.id, this.name, this.email});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(id: json['id'], name: json['name'], email: json['email']);
  }
}
