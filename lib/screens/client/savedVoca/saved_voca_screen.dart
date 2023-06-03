import 'package:audioplayer/audioplayer.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:talk_ing/screens/client/home/components/side_menu.dart';
import 'package:talk_ing/screens/client/voca/pronounce_screen.dart';

class SavedVocabularyScreen extends StatefulWidget {
  const SavedVocabularyScreen({Key? key}) : super(key: key);

  @override
  State<SavedVocabularyScreen> createState() => _SavedVocabularyScreenState();
}

class _SavedVocabularyScreenState extends State<SavedVocabularyScreen> {
  var isListening = false;
  RxBool _isListening = false.obs;
  int count =0;
  bool isListeningIcon = true;
  RxBool isSpeaking = false.obs;
  AudioPlayer audioPlugin = AudioPlayer();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<dynamic> arrSound = [];


  late FToast fToast;
  final FlutterTts flutterTts = FlutterTts();
  RxString _textSpeech = " ".obs;
  late stt.SpeechToText _speech;
  String resMessage = '';
  RxBool saved = false.obs;


  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    _speech = stt.SpeechToText();
  }

  Future speak(String text) async{
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }

  void readCard(int number) {
    for(int i=0; i<arrSound.length;i++){
      audioPlugin.play('${arrSound[number]['url']}');
    }
  }

  void _handleCommand(String command) {
    if(command == "speak number one"){
      readCard(0);
    }else{
      print("i don't know");
    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: DraggableFab(
        child: Obx(
              () =>AvatarGlow(
            animate: _isListening.value,
            glowColor: Colors.pinkAccent,
            endRadius: 100,
            duration: Duration(milliseconds: 2000),
            repeatPauseDuration: Duration(milliseconds: 100),
            repeat: true,
            child: GestureDetector(
              onTapDown: (dl) async {
                if (!_isListening.value) {
                  var available = await _speech.initialize();
                  if (available) {
                    _isListening.value = true;
                    isSpeaking.value = true;
                    _textSpeech.value = 'Nói theo cách của bạn';
                    _speech.listen(onResult: (result) {
                      _textSpeech.value = result.recognizedWords;
                    });
                  }
                }
              },
              onTapUp: (dl) async {
                _isListening.value = false;
                isSpeaking.value = false;
                _handleCommand(_textSpeech.value);

                await _speech.stop();
              },
              child: CircleAvatar(
                backgroundColor: Colors.pinkAccent,
                radius: 35,
                child: Lottie.network("https://assets2.lottiefiles.com/packages/lf20_D2Bl7ZTvwe.json"),
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Color(0xFF363567),
      extendBodyBehindAppBar: true,
      appBar:AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: Builder(

          builder: (context){
            return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                }, icon: Icon(Icons.menu));
          },),

      ),
      drawer: SideMenu(),

      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection("Vocabulary")
                .where("value", isEqualTo: true)
                .snapshots(),

            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

              if (snapshot.hasData) {
                if(snapshot.hasError) {
                  return Text('Some thing wrong');
                }
                if(snapshot.connectionState== ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(),);
                }
                if(snapshot.hasData==false){
                  return Center(child: Text('không có dữ liệu'),);
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ListView(
                    children: snapshot.data!.docs.map((e) {
                      count = count++;
                      arrSound.add({
                        "id":count,
                        "url":e['urlAudio'],
                      });
                      return  Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 10,bottom: 10),
                          height: 130,
                          width: 300,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 1,
                                    color: Colors.grey,
                                    spreadRadius: 2
                                )
                              ],
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: CircleAvatar(

                                          radius: 40,
                                          backgroundImage: NetworkImage(e["urlImage"]),
                                        ),
                                      )),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${e['vocabulary']} (n) ',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color:Color(0xff00bcef)
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),

                                        Text(
                                          e['example'],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color:Color(0xffBBBBBC)
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child:GestureDetector(
                                      onTapDown: (dl) async{
                                        audioPlugin.play(e['urlAudio']);
                                      },
                                      onTapUp: (dl) async {
                                      },
                                      child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child:Icon(  Icons.volume_up ,color: Colors.black,)
                                      ),
                                    ),
                                  )
                                ],
                              ),

                              Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: (){
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context) => PronounceScreen(
                                                vocabulary:e['vocabulary'],
                                                urlAudio: e['urlAudio']
                                            ))
                                        );
                                      },
                                      child: Image.asset(
                                        'assets/speaking.png',
                                        width: 30.0,
                                        height: 30.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    e['value'] ?InkWell(
                                        onTap: (){
                                          FirebaseFirestore.instance.collection('Vocabulary').doc(e.id).update({
                                            'value':false,
                                          });
                                        },
                                        child:Image.asset(
                                          'assets/saved.png',
                                          width: 30.0,
                                          height: 30.0,
                                          fit: BoxFit.cover,
                                        )
                                    ):InkWell(
                                        onTap: () {
                                          FirebaseFirestore.instance.collection('Vocabulary').doc(e.id).update({
                                            'value':true,
                                          });
                                        },
                                        child:Image.asset(
                                          'assets/save.png',
                                          width: 30.0,
                                          height: 30.0,
                                          fit: BoxFit.cover,
                                        )
                                    )
                                  ],
                                ),
                              ),

                            ],
                          ),

                        ),
                      );
                    }).toList(),
                  ),
                );
              }
              return Container();
            },
          ),
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Obx(
                  ()=> Container(
                child: isSpeaking.value?Container(
                  width: double.infinity,
                  height: 100,
                  color: Colors.grey[300],
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(_textSpeech.value,style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),),
                  ),
                ):Container(),
              ),
            ),
          )

        ],
      ),

    );
  }
}
