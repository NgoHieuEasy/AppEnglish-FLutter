import 'dart:convert';

import 'package:alan_voice/alan_voice.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:talk_ing/api/FirebaseUser.dart';
import 'package:talk_ing/model/user.dart';
import 'package:talk_ing/reusable_widgets/show_message.dart';
import 'package:talk_ing/screens/admin/home/home.dart';
import 'package:talk_ing/screens/client/figure/figure_screen.dart';
import 'package:talk_ing/screens/client/home/home_screen.dart';
import 'package:talk_ing/screens/client/login/rest_password.dart';
import 'package:talk_ing/screens/client/login/signup_screen.dart';
import 'package:talk_ing/utils/color_util.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;


class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}
class FieldsState{
  String? email;
  String? password;
  int? code;
  String? error;

  FieldsState(this.email,this.password,this.error,this.code);
  Map<String,dynamic> toJson() =>{
    'email':email,
    'password':password,
    'code':code,
    'error': error
  };
}
class _SignInScreenState extends State<SignInScreen> {
  late String dataVoice = '';
  late bool isLoading = false;
  late String isValidEmail ='';
  late String isValidPass = '';
  bool _isListening = false;
  String _textSpeech = " ";
  String resMessage = '';
  late bool _newBie;
  late stt.SpeechToText _speech;
  final FlutterTts flutterTts = FlutterTts();
  final currentState = FieldsState("", "","",0);
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  late FToast fToast;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    _speech = stt.SpeechToText();
  }


  fetchRecords() async{
    var records = await FirebaseFirestore.instance.collection("Users")
    .where("username", isEqualTo: _usernameController.text)
        .get();
    mapRecords(records);

  }

  mapRecords(QuerySnapshot<Map<String,dynamic>> records) {
    records.docs.forEach((element) {
      if((element.get("username") == _usernameController.text) && (element.get("password") == _passwordController.text)) {
          _newBie = element.get("newbie");
      }
    });

  }


  void _handleCommand(String command) async{
    String compare = '';
    List<String> array = command.split(" ");
    array.removeLast();
    compare = array.join(" ");
    if(command == "go to home") {
      await signIn();
      speak(resMessage);
    }else if("my name is".indexOf(compare) == 0){
      List<String> arrName = command.split(" ");
      arrName.removeRange(0, arrName.length -1);
      String username = arrName.join(" ");
      username.toLowerCase();
      _usernameController.text = username.toString();
    }else if("my password is".indexOf(compare) == 0){
      List<String> arrPassword = command.split(" ");
      arrPassword.removeRange(0, arrPassword.length -1);
      String password = arrPassword.join(" ");
      password.toLowerCase();
      _passwordController.text = password.toString();
    }else{
      print("hông biếc nữa");
    }
  }


  void speak(String text) async{
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }


  Future signIn()  async {
    fetchRecords();
    final user = Users(username:_usernameController.text,password: _passwordController.text);
    final response = await FirebaseUser.loginUser(user);
    if(_passwordController.text =='' || _usernameController.text == ''){
      ShowMessage.showMessage(fToast, "Điền đầy đủ thông tin", false);
      currentState.code = 300;
      resMessage = "fill full the information";
    }else{
      if(response.code == 200) {
        currentState.code = 200;
        _newBie?Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FigureScreen()),
        ):
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        resMessage = "go to home right now";
      }else if(response.code == 300) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeAdminScreen()),
        );
      }else{
        currentState.code = 400;
        ShowMessage.showMessage(fToast, response.message.toString(),false);
        resMessage ="Incorrect account or password";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            hexStringColor("CB2B93"),
            hexStringColor("9546C4"),
            hexStringColor("5E61F4"),
          ],begin: Alignment.topCenter,end: Alignment.bottomCenter)
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
            20,
                10,
                20, 0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(bottom: 10),
                      child:_textSpeech==" "? SpinKitThreeInOut(
                        color: Colors.blue,
                        size: 30.0,
                      ):Text(_textSpeech,style: TextStyle(fontSize: 17,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      width: 170,
                      height: 170,
                      margin: EdgeInsets.only(top: 100),
                      child: Image(
                        image: AssetImage(
                            'assets/robot.png'
                        ),
                      ),
                    )
                  ],
                ),

               const SizedBox(
                  height: 30,
                ),
              TextField(
                controller: _usernameController,
                obscureText: false,
                enableSuggestions: true,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white.withOpacity(0.9)),
                onChanged: (text)  {
                  currentState.email= text;
                },

                decoration: InputDecoration(
                  prefixIcon:const Icon(
                    Icons.person,
                    color: Colors.white70,
                  ),
                  errorText:isValidEmail,
                  labelText: "Tên tài khoản...",
                  labelStyle: TextStyle(
                      color: Colors.white.withOpacity(0.9)
                  ),
                  filled: true,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  fillColor: Colors.white.withOpacity(0.3),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(width: 0,style:BorderStyle.none)
                  ),
                ),
                keyboardType: TextInputType.emailAddress
              ),
               const SizedBox(
                  height: 30,
                ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              enableSuggestions: false,
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white.withOpacity(0.9)),
                onChanged: (text) {
                  currentState.password= text;
                },
              decoration: InputDecoration(
                prefixIcon:const Icon(
                  Icons.verified_user,
                  color: Colors.white70,
                ),
                errorText:isValidPass,
                labelText: "Mật khẩu...",
                labelStyle: TextStyle(
                    color: Colors.white.withOpacity(0.9)
                ),
                filled: true,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                fillColor: Colors.white.withOpacity(0.3),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(width: 0,style:BorderStyle.none)
                ),
              ),
              keyboardType: TextInputType.visiblePassword

            ),
              const  SizedBox(
                  height: 8,
                ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(90)
                ),
                child: ElevatedButton(
                  onPressed: (){

                    signIn();
                  },
                  child: Text(
                    "Đăng nhập",
                    style: const TextStyle(
                        color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 16
                    ),
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith((states) {
                        if(states.contains(MaterialState.pressed)){
                          return Colors.black26;
                        }
                        return Colors.white;
                      }),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                      )
                  ),
                ),
              ),
               // firebaseButton(context, "Đăng nhập",signIn ),
                signUpOption(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Không có tài khoản?",
          style: TextStyle(color: Colors.white70),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context, 
              MaterialPageRoute(builder: (context) => SignUpScreen())
            );
          },
          child: const Text(
            "Đăng ký",
            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

}
