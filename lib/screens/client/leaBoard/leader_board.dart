import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:talk_ing/model/figure.dart';
import 'package:talk_ing/model/user.dart';
import 'package:talk_ing/screens/client/home/components/side_menu.dart';
import 'package:talk_ing/utils/color_util.dart';

class LeaderBoardScreen extends StatefulWidget {
  @override
  State<LeaderBoardScreen> createState() => _LeaderBoardScreenState();
}

class _LeaderBoardScreenState extends State<LeaderBoardScreen> {
  List<Figure> userItems = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late final arrayUser = [];
  late  var userFirst = [];
  late  var userSecond = [];
  late  var userThird = [];

  @override
  void initState() {
    fetchRecords();
    fetchTop3User();
    super.initState();
  }

  fetchRecords() async{
    var records = await FirebaseFirestore.instance.collection("Figure")
        .limit(10)
        .orderBy('core',descending: true)
        .get();
   mapRecords(records);

  }

  fetchTop3User() async{
    var records = await FirebaseFirestore.instance.collection("Figure")
        .limit(3)
        .orderBy('core',descending: true)
        .get();
    getFirstUser(records);
    getThirdUser(records);
    getSecondUser(records);
  }
////////////////////
  getFirstUser(QuerySnapshot<Map<String,dynamic>> records) {
    var _list = records.docs
        .map((item) =>  Figure(
        uId: item.id,
        urlImage: item['urlImage'],
        urlVideo: item['urlVideo'],
        username: item['username'],
        core: item['core']
    )).toList();
    setState(() {
      userFirst = _list;
      userFirst.removeRange(1,userFirst.length);

    });
  }

  getSecondUser(QuerySnapshot<Map<String,dynamic>> records) {
    var _list = records.docs
        .map((item) =>  Figure(
        uId: item.id,
        urlImage: item['urlImage'],
        urlVideo: item['urlVideo'],
        username: item['username'],
        core: item['core']
    )).toList();
    setState(() {
      userSecond = _list;
      userSecond.removeAt(0);
      userSecond.removeAt(userSecond.length-1);
    });
  }

  getThirdUser(QuerySnapshot<Map<String,dynamic>> records) {
    var _list = records.docs
        .map((item) =>  Figure(
        uId: item.id,
        urlImage: item['urlImage'],
        urlVideo: item['urlVideo'],
        username: item['username'],
        core: item['core']
    )).toList();
    setState(() {
      userThird = _list;
      userThird.removeRange(0,2);
    });
  }


