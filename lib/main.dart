
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talk_ing/model/tts.dart';
import 'package:talk_ing/reusable_widgets/progress_screen.dart';
import 'package:talk_ing/screens/admin/home/home.dart';
import 'package:talk_ing/screens/admin/topic/add_topic_screen.dart';
import 'package:talk_ing/screens/admin/topic/list_topic_screen.dart';
import 'package:talk_ing/screens/admin/voca/add_voca_screen.dart';
import 'package:talk_ing/screens/admin/voca/list_voca_screen.dart';
import 'package:talk_ing/screens/client/TestScreen.dart';
import 'package:talk_ing/screens/client/figure/figure_screen.dart';
import 'package:talk_ing/screens/client/guide/guide_screen.dart';
import 'package:talk_ing/screens/client/home/home_screen.dart';
import 'package:talk_ing/screens/client/leaBoard/leader_board.dart';
import 'package:talk_ing/screens/client/login/gridview.dart';
import 'package:talk_ing/screens/client/login/signin_screen.dart';
import 'package:talk_ing/screens/client/quizz/quiz_screen.dart';
import 'package:talk_ing/screens/client/readbook/read_book_screen.dart';
import 'package:talk_ing/screens/client/readbook/select_book_screen.dart';
import 'package:talk_ing/screens/client/settings/languages_screen.dart';
import 'package:talk_ing/screens/client/speak/menu_speak_screen.dart';
import 'package:talk_ing/screens/client/speak/speak_screen.dart';
import 'package:talk_ing/screens/client/voca/select_voca_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  TextToSpeech.initTTS();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:QuizScreen(),
    );
  }
}

