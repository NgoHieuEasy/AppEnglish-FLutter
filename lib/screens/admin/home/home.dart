
import 'package:flutter/material.dart';
import 'package:talk_ing/screens/admin/topic/list_topic_screen.dart';
import 'package:talk_ing/screens/admin/voca/list_voca_screen.dart';
import 'package:talk_ing/screens/client/login/signin_screen.dart';


class HomeAdminScreen extends StatefulWidget {
  const HomeAdminScreen({Key? key}) : super(key: key);

  @override
  State<HomeAdminScreen> createState() => _HomeAdminScreenState();
}

class _HomeAdminScreenState extends State<HomeAdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF363567),
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
                      Text(
                        'Quản trị viên',
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
                        'Ứng dụng nói tiếng anh',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CatigoryW(
                                  image: 'assets/Icon1.png',
                                  text: 'Chủ đề từ vựng',
                                  color: Color(0xFF47B4FF),
                                  index: 0,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                CatigoryW(
                                  image: 'assets/Icon2.png',
                                  text: 'Thêm từ vựng',
                                  color: Color(0xFFA885FF),
                                  index: 1,
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CatigoryW(
                                  image: 'assets/Icon5.png',
                                  text: 'Hướng dẫn',
                                  color: Color(0xFF7DA4FF),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                CatigoryW(
                                  image: 'assets/Icon6.png',
                                  text: 'Đăng xuất',
                                  color: Color(0xFF43DC64),
                                  index: 5,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
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

class CatigoryW extends StatelessWidget {
  String image;
  String text;
  Color color;
  int? index;

  CatigoryW({required this.image, required this.text, required this.color, this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 170,
        width: 155,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color(0x9F3D416E),
        ),
        child: Column(
          children: [
            Image.asset(
              image,
              width: 120,
              height: 120,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              text,
              style: TextStyle(color: color, fontSize: 18),
            ),
          ],
        ),
      ),
      onTap: () {
        if (index == 0)  {

          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ListTopicSreen())
          );


        }
        if (index == 1) {

          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ListVocaScreen())
          );
        }
        if (index == 2) {
          //3.item
        }
        if (index == 5) {

          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SignInScreen())
          );
        }
        if (index == 4) {
          //5.item
        }

      },
    );
  }
}