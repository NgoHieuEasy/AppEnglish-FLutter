class Figure{
  String? uId;
  String? idUser;
  String? username;
  String? urlImage;
  String? urlVideo;
  int? core;

  Figure({this.uId,this.idUser,this.urlImage,this.urlVideo,this.core,this.username});

  factory Figure.fromJson(Map<String, dynamic> json) =>Figure(
      uId: json["uId"],
      idUser: json["idUser"],
      username: json["username"],
      urlImage: json["urlImage"],
      urlVideo: json["urlVideo"],
      core: json["core"]
  );

  Map<String,dynamic> toJson() =>{
    "uId":uId,
    "idUser":idUser,
    "username":username,
    "urlImage":urlImage,
    "urlVideo":urlVideo,
    "core":core
  };


}