// register_modal

class userRegisterModel {
  String? name;
  String? email;
  String? password;
  String? conformpassword;
  String? uid;

  userRegisterModel({this.name, this.email, this.password, this.conformpassword, this.uid});

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "password": password,
      "conformpassword": conformpassword,
      "uid": uid
    };
  }
}