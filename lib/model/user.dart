class Users{
  String? uId;
  String? username;
  String? email;
  String? password;
  bool? newbie;
  int? core;

  Users({this.uId,this.username,this.email,this.password,this.core,this.newbie});

  factory Users.fromJson(Map<String, dynamic> json) =>Users(
    uId: json["uId"],
    username: json["username"],
    email: json["email"],
    password: json["password"],
    core: json['core'],
    newbie: json['newbie']
  );

  Map<String,dynamic> toJson() =>{
    "uId":uId,
    "username":username,
    "email":email,
    "password":password,
    "core":core,
    "newbie":newbie
  };


}