// ignore_for_file: unnecessary_new

class UpdatedUserModel {
  String? status;
  UpdatedUser? updatedUser;

  UpdatedUserModel({this.status, this.updatedUser});

  UpdatedUserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    updatedUser = json['updatedUser'] != null
        ? new UpdatedUser.fromJson(json['updatedUser'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (updatedUser != null) {
      data['updatedUser'] = updatedUser!.toJson();
    }
    return data;
  }
}

class UpdatedUser {
  String? fullName;
  String? email;
  String? phone;
  String? profilePicture;

  UpdatedUser({this.fullName, this.email, this.phone, this.profilePicture});

  UpdatedUser.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    email = json['email'];
    phone = json['phone'];
    profilePicture = json['profilePicture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fullName'] = fullName;
    data['email'] = email;
    data['phone'] = phone;
    data['profilePicture'] = profilePicture;
    return data;
  }
}
