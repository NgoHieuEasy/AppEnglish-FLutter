
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:talk_ing/model/response.dart';
import 'package:talk_ing/model/topic.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _CollectionTopic = _firestore.collection('Topic');
class FirebaseTopic {
  // add
  static Future<ResPonse> addTopic(Topic topic) async {

    ResPonse response = ResPonse();
    DocumentReference documentReferencer =
    _CollectionTopic.doc();

    Map<String, dynamic> data = <String, dynamic>{
      "name": topic.name,
    };
      var result = await documentReferencer
          .set(data)
          .whenComplete(() {
        response.code = 200;
        response.message = "Thành công";
      })
          .catchError((e) {
        response.code = 500;
        response.message = "Thất bại";
      });
    return response;
  }

  static Stream<QuerySnapshot> readTopic() {
    CollectionReference notesItemCollection =
        _CollectionTopic;

    return notesItemCollection.snapshots();
  }

  static Future<ResPonse> deleteTopic({
    required String docId,
  }) async {
    ResPonse response = ResPonse();
    DocumentReference documentReferencer =
    _CollectionTopic.doc(docId);

    await documentReferencer
        .delete()
        .whenComplete((){
      response.code = 200;
      response.message = "Xóa thành công";
    })
        .catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }


}