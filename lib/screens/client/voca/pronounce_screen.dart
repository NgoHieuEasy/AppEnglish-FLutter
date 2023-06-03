import 'package:audioplayer/audioplayer.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talk_ing/model/figure.dart';
import 'package:talk_ing/model/user.dart';
import 'package:talk_ing/model/vocabulary.dart';
import 'package:talk_ing/reusable_widgets/show_message.dart';
import 'package:talk_ing/screens/client/voca/vocabulary_screen.dart';
import 'package:talk_ing/utils/color_util.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class PronounceScreen extends StatefulWidget {
  String vocabulary;
  String urlAudio;
   PronounceScreen({required this.vocabulary,required this.urlAudio});

  @override
  State<PronounceScreen> createState() => _PronounceScreenState();
}

class _PronounceScreenState extends State<PronounceScreen> {
  int currentIndex = 0;
  RxBool _isListening = false.obs;
  RxString _textSpeech = "Chưa phát âm".obs;
  int percentSuccess = 0;
  AudioPlayer audioPlugin = AudioPlayer();
  late PageController _controller;
  final FlutterTts flutterTts = FlutterTts();
  late stt.SpeechToText _speech;
  late int core;
  late String idUser;
  late String idFigure;

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
      audioPlugin.play("https://www.freesoundslibrary.com/wp-content/uploads/2020/06/success-sound-effect.mp3");
      ShowMessage.showToastClient(context, () {
        percentSuccess = 0;
        FirebaseFirestore.instance.collection('Figure').doc(idFigure).update({
          'core':++core,
        });
        Navigator.of(context).pop();
      }, "https://assets1.lottiefiles.com/packages/lf20_l4xxtfd3.json",
          "Bạn phát âm đúng ${percentSuccess.toString()}% nhận 1 sao", true);
    }else{
      percentSuccess = 0;
      ShowMessage.showToastClient(context, () {
        percentSuccess = 0;
        Navigator.of(context).pop();
      }, "https://assets9.lottiefiles.com/packages/lf20_pojzngga.json",
          "Bạn phát âm đúng ${percentSuccess.toString()}%", false);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar:AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_outlined),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Obx(
        ()=> AvatarGlow(
          animate: _isListening.value,
          glowColor: Colors.pinkAccent,
          endRadius: 80,
          duration: Duration(milliseconds: 2000),
          repeatPauseDuration: Duration(milliseconds: 100),
          repeat: true,
          child: GestureDetector(
              onTapDown: (dl) async {
                if (!_isListening.value) {
                  var available = await _speech.initialize();
                  if (available) {
                      _isListening.value = true;
                      _speech.listen(onResult: (result) {
                          _textSpeech.value = result.recognizedWords;
                    });
                  }
                }
              },
              onTapUp: (dl) async {
                _isListening.value = false;
                countPronounce(widget.vocabulary);
                checkPercentPronou();
                await _speech.stop();
              },
              child: CircleAvatar(
                backgroundColor: Colors.pinkAccent,
                radius: 35,
                child: Icon(
                  _isListening.value ? Icons.mic : Icons.mic_none,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ),


      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                    widget.vocabulary,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Colors.blueAccent
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  GestureDetector(
                    onTapDown: (dl) async{
                      audioPlugin.play(widget.urlAudio);
                    },
                    onTapUp: (dl) async {
                    },
                    child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child:Icon(  Icons.volume_up ,color: Colors.black,)
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
              Obx(
                ()=> Text(
                  _textSpeech.value,
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
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
