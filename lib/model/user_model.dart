class UserModel {
  String? status;
  String? message;
  User? user;

  UserModel({this.status, this.message, this.user});

  UserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  String? id;
  String? fullName;
  String? email;
  String? phone;
  String? profilePicture;
  String? role;

  User(
      {this.id,
      this.fullName,
      this.email,
      this.phone,
      this.profilePicture,
      this.role});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    email = json['email'];
    phone = json['phone'];
    profilePicture = json['profilePicture'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fullName'] = fullName;
    data['email'] = email;
    data['phone'] = phone;
    data['profilePicture'] = profilePicture;
    data['role'] = role;
    return data;
  }
}
