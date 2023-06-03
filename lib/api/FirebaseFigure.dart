import 'package:alan_voice/alan_voice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talk_ing/model/figure.dart';
import 'package:talk_ing/model/response.dart';
import 'package:talk_ing/model/vocabulary.dart';


final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _CollectionFigure = _firestore.collection('Figure');

class FirebaseFigure{
  // add
  static Future<ResPonse> addFigure(Figure figure) async {
    ResPonse response = ResPonse();
    DocumentReference documentReferencer =
    _CollectionFigure.doc();

    Map<String, dynamic> data = <String, dynamic>{
      "urlImage":figure.urlImage,
      "urlVideo":figure.urlVideo,
      "username":figure.username,
      "idUser":figure.idUser,
      "core":0
    };

    final isUsername = await _CollectionFigure.where("username", isEqualTo: figure.username).get();
    if((isUsername.docs.length > 0)) {
      response.code = 300;
      response.message = "Tài khoản đã tồn tại";
      return response;
    }else{

      var result = await documentReferencer
          .set(data)
          .whenComplete(() {
        response.code = 200;
        response.message = "Thêm thành công";

      })
          .catchError((e) {
        response.code = 500;
        response.message = e;
      });
    }

    return response;
  }


// // read
// static Stream<QuerySnapshot> readVoca() {
//   CollectionReference notesItemCollection =
//       _CollectionVoca;
//
//   return notesItemCollection.snapshots();
// }
//
//
// //delete
//
// static Future<ResPonse> deleteVoca({
//   required String docId,
// }) async {
//   ResPonse response = ResPonse();
//   DocumentReference documentReferencer =
//   _CollectionVoca.doc(docId);
//
//   await documentReferencer
//       .delete()
//       .whenComplete((){
//     response.code = 200;
//     response.message = "Xóa thành công";
//   })
//       .catchError((e) {
//     response.code = 500;
//     response.message = e;
//   });
//
//   return response;
// }
//
// //edit
// static Future<ResPonse> editVoca(Vocabulary voca) async {
//   ResPonse response = ResPonse();
//   DocumentReference documentReferencer =
//   _CollectionVoca.doc(voca.uId);
//
//   Map<String, dynamic> data = <String, dynamic>{
//     "vocabulary":voca.voca,
//     "example":voca.example,
//     "urlAudio":voca.urlAudio,
//     "urlImage":voca.urlImage,
//     "idTopic":voca.idTopic
//   };
//   await documentReferencer
//       .update(data)
//       .whenComplete(() {
//     response.code = 200;
//     response.message = "Cập nhật thành công";
//   })
//       .catchError((e) {
//     response.code = 500;
//     response.message = e;
//   });
//
//   return response;
//
// }


}

