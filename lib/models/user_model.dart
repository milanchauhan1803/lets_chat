class UserModel {
  String? uId;
  String? fullName;
  String? email;
  String? profilePic;

  UserModel({this.uId, this.fullName, this.email, this.profilePic});

  UserModel.fromMap(Map<String, dynamic> map) {
    uId = map["uId"];
    fullName = map["fullName"];
    email = map["email"];
    profilePic = map["profilePic"];
  }

  Map<String, dynamic> toMap() {
    return {
      "uId": uId,
      "fullName": fullName,
      "email": email,
      "profilePic": profilePic
    };
  }
}
