import 'package:flutter/material.dart';
import 'package:talk_ing/reusable_widgets/reusable_widget.dart';
import 'package:talk_ing/screens/client/home/home_screen.dart';
import 'package:talk_ing/screens/client/settings/languages_screen.dart';
import 'package:talk_ing/screens/client/talk/talk_screen.dart';
import 'package:talk_ing/utils/color_util.dart';
class MenuSettingScreen extends StatefulWidget {
  const MenuSettingScreen({Key? key}) : super(key: key);

  @override
  State<MenuSettingScreen> createState() => _MenuSettingScreenState();
}

class _MenuSettingScreenState extends State<MenuSettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff654ea3),
      extendBodyBehindAppBar: true,
      appBar:AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
          icon: Icon(Icons.arrow_back_outlined),
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
                    children: [
                      vocabularyButton(context,getLanguages=="English"?"Languagesv":"Ngôn ngữ",() => {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => LanguagesScreen())
                        )
                      }),

                    ],

                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}