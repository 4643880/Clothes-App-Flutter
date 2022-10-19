class User {
  int? user_id;
  String? user_name;
  String? user_email;
  String? user_password;

  User({
    this.user_id,
    this.user_name,
    this.user_email,
    this.user_password,
  });

  // User.fromJson(Map<String, dynamic> json) {
  //   user_id = json["user_id"] as int;
  //   user_name = json["user_name"] as String;
  //   user_email = json["user_email"] as String;
  //   user_password = json["user_password"] as String;
  // }

  factory User.fromJson(Map<String, dynamic> json) => User(
        user_id: int.parse(json["user_id"]),
        user_name: json["user_name"] as String,
        user_email: json["user_email"] as String,
        user_password: json["user_password"] as String,
      );

  Map<String, dynamic> toJson() => {
        'user_id': user_id.toString(),
        'user_name': user_name.toString(),
        'user_email': user_email.toString(),
        'user_password': user_password.toString()
      };
}
