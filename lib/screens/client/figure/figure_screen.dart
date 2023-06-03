
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:talk_ing/api/FirebaseFigure.dart';
import 'package:talk_ing/model/figure.dart';
import 'package:talk_ing/reusable_widgets/progress_screen.dart';
import 'package:talk_ing/reusable_widgets/show_message.dart';
import 'package:talk_ing/screens/client/home/home_screen.dart';
import 'package:video_player/video_player.dart';

class FigureScreen extends StatefulWidget {
  @override
  _FigureScreenState createState() => _FigureScreenState();
}

class _FigureScreenState extends State<FigureScreen> {
  bool isLoading = false;
  int _current = 0;
  late VideoPlayerController  _controller;
  TextEditingController _usernameController = TextEditingController();
  String _urlVideoSelected = "assets/video/nhanvat1.mp4";
  ImagePicker picker = ImagePicker();
  late String _urlImg = "assets/nhanvat/nhanvat1.png";
  late String idUser;
  RxInt count = 0.obs;
  RxBool isShow = true.obs;
  late FToast fToast;

  var listText = [
    'Chào mọi người mình là Hiếu, người sáng lập ra ứng dụng tiếng anh này',
    'Đây là bước đầu tiên tạo nhân vật mà bạn yêu thích và hãy điền tên nhân vật',
    'Chúc bạn có một trải nghiệm tuyệt vời...'
  ];


  List<String> urlVideo = [
    'assets/video/nhanvat1.mp4',
    'assets/video/nhanvat2.mp4',
    'assets/video/nhanvat3.mp4',
    'assets/video/nhanvat4.mp4',
    'assets/video/nhanvat5.mp4',
    'assets/video/nhanvat6.mp4'
  ];


  List<String> urlImages = [
    'assets/nhanvat/nhanvat1.png',
    'assets/nhanvat/nhanvat2.png',
    'assets/nhanvat/nhanvat3.png',
    'assets/nhanvat/nhanvat4.png',
    'assets/nhanvat/nhanvat5.png',
    'assets/nhanvat/nhanvat6.png',
  ];
  // init State
  @override
  void initState() {
    fToast = FToast();
    fToast.init(context);
    runVideo();
    getIdUser();
    super.initState();
  }

  void runVideo() {
    for(var i = 0;i<urlVideo.length;i++){
      if(i == _current){
        _urlVideoSelected = urlVideo[i];
        _controller = VideoPlayerController.asset(urlVideo[i])
          ..initialize().then((_) {
            _controller.play();
            setState(() {});
          });
      }
    }

  }


  //Add figure
  Future<void> addFigure() async{
    final figure = Figure(
        urlImage:_urlImg,
        urlVideo:_urlVideoSelected,
        idUser: idUser,
        username: _usernameController.text
    );
    var response = await FirebaseFigure.addFigure(figure);
    // ỏ đay 200 thanh cong
    if (response.code == 300) {
      ShowMessage.showMessage(fToast, "Tên nhân vật đã tồn tại", false);
    } else if(response.code == 200){
      FirebaseFirestore.instance.collection('Users').doc(idUser).update({
        'newbie':false,
      });

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => HomeScreen())
      );
    }else{
      ShowMessage.showMessage(fToast, "Lỗi tạo tài khoản", false);
    }

  }

  void getIdUser() async {
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
      body: Stack(children: [
        VideoPlayer(_controller),
        Container(
          child:Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Chọn nhân vật",style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontSize: 17
                        ),),
                        SizedBox(
                          height: 17,
                        ),
                        CarouselSlider.builder(
                          itemCount: urlImages.length,
                          options: CarouselOptions(height: 150,
                              enlargeCenterPage: true,
                              enlargeStrategy: CenterPageEnlargeStrategy.height,
                              onPageChanged: (index,reason) =>{
                                setState(()=>{
                                  _current = index,
                                  _urlImg=urlImages[index],

                                  runVideo()
                                }),

                              }
                          ),
                          itemBuilder: (context,index,realIndex) {
                            final urlImage = urlImages[index];
                            return buildImage(urlImage,index);
                          },
                        ),

                        const SizedBox(
                          height: 25,
                        ),
                        buildIndicator()
                      ],
                    ),
                  )),

              Expanded(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  customTextField('Tên nhân vật',_usernameController),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  submitButton(),
                ],
              ))
            ],
          ),
        ),

     Obx(
          ()=>isShow.value ? Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter
                )
              ),
              child: Row(

                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 200,

                      child: Image(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/nhanvat/npc.png"),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("NPC",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                            color: Colors.yellowAccent,
                              shadows: [
                              Shadow(
                              color: Colors.black54,
                              offset: Offset(1,2)
                          )
                        ]
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),

                          Text(listText[count.value],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              shadows: [
                                Shadow(
                                  color: Colors.black54,
                                  offset: Offset(1,2)
                                )
                              ]
                            ),
                          )

                      ],
                    )),

                  Container(
                    margin: EdgeInsets.only(top: 30),
                    width: 70,
                    child:InkWell(
                      onTap: () {
                        if (count < listText.length - 1) {
                          count.value = count.value + 1;
                        } else {
                          isShow.value = false;
                        }
                      },
                      child: Image.asset("assets/nhanvat/continute.png"),
                    ),
                  )
                ],
              ),
            ),
          ):Container(),
        )



      ]),
    );
  }


  ElevatedButton submitButton() {
    return ElevatedButton(
      onPressed: () {

        if(_usernameController.text =='') {
          ShowMessage.showMessage(fToast, "Điền tên nhân vật đi nào", false);
        }else{
          if(_usernameController.text.length>12){
            ShowMessage.showMessage(fToast, "Tên nhân vật phải nhỏ hơn 12 ký tự", false);
          }else{
            addFigure();
          }
        }
      },
      style: ElevatedButton.styleFrom(
          fixedSize: const Size.fromHeight(42),
          backgroundColor: Colors.pinkAccent,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
      child: const Text('Đồng ý'),
    );
  }

  Widget customTextField(String params,TextEditingController controller) => TextField(
    controller:controller ,
      decoration: InputDecoration(
        label: Text(params,
          style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,

          ),
        ),
        filled: true,
        fillColor:Colors.white10,
        labelStyle: const TextStyle(color: Colors.black),
        focusedBorder: getBorder(),
        border: getBorder(),
        enabledBorder: getBorder(),
         errorBorder: getBorder(Colors.red),
        disabledBorder: getBorder(Colors.grey[50]!),
      ));

  OutlineInputBorder getBorder([Color color = Colors.pink]) =>
      OutlineInputBorder(
        borderSide: const BorderSide(color:Color(0x25252C43), width: 1),
       // borderRadius: BorderRadius.circular(16),
      );


  Widget buildImage(String urlImage,int index) => Container(
    margin: EdgeInsets.symmetric(horizontal: 12),
    // color: Colors.grey,
    child: Image.asset(
      urlImage,
      fit: BoxFit.cover,
    ),
  );

  Widget buildIndicator()=> AnimatedSmoothIndicator(
    activeIndex: _current,
    count: urlImages.length,
    effect: JumpingDotEffect(
      dotHeight: 15,
      dotWidth: 15,

    ),
  );

}
