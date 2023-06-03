import 'package:flutter/material.dart';
import 'package:alan_voice/alan_voice.dart';


class TalkScreen extends StatefulWidget {
  const TalkScreen({Key? key}) : super(key: key);
  @override
  State<TalkScreen> createState() => _TalkScreenState();
}

class _TalkScreenState extends State<TalkScreen> {
  var arrays = [
    {
      "sender": "say: what I can do here . please",
      "sendByMe": false,
    },

  ];
  void inputVoice() {
  }

  _TalkScreenState() {



  }

  void _handleCommand(Map<String,dynamic> data) {

  }
  Widget chatMessages() {
    return ListView.builder(
        itemCount: arrays.length,
        itemBuilder: (context, index) {
          return Container(
            child: Text("hêlooooo"),
          );
          // return MessageTile(
          //   message: snapshot.data.documents[index].data["message"]
          // );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Color(0xFFFD47DF),
              backgroundImage: AssetImage("assets/robot.png"),
              radius: 24,
            ),
            const SizedBox(
              width: 5,
            ),
            const Text('Alan')
          ],
        ),

        actions: <Widget>[
          IconButton(
              onPressed:() {

              } ,
              icon: const Icon(Icons.notifications),
          ),
        ],
        backgroundColor: Color(0xFFFD47DF),
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {

            },
          ),
        ),

      ),
      body: ListView.builder(
          itemCount: arrays.length,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.only(
                  top: 8, bottom: 8,
                  left: arrays[index]['sendByMe'] == true ?
                  0 : 10,
                  right: arrays[index]['sendByMe'] == false ? 10 : 0),
              alignment: arrays[index]['sendByMe'] == true ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin:
                arrays[index]['sendByMe'] == true ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
                padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
                decoration: BoxDecoration(
                    borderRadius: arrays[index]['sendByMe'] == true
                        ? BorderRadius.only(
                        topLeft: Radius.circular(23),
                        topRight: Radius.circular(23),
                        bottomLeft: Radius.circular(23))
                        : BorderRadius.only(
                        topLeft: Radius.circular(23),
                        topRight: Radius.circular(23),
                        bottomRight: Radius.circular(23)),
                    gradient: LinearGradient(
                      colors: arrays[index]['sendByMe'] == true
                          ? [const Color(0xffc471ed), const Color(0xfff64f59)]
                          : [const Color(0xffC0C0C0), const Color(0xffA9A9A9)],
                    )),
                child: Text(arrays[index]['sender'] as String,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'OverpassRegular',
                        fontWeight: FontWeight.w300)),
              ),
            );
            // return MessageTile(
            //   message: snapshot.data.documents[index].data["message"]
            // );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            arrays.add(
              {
                "sender": "test người nhận 2",
                "sendByMe": false,
              },
            );
          });

        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.navigation),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class MessageTile extends StatelessWidget {
  String message;
  bool sendByMe = false;

  MessageTile({required this.message, required this.sendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8, bottom: 8, left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin:
        sendByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sendByMe
                ? BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23))
                : BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
              colors: sendByMe
                  ? [const Color(0xff007EF4), const Color(0xff2A75BC)]
                  : [const Color(0x1AFFFFFF), const Color(0x1AFFFFFF)],
            )),
        child: Text(message,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'OverpassRegular',
                fontWeight: FontWeight.w300)),
      ),
    );
  }
}
