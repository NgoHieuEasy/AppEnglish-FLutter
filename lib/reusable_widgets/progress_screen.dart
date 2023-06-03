import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:talk_ing/screens/client/home/home_screen.dart';

class ProgressScreen extends StatefulWidget {
  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> with SingleTickerProviderStateMixin {

  late AnimationController animationController;
   double percentage =0;
  int randomNumber = 0;
  Random random = new Random();
  var arrayText = [
    'Hãy luyện tiếng anh trước gương',
    'Suy nghĩ bằng tiếng anh hằng ngày',
    'Chơi game liên quan tiếng anh',
    'Mỗi ngày dành 30 phút nghe tiếng anh',
    'Học từ vựng theo chủ đề',
    'Viết nhật kí bằng tiếng anh'
  ];
  var arrayImg = [
    'assets/background/anhEng.jpg',
    'assets/background/progress1.jpg',
    'assets/background/progress2.jpg',
    'assets/background/progress3.jpg',
    'assets/background/progress5.jpg',
    'assets/background/progress6.jpg',
  ];
  @override
  void initState() {

    // TODO: implement initState

    randomNumber = random.nextInt(arrayText.length);
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    );
    animationController.addListener(() {
      setState(() {

      });
    });
   animationController.repeat();
    autoNavigate();
    super.initState();
  }

  void autoNavigate() {
    Timer.periodic(Duration(seconds: 4), (timer) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    percentage = animationController.value * 100;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(arrayImg[randomNumber]),
                fit: BoxFit.cover
              )
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('${percentage.toStringAsFixed(0)}%',style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                  color: Colors.black
              ),),
              SizedBox(
                height: 15,
              ),
              Container(
                width: double.infinity,
                height: 15,
                padding: EdgeInsets.symmetric(horizontal:5.0),
                child: LiquidLinearProgressIndicator(
                  borderRadius: 20.0,
                  value: animationController.value,
                  valueColor: AlwaysStoppedAnimation(Color.fromRGBO(
                      255,
                      69,
                      0,
                      1
                  )),
                  direction: Axis.horizontal,
                  backgroundColor: Colors.grey[350],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text("Mẹo: ${arrayText[randomNumber]}",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.black
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ],
      )
      );
  }
}