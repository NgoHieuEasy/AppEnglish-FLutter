import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:talk_ing/screens/client/guide/guide_screen.dart';
import 'package:talk_ing/screens/client/home/components/side_menu.dart';
import 'package:talk_ing/screens/client/quizz/quiz_screen.dart';
import 'package:talk_ing/screens/client/readbook/select_book_screen.dart';
import 'package:talk_ing/screens/client/speak/menu_speak_screen.dart';
import 'package:talk_ing/screens/client/talk/SpeedScreen.dart';
import 'package:talk_ing/screens/client/voca/select_voca_screen.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:talk_ing/utils/color_util.dart';
import 'package:get/get.dart';




class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isListening = false;
  late FToast fToast;
  final FlutterTts flutterTts = FlutterTts();
  String _textSpeech = " ";
  late stt.SpeechToText _speech;
  String resMessage = '';
  bool isSpeaking = false;
  bool isMessage = false;
  bool isColorGui = false;
  bool isLoading = false;
  bool isGui = true;


  @override
  void initState() {
    super.initState();
    DurationGui();
    fToast = FToast();
    fToast.init(context);
    isMessage = false;
    _speech = stt.SpeechToText();
  }



  Future DurationGui() async{
    await Future.delayed(Duration(seconds: 8));
    setState(() {
      isGui = false;
    });

  }

  void _handleCommand(String command) async{

    if(command == "what I can do here") {
      setState(() {
        resMessage = "This is application you can learn English,You can click here know detail";
        isMessage = true;
        isColorGui = true;
        speak(resMessage);
      });


    }else if(command == "go to vocabulary screen"){
      resMessage = "vocabulary screen here";
     await speak(resMessage);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => SelectvocaScreen())
      );

    }else if(command == "go to talk screen"){
      resMessage = "talk screen right here";
      speak(resMessage);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => SpeedScreen())
      );

    }else if(command == "go to speak screen"){
      resMessage = "speak screen here";
      speak(resMessage);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => MenuSpeakScreen())
      );

    } else{
      resMessage = "I don't understanding";
      speak(resMessage);
    }
  }

  Future speak(String text) async{
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      floatingActionButton: DraggableFab(
        child: AvatarGlow(
          animate: _isListening,
          glowColor: Colors.pinkAccent,
          endRadius: 100,
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
                    isSpeaking = true;
                    _textSpeech = 'Nói theo cách của bạn';
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
                isSpeaking = false;
              });

              _handleCommand(_textSpeech);

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Transform.rotate(
                  origin: Offset(30, -60),
                  angle: 2.4,
                  child: Container(
                    margin: EdgeInsets.only(
                      left: 75,
                      top: 40,
                    ),
                    height: 400,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(80),
                      gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        colors: [Color(0xffFD8BAB), Color(0xFFFD44C4)],
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 70),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      isMessage ? SizedBox(
                    width: double.infinity,
                    child: DefaultTextStyle(
                      style: const TextStyle(
                        fontSize: 21.0,
                        fontFamily: 'Agne',
                      ),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(resMessage,
                          speed: Duration(milliseconds: 100)),
                        ],
                        // onTap: () {
                        //   print("Tap Event");
                        // },
                      ),
                    ),
                  ):
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            getLanguages=='English'?'English speaking app':'Ứng dụng nói tiếng anh',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            getLanguages=='English'?"Don't give up \n while you still can":"Đừng bỏ cuộc \n khi bạn còn có thể",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [

                                CatigoryW(
                                  image: 'assets/menu/iconVoca.png',
                                  text:  getLanguages=='English'?'3000 vocabulary':'3000 từ vựng',
                                  color: Colors.lightBlueAccent,
                                  index: 0,
                                  isColor : false,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                CatigoryW(
                                  image: 'assets/menu/iconRead.png',
                                  text: getLanguages=='English'?'Read Stories':'Đọc truyện',
                                  color: Colors.lightBlueAccent,
                                  index: 1,
                                  isColor : false,
                                )
                            ]
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [

                                CatigoryW(
                                  image: 'assets/menu/iconMic.png',
                                  text:getLanguages =='English'?'Practice speaking':'Luyện nói',
                                  color: Colors.lightBlueAccent,
                                  index: 2,
                                  isColor : false,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                CatigoryW(
                                  image: 'assets/menu/iconTalk.png',
                                  text:getLanguages =='English'?'Talking':'Nói chuyện',
                                  color: Colors.lightBlueAccent,
                                  index: 3,
                                  isColor : false,
                                )
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CatigoryW(
                                  image: 'assets/menu/iconRead.png',
                                  text: 'Thử thách',
                                  color: Colors.lightBlueAccent,
                                  index: 4,
                                  isColor : false,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                isColorGui?
                                CatigoryW(
                                    image: 'assets/menu/iconGui.png',
                                    text:getLanguages =='Enlgish'?'Guide':'Hướng dẫn',
                                    color: Colors.white,
                                    index: 5,
                                  isColor: true,
                                  ) :
                                CatigoryW(
                                  image: 'assets/menu/iconGui.png',
                                  text:getLanguages =='English'?'Guide':'Hướng dẫn',
                                  color: Colors.lightBlueAccent,
                                  index: 5,
                                  isColor : false,
                                ),

                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),


                isSpeaking?Positioned(
                  bottom: 80,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: double.infinity,
                    height: 100,
                    color: Colors.white24,
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(_textSpeech,style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),),
                    ),
                  ),
                ):Container(),

                isGui ? Positioned(
                  bottom: 80,
                    left: 0,
                    right: 100,
                    child: Container(
                      padding: EdgeInsets.only(
                          top: 8, bottom: 8,
                          left:  10,
                          right: 10 ),
                      alignment: Alignment.centerRight ,
                      child: Container(
                        padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(23),
                                topRight: Radius.circular(23),
                                bottomRight: Radius.circular(23)),
                            gradient: LinearGradient(
                              colors: [const Color(0xffC0C0C0), const Color(0xffA9A9A9)],
                            )),
                        child:  DefaultTextStyle(
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'Agne',
                          ),
                          child: AnimatedTextKit(
                            animatedTexts: [
                              TypewriterAnimatedText("Say : What I can do here",
                                  speed: Duration(milliseconds: 100)),
                            ],

                          ),
                        ),
                      ),
                    )
                ):Container()
              ],
            ),
          ],
        ),
      ),
    );
  }
  }


