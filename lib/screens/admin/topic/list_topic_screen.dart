import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:talk_ing/api/FirebaseTopic.dart';
import 'package:talk_ing/reusable_widgets/custom_appbar.dart';
import 'package:talk_ing/reusable_widgets/show_message.dart';
import 'package:talk_ing/screens/admin/home/home.dart';
import 'package:talk_ing/screens/admin/topic/add_topic_screen.dart';
import 'package:talk_ing/utils/color_util.dart';

class ListTopicSreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ListTopicSreen();
  }
}

class _ListTopicSreen extends State<ListTopicSreen> {
  final Stream<QuerySnapshot> collectionReference = FirebaseTopic.readTopic();
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    // if you want to use context from globally instead of content we need to pass navigatorKey.currentContext!
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

          },title: "Thêm chủ đề",)
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: bgColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTopicScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: collectionReference,
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
                              title: Text(e["name"]),
                            ),
                          ),
                        ),
                        // Spacer(),
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              InkWell(
                                onTap: ()  {
                                  ShowMessage.showToast(context,() async{
                                    var response = await FirebaseTopic.deleteTopic(docId: e.id);
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