import 'package:flutter/material.dart';
import 'package:talk_ing/reusable_widgets/custom_appbar.dart';
import 'package:talk_ing/screens/client/home/home_screen.dart';
import 'package:talk_ing/screens/client/speak/speak_screen.dart';

class MenuSpeakScreen extends StatefulWidget {
  const MenuSpeakScreen({Key? key}) : super(key: key);

  @override
  State<MenuSpeakScreen> createState() => _MenuSpeakScreenState();
}

class _MenuSpeakScreenState extends State<MenuSpeakScreen> {
  final List<Map<String, dynamic>> gridMap = [
    {
      "title": "Likes and Dislikes",
      "images":
      "https://elllo.org/Assets/images/LVLB1-240/L1-02-NatTodd-Farorites.jpg",
    },
    {
      "title": "Colors",
      "images":"https://elllo.org/Assets/images/LVLB1-240/L1-04-MegTodd-Colors.jpg",
    },
    {
      "title": "Days of the Week",
      "images":"https://elllo.org/Assets/images/LVLB1-240/L1-05-MegTodd-Cities-Adjective.jpg"
    },
    {
      "title": "Languages",
      "images":"https://elllo.org/Assets/images/LVLB1-240/L1-07-AbidemiTodd-Languages.jpg"
    },
    {
      "title": "T-shirt and Colors.",
      "images":"https://elllo.org/Assets/images/LVLB1-240/L1-05-MegTodd-Cities-Adjective.jpg"
    },
    {
      "title": "Sentece Patterns",
      "images":"https://elllo.org/Assets/images/LVLB1-240/L1-08-NatTodd-Sentence-Patterns-Schedule.jpg"
    },
    {
      "title": "Subject Pronouns",
      "images":"https://elllo.org/Assets/images/LVLB1-240/L1-09-ShantelTodd-Celebrities-SubjectPronoun.jpg"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(

        centerTitle: true,
        title: Text("Lựa chọn của bạn"),
        backgroundColor: Colors.pinkAccent.shade100,
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
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
            mainAxisExtent: 172,
          ),
          itemCount: gridMap.length,
          itemBuilder: (_, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SpeakScreen()),
                );
              },
              child: AnimatedContainer(
                padding: EdgeInsets.only(bottom: 3,right: 3),
                decoration: BoxDecoration(
                  color:Colors.black12,
                  borderRadius: BorderRadius.circular(16),

                ),
                duration: const Duration(milliseconds: 100),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      16.0,
                    ),
                    color: Colors.pinkAccent.shade100,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16.0),
                          topRight: Radius.circular(16.0),
                        ),
                        child: Image.network(
                          "${gridMap.elementAt(index)['images']}",
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(
                          "${gridMap.elementAt(index)['title']}",
                          style: Theme.of(context).textTheme.subtitle1!.merge(
                            const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
