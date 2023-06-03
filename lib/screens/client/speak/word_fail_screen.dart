import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talk_ing/model/figure.dart';
import 'package:talk_ing/model/user.dart';
import 'package:talk_ing/reusable_widgets/show_message.dart';
import 'package:talk_ing/screens/client/speak/speak_screen.dart';
import 'package:talk_ing/utils/color_util.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class WordFailScreen extends StatefulWidget {
  List<dynamic> arrayWord;
   WordFailScreen({required this.arrayWord});

  @override
  State<WordFailScreen> createState() => _WordFailScreenState();
}

class _WordFailScreenState extends State<WordFailScreen> {
  int currentIndex = 0;
  bool _isListening = false;
  String _textSpeech = "Giữ microphone để phát âm";
  String _textDefault = '';
  int percentSuccess = 0;
  late PageController _controller;
  final FlutterTts flutterTts = FlutterTts();
  late stt.SpeechToText _speech;
  late String idFigure;
  late int core;
  late String idUser;


  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    _speech = stt.SpeechToText();
    getIdUser();
    fetchRecords();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  fetchRecords() async{
    var records = await FirebaseFirestore.instance.collection("Figure")
        .get();
    mapRecords(records);

  }

  mapRecords(QuerySnapshot<Map<String,dynamic>> records) {
    var _list = records.docs
        .map((item) =>  Figure(
        uId: item.id,
        username: item['username'],
        idUser: item['idUser'],
        core: item['core']
    )).toList();

    _list.forEach((element) {
      if(element.idUser == idUser){
        core = element.core!;
        idFigure=element.uId.toString();
      }
    });

  }


  void getIdUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    idUser = prefs.getString('key_idUser').toString();
  }


  /// ////////////
  void speak(String text) async{
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }

  void countPronounce(String textDefault) {
    if(_textSpeech.contains(textDefault)){
      percentSuccess = 100;
    }else{
      percentSuccess = 0;
    }
  }

  void checkPercentPronou() {
    if(percentSuccess == 100) {
      ShowMessage.showToastClient(context, () {
        percentSuccess = 0;
        FirebaseFirestore.instance.collection('Figure').doc(idFigure).update({
          'core':++core,
        });
        Navigator.of(context).pop();
      }, "https://assets1.lottiefiles.com/packages/lf20_l4xxtfd3.json",
          "Bạn phát âm đúng ${percentSuccess.toString()}% nhận 1 sao ", true);
    }else{
      percentSuccess = 0;
      ShowMessage.showToastClient(context, () {
        percentSuccess = 0;
        Navigator.of(context).pop();
      }, "https://assets9.lottiefiles.com/packages/lf20_pojzngga.json",
          "Bạn phát âm đúng ${percentSuccess.toString()}% ", false);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Colors.pinkAccent,
        endRadius: 80,
        duration: Duration(milliseconds: 2000),
        repeatPauseDuration: Duration(milliseconds: 100),
        repeat: true,
        child: GestureDetector(
          onTapDown: (dl) async {
            if (!_isListening) {
              var available = await _speech.initialize();
              if (available) {
                setState(() {
                  _isListening = true;
                  _speech.listen(onResult: (result) {
                    setState(() {
                      _textSpeech = result.recognizedWords;
                    });
                  });
                });
              }
            }
          },
          onTapUp: (dl) async {
            setState(() {
              _isListening = false;
            });

            countPronounce(_textDefault);
            checkPercentPronou();
            await _speech.stop();
          },
          child: CircleAvatar(
            backgroundColor: Colors.pinkAccent,
            radius: 35,
            child: Icon(
              _isListening ? Icons.mic : Icons.mic_none,
              color: Colors.white,
            ),
          ),
        ),
      ),

      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Container(
            height: 350,
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.arrayWord.length,
              onPageChanged: (int index) {
                _textSpeech = "Giữ microphone để phát âm";
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (_, i) {
                _textDefault = widget.arrayWord[i]['default'];
                return Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(_textSpeech,style: TextStyle(fontSize: 20,color: bgColor),),
                      SizedBox(height: 50,),
                      Text("Từ vựng : ", style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      )),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.arrayWord[i]['default'],
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: Colors.blueAccent
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                            height: 25,
                            width: 25,
                            child: InkWell(
                              onTap:() => speak(widget.arrayWord[i]['default']),
                              child:  Lottie.network("https://assets2.lottiefiles.com/packages/lf20_cg0ullm9.json"),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text("Bạn phát âm : ",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                     Text(
                        widget.arrayWord[i]['fail'],
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          TextButton(onPressed: () {
            print(_textDefault);
          }, child: Text("ấn xem")),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.arrayWord.length,
                    (index) => buildDot(index, context),
              ),
            ),
          ),
          Container(
            height: 60,
            margin: EdgeInsets.all(40),
            width: double.infinity,
            child: TextButton(
              child: Container(
                height: 40,
                width: 150,
                decoration: BoxDecoration(
                  color:bgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                      currentIndex == widget.arrayWord.length - 1 ? "Hoàn thành" : "Tiếp theo",style: TextStyle(
                    color: Colors.white
                  ),),
                ),
              ),
              onPressed: () {
                _textSpeech = "Giữ microphone để phát âm";
                if (currentIndex ==  widget.arrayWord.length - 1) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SpeakScreen(),
                    ),
                  );
                }
                _controller.nextPage(
                  duration: Duration(milliseconds: 100),
                  curve: Curves.bounceIn,
                );
              },

            ),
          )
        ],
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: currentIndex == index ? 25 : 10,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: bgColor,
      ),
    );
  }
}
