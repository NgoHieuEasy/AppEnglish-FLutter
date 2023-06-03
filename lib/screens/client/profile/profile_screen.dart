import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talk_ing/model/figure.dart';
import 'package:talk_ing/screens/client/home/components/side_menu.dart';
import 'package:video_player/video_player.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String idUser;
  late VideoPlayerController  _controller;
   String _urlVideoSelected = " ";
   String _urlImage = "";
   String _userName = "";
   int _core = 0;
  // init State
  @override
  void initState()  {
    allStep();
    // getIdUser();
    //  fetchRecords();
    // runVideo();
    super.initState();
  }

  Future<void> allStep ()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    idUser = prefs.getString('key_idUser').toString();

    var records = await FirebaseFirestore.instance.collection("Figure")
        .get();
    var _list = records.docs
        .map((item) =>  Figure(
        uId: item.id,
        username: item['username'],
        idUser: item['idUser'],
        urlVideo: item['urlVideo'],
        urlImage: item['urlImage'],
        core: item['core']
    )).toList();
    _list.forEach((element) {
      if(element.idUser == idUser){
        print("222222222222222222");
        _urlVideoSelected = element.urlVideo.toString();
        _urlImage = element.urlImage.toString();
        _userName = element.username.toString();
        _core = element.core!;
      }
    });


    _controller = VideoPlayerController.asset(_urlVideoSelected)
      ..initialize().then((_) {
        _controller.play();
        setState(() {});
      });


  }



  void runVideo() {
    print("33333333333333333333");
    _controller = VideoPlayerController.asset(_urlVideoSelected)
      ..initialize().then((_) {
        _controller.play();
        setState(() {});
      });
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
        urlVideo: item['urlVideo'],
        urlImage: item['urlImage'],
        core: item['core']
    )).toList();
    _list.forEach((element) {
      if(element.idUser == idUser){
        print("222222222222222222");
        _urlVideoSelected = element.urlVideo.toString();
        print(_urlVideoSelected);
      }
    });

  }
  void getIdUser() async {
    print("11111111");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    idUser = prefs.getString('key_idUser').toString();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Stack(children: [
        _urlVideoSelected == " "?Center(
          child: CircularProgressIndicator(),
        ):
        VideoPlayer(_controller),
        SizedBox(
          height: 20,
        ),
        _urlVideoSelected == " "?Container()
        :Container(
          margin: EdgeInsets.only(left: 10,right: 10,top: 60),
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter
              )
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      maxRadius: 40,
                      minRadius: 40,
                      backgroundColor: Colors.white10,
                      backgroundImage: AssetImage(_urlImage),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Tên nhân vật : ",style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        )),
                        DefaultTextStyle(
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontFamily: 'Agne',
                          ),
                          child: AnimatedTextKit(
                            animatedTexts: [
                              TypewriterAnimatedText(_userName,
                                  speed: Duration(milliseconds: 200)),
                            ],

                          ),
                        ),
                        // Text(_userName,style: TextStyle(
                        //   fontSize: 18,
                        //   fontWeight: FontWeight.bold,
                        //   color: Colors.white
                        // ),),
                        Text("Số sao : ",style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        )),
                        DefaultTextStyle(
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontFamily: 'Agne',
                          ),
                          child: AnimatedTextKit(
                            animatedTexts: [
                              TypewriterAnimatedText(_core.toString(),
                                  speed: Duration(milliseconds: 200)),
                            ],

                          ),
                        ),
                      ],
                    )


                  ],
                )
              ],
            ),
          ),
        ),
        
      ]),
    );
  }

}