class CatigoryW extends StatefulWidget {
  String image;
  String text;
  Color color;
  int? index;
  bool isColor;

  CatigoryW({required this.image, required this.text, required this.color, this.index,required this.isColor});

  @override
  State<CatigoryW> createState() => _CatigoryWState();
}

class _CatigoryWState extends State<CatigoryW> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AnimatedContainer(
        padding: EdgeInsets.only(bottom: 3,right: 3,left: 3),
        decoration: BoxDecoration(
          color:Colors.black12,
          borderRadius: BorderRadius.circular(15),

        ),
        duration: const Duration(milliseconds: 100),
        child: Container(
          height: 150,
          width: 145,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: widget.isColor ?Colors.pinkAccent: Color(0x9F3D416E),
          ),
          child: Column(
            children: [
              Image.asset(
                widget.image,
                width: 80,
                height: 80,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                widget.text,
                style: TextStyle(color: widget.color, fontSize: 18,fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
      onTap: () async{
        if (widget.index == 0)  {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SelectvocaScreen())
          );

        }
        if (widget.index == 1) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SelectBookScreen())
          );
        }
        if (widget.index == 2) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => MenuSpeakScreen())
          );

        }
        if (widget.index == 3) {

          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SpeedScreen())
          );
        }
        if (widget.index == 4) {
          print('hướng dẫn viên');
          Get.to(QuizScreen());
        }
        if (widget.index == 5) {

          Navigator.push(context,
              MaterialPageRoute(builder: (context) => GuideScreen())
          );
        }
      },
    );
  }
}




class NavigatorDrawer extends StatelessWidget {
  const NavigatorDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Drawer();
}