  mapRecords(QuerySnapshot<Map<String,dynamic>> records) {
    var _list = records.docs
        .map((item) =>  Figure(
          uId: item.id,
          urlImage: item['urlImage'],
          urlVideo: item['urlVideo'],
          username: item['username'],
          core: item['core']
    )).toList();


    setState(() {
      userItems = _list;
      userItems.removeRange(0, 3);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: calculatorScreen,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      gradient: LinearGradient(colors: [
                        Colors.yellow.shade600,
                        Colors.orange,
                        Colors.red
                      ])),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: calculatorScreen),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child:Center(
                          child: Text(
                            'Bảng xếp hạng',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0),
                          ),
                        )
                      ),
                    ),
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 270,
                          child: ListView.builder(
                            itemCount: userSecond.length,
                            itemBuilder: (context, index) {
                              if(userSecond.length == 0){
                                return WinnerContainer(
                                  winnerName: "Chưa có",
                                  url: 'assets/iconPerson.png',
                                  rank: '2',
                                  core: "Chưa có",
                                  color: Colors.green,
                                );
                              }else{
                                return WinnerContainer(
                                  winnerName: userSecond[index].username,
                                  url: userSecond[index].urlImage,
                                  rank: '2',
                                  core: userSecond[index].core.toString(),
                                  color: Colors.green,
                                );
                              }
                            },
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 270,
                          child: ListView.builder(
                            itemCount: userFirst.length,
                            itemBuilder: (context, index) {
                              if(userFirst.length == 0){
                                return  WinnerContainer(
                                  isFirst: true,
                                  color: Colors.orange,
                                  winnerName:"Chưa có",
                                  core: "Chưa có",
                                );
                              }else{
                                return   WinnerContainer(
                                  isFirst: true,
                                  color: Colors.orange,
                                  winnerName:userFirst[index].username,
                                  url: userFirst[index].urlImage,
                                  core: userFirst[index].core.toString(),
                                );
                              }

                            },
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 270,
                          child: ListView.builder(
                            itemCount: userThird.length,
                            itemBuilder: (context, index) {
                              if(userThird.length == 0){
                                return  WinnerContainer(
                                  winnerName: "Chưa có",
                                  url: 'assets/iconPerson.png',
                                  rank: '3',
                                  core: "Chưa có",
                                  color: Colors.blue,
                                );
                              }else{
                                return  WinnerContainer(
                                  winnerName: userThird[index].username,
                                  url: userThird[index].urlImage,
                                  rank: '3',
                                  core: userThird[index].core.toString(),
                                  color: Colors.blue,
                                );
                              }

                            },
                          ),
                        ),
                      ),
                    ],
                ),

                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0)),
                      gradient: LinearGradient(colors: [
                        Colors.yellow.shade600,
                        Colors.orange,
                        Colors.red
                      ])),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      height: 300.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0)),
                          color: calculatorScreen),
                      child : ListView.builder(
                        itemCount: userItems.length,
                        itemBuilder: (context, index) {
                          if(userItems.length == 0){
                            return  Container(
                              child: Text("Chưa có ai xếp hạng"),
                            );
                          }else{
                            return  ContestantList(
                              url: userItems[index].urlImage,
                              name: userItems[index].username,
                              core: userItems[index].core.toString(),
                            );
                          }

                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WinnerContainer extends StatelessWidget {
  final bool isFirst;
  final Color? color;
  final String? winnerPosition;
  final String? url;
  final String? winnerName;
  final String? rank;
  final String? core;
  const WinnerContainer(
      {
        this.isFirst = false,
        this.color,
        this.winnerPosition,
        this.winnerName,
        this.rank,
        this.url,
        this.core
      });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 80.0),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.yellow.shade600,
                    Colors.orange,
                    Colors.red
                  ]),
                  border: Border.all(
                    color: Colors.amber, //kHintColor, so this should be changed?
                  ),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Container(
                    height: 150.0,
                    width: 100.0,
                    decoration: BoxDecoration(
                      color: calculatorScreen,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.0),
                          topRight: Radius.circular(40.0)),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Stack(
              children: [
                if (isFirst)
                  Lottie.network('https://assets6.lottiefiles.com/packages/lf20_rchL70.json'),
                Padding(
                  padding: const EdgeInsets.only(top: 50.0, left: 15.0),
                  child: ClipOval(
                    clipBehavior: Clip.antiAlias,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Colors.yellow.shade600,
                          Colors.orange,
                          Colors.red
                        ]),
                        border: Border.all(
                          color: Colors
                              .amber, //kHintColor, so this should be changed?
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: ClipOval(
                          clipBehavior: Clip.antiAlias,
                          child: Image.asset(
                            url!,
                            height: 70,
                            width: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 115.0, left: 45.0),
                  child: Container(
                    height: 20.0,
                    width: 20.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color ?? Colors.red,
                    ),
                    child: Center(
                        child: Text(
                          rank??'1',
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 150.0,
            child: Container(
              width: 100.0,
              child: Center(
                child: Column(
                  children: [
                    Text(
                      winnerName ?? 'Emma Aria',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      core ?? '',
                      style: TextStyle(
                        color: color ?? Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ContestantList extends StatelessWidget {
  final String? url;
  final String? name;
  final String? core;
  const ContestantList({ this.url, this.name, this.core});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 20.0, right: 20.0, bottom: 5.0, top: 10.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Colors.pink,
                Colors.red,
                Colors.yellow,

              ]
          ),
          borderRadius: BorderRadius.circular(15.0),),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            decoration: BoxDecoration(
              color: calculatorScreen,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ClipOval(
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(
                          url ?? 'assets/4.jpg',
                          height: 60.0,
                          width: 60.0,
                          fit: BoxFit.fill,
                        )),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name ?? 'Name',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        '@${name ?? 'Name'}',
                        style: TextStyle(color: Colors.white54, fontSize: 12.0),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        core ?? '1234',
                        style: TextStyle(color: Colors.white),
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}