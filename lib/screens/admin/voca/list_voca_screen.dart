
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:talk_ing/api/FirebaseVocabulary.dart';
import 'package:talk_ing/model/vocabulary.dart';
import 'package:talk_ing/reusable_widgets/custom_appbar.dart';
import 'package:talk_ing/reusable_widgets/show_message.dart';
import 'package:talk_ing/screens/admin/home/home.dart';
import 'package:talk_ing/screens/admin/voca/add_voca_screen.dart';
import 'package:talk_ing/screens/admin/voca/edit_voca_screen.dart';

import '../../../utils/color_util.dart';

class ListVocaScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ListVocaScreen();
  }
}

class _ListVocaScreen extends State<ListVocaScreen> {
  final Stream<QuerySnapshot> collectionVoca = FirebaseVocabulary.readVoca();
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar:  PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: CustomAppBar(onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HomeAdminScreen())
            );

          },title: "Danh sách từ vựng",)
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: bgColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddVocabularyScreen()),
          );
        },
        child: Icon(Icons.add),
      ),

      body: StreamBuilder(
        stream: collectionVoca,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ListView(
                children: snapshot.data!.docs.map((e) {
                  return Card(
                      child: Row(children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(e["urlImage"]),
                              ),
                              title: Text(e["vocabulary"],style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                            ),
                          ),
                        ),
                        // Spacer(),
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => EditVocabularyScreen(vocabulary : Vocabulary(
                                      uId: e.id,
                                      urlImage: e['urlImage'],
                                      urlAudio: e['urlAudio'],
                                      idTopic:  e['idTopic'],
                                      example: e['example'],
                                      voca: e['vocabulary']
                                    ))),
                                  );
                                },
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.yellow,
                                  size: 24.0,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: ()  {
                                  ShowMessage.showToast(context,() async{
                                    var response = await FirebaseVocabulary.deleteVoca(docId: e.id);
                                    if(response.code!=200){
                                      ShowMessage.showMessage(fToast, response.message.toString(), false);
                                      Navigator.of(context).pop();
                                    }else{
                                      ShowMessage.showMessage(fToast, response.message.toString(), true);
                                      Navigator.of(context).pop();
                                    }
                                  },'https://assets1.lottiefiles.com/packages/lf20_ntbhn8nr.json');
                                },
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.pink,
                                  size: 24.0,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),

                            ],
                          ),
                        )
                      ],
                      )
                  );
                }).toList(),
              ),
            );
          }

          return Container();
        },
      ),
    );
  }
}