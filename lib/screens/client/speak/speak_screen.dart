import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:talk_ing/model/figure.dart';
import 'package:talk_ing/model/user.dart';
import 'package:talk_ing/reusable_widgets/show_message.dart';
import 'package:talk_ing/screens/client/speak/menu_speak_screen.dart';
import 'package:talk_ing/screens/client/speak/word_fail_screen.dart';
class SpeakScreen extends StatefulWidget {
  const SpeakScreen({Key? key}) : super(key: key);

  @override
  State<SpeakScreen> createState() => _SpeakScreenState();
}

class _SpeakScreenState extends State<SpeakScreen> {
  final FlutterTts flutterTts = FlutterTts();
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String arrText ="let's talk about our favorite I don't know what you say";
  String _textSpeech = "Ấn nút để bắt đầu";
  String storeSpeak = "";
  List<String> arraySpeak = [];
  List<String> arraySuccess = [];
  List<dynamic> arrayFail = [];
 // List<String> arrayTemp = [];
  late List<String> arrayTemp1;
  int countId = 0;
  double percentSuccess = 0;
  late int core;
  late String idFigure;
  late String idUser;



  @override
  void initState() {
    _speech = stt.SpeechToText();
    getIdUser();
    fetchRecords();
    super.initState();
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



  void speak() async{
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1);
    await flutterTts.speak(arrText);
  }

  double countPronounce() {
      // arraySpeak.join('') lấy ra những thằng nói
    // List<String
    if(arraySpeak.length < arrayTemp1.length ) {
      String str2 = arraySpeak.join(" ");
      arraySpeak.forEach((element) {
        if(arrText.contains(element)){
          arraySuccess.add(element);
          countId = countId + 1;
        }
          // else{
        //   for(var i = 0 ; i < arrayTemp1.length ; i ++){
        //     if(i == countId) {
        //       arrayFail.add(
        //           {
        //             "default":arrayTemp1[i],
        //             "fail":element,
        //
        //           }
        //       );
        //     }
        //   }
        //   //   arrayFail.add(element);
        //   countId = countId + 1;
        // }
      });

      for (var i = 0; i < arrayTemp1.length; i++) {
        if (str2.indexOf(arrayTemp1[i]) == -1) {
          arrayFail.add(
              {
                "default":arrayTemp1[i],
                "fail":"Chưa phát âm",

              }
          );
         // arrayFail.add(arrayTemp1[i]);
        }
      }
      percentSuccess = (arraySuccess.length / arrayTemp1.length)*100;
    }else{
      arraySpeak.forEach((element) {
        if(arrText.contains(element)){
          arraySuccess.add(element);
          countId = countId + 1;
        }else{
          for(var i = 0 ; i < arrayTemp1.length ; i ++){
            if(i == countId) {
              arrayFail.add(
                  {
                    "default":arrayTemp1[i],
                    "fail":element,

                  }
              );
            }
          }
          //   arrayFail.add(element);
          countId = countId + 1;
        }
      });
      percentSuccess = (arraySuccess.length / arrayTemp1.length)*100;
    }
    return percentSuccess;
  }

  void checkPercentPronou() {
    int totalPercent = countPronounce().toInt();
    int increaCore = core + 3;

    print(increaCore);
    if(totalPercent>=70) {
      ShowMessage.showToastClient(context, () {
        arraySpeak = [];
        arraySuccess = [];
        arrayTemp1= [];
        percentSuccess = 0;

        FirebaseFirestore.instance.collection('Figure').doc(idFigure).update({
          'core':increaCore,
        });

        Navigator.of(context).pop();
      }, "https://assets1.lottiefiles.com/packages/lf20_l4xxtfd3.json",
          "Bạn phát âm đúng ${totalPercent.toString()}% nhận 3 sao ", true);
    }else{
      arraySpeak = [];
      arraySuccess = [];
      arrayTemp1= [];
      percentSuccess = 0;
      ShowMessage.showToastClient(context, () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WordFailScreen(arrayWord: arrayFail)),
        );
      }, "https://assets9.lottiefiles.com/packages/lf20_pojzngga.json",
          "Bạn phát âm đúng ${totalPercent.toString()}% ", false);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        centerTitle: true,
        title: Text("Nói theo cách của bạn"),
        backgroundColor: Colors.pinkAccent.shade100,
        leading: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MenuSpeakScreen())
            );
          },
          icon: Icon(Icons.arrow_back_outlined),
        ),
      ),

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
                      storeSpeak=_textSpeech;
                    });
                  });
                });
              }
            }
          },
          onTapUp: (dl) async {
            List<String> arrayTemp = [];
            arrayTemp1 = [];
            arrayTemp = storeSpeak.split(" ");
            arrayTemp1 = arrText.split(" ");
            setState(() {
              _isListening = false;
            });
            if(arrayTemp.length <= arrayTemp1.length ) {
              arraySpeak = storeSpeak.split(" ");
            }else{
              arrayTemp.length= arrayTemp1.length;
              arraySpeak = arrayTemp;
            }
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

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(height: 20,),
              Column(
                children: [
                  Text(arrText,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 50,
                    child: InkWell(
                      onTap:() => speak(),
                      child:  Lottie.network("https://assets2.lottiefiles.com/packages/lf20_cg0ullm9.json"),
                    ),
                  ),

                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16.0),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      String str2 = arraySpeak.join(" ");

                        for (var i = 0; i < arrayTemp1.length; i++) {
                          if (str2.indexOf(arrayTemp1[i]) == -1) {
                            arrayFail.add(
                                {
                                  "default":arrayTemp1[i],
                                  "fail":"Chưa phát âm",
                                }
                            );
                           // arrayFail.add(arrayTemp1[i]);
                          }
                        }
                    },
                    child: const Text('Ấn vô mà xemmmmm',style: TextStyle(color: Colors.black),),
                  ),

                ],
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                  child:Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xff7c94b6),
                      border: Border.all(
                        width: 8,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(14.0),
                        topRight: Radius.circular(14.0),),
                    ),

                    child: Text(_textSpeech,style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w500
                    ),),
                  ) )
            ],
          ),
        ),
      ),
    );
  }
}
