
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talk_ing/model/response.dart';

import '../model/user.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _CollectionUser = _firestore.collection('Users');


class FirebaseUser {
  // Signup User
  static Future<ResPonse> signUpUser(Users user) async {

    ResPonse response = ResPonse();
    DocumentReference documentReferencer =
    _CollectionUser.doc();

    Map<String, dynamic> data = <String, dynamic>{
      "username": user.username,
      "email": user.email,
      "password" : user.password,
      "newbie": true,
    };

    final isUsername = await _CollectionUser.where("username", isEqualTo: user.username).get();
    if((isUsername.docs.length > 0)) {
      response.code = 300;
      response.message = "Tài khoản đã tồn tại";
      return response;
    }else{
      var result = await documentReferencer
          .set(data)
          .whenComplete(() {
        response.code = 200;
        response.message = "Thành công";
      })
          .catchError((e) {
        response.code = 500;
        response.message = e;
      });

    }
    return response;
  }


  /// login teacher and student

  static Future<ResPonse> loginUser(Users user) async {
    late String id;
    final prefs = await SharedPreferences.getInstance();
    ResPonse response = ResPonse();

    final isUsername = await _CollectionUser.where("username", isEqualTo: user.username).get();
    final isPassword = await _CollectionUser.where("password", isEqualTo: user.password).get();

    isUsername.docs.forEach((element) {
      id = element.id;
    });

    if((isUsername.docs.length > 0) && (isPassword.docs.length > 0) && (id == "h4vXCsYYtVRjlGjWp6tD") ) {//admin
      response.code = 300;
      response.message = "Đăng nhập thành công";
      return response;
    }else if((isUsername.docs.length > 0) && (isPassword.docs.length > 0)){//user
      isUsername.docs.forEach((element) async {
        await prefs.setString('key_idUser', id);
      });
      response.code = 200;
      response.message = "Đăng nhập thành công";
      return response;
    }else{
      response.code = 500;
      response.message = "Tài khoản mật khẩu không chính xác";
      return response;
    }

  }

}