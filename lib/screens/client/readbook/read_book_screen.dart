

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:talk_ing/screens/client/readbook/select_book_screen.dart';

class ReadBookScreen extends StatefulWidget {
  const ReadBookScreen({Key? key}) : super(key: key);

  @override
  State<ReadBookScreen> createState() => _ReadBookScreenState();
}

class _ReadBookScreenState extends State<ReadBookScreen> {
  final assetsAudioPlayer = AssetsAudioPlayer();
  final controller = CarouselController();
  int _current = 0;
  String _urlImg="assets/book/1.png";

  @override
  void initState() {
    assetsAudioPlayer.open(
      Audio("assets/book/audio1.mp3"),
    );
  super.initState();
  }

  @override
  void dispose(){
   // audioPlugin.dispose();
    assetsAudioPlayer.stop();
    super.dispose();
  }

  List<String> urlImages = [
    'assets/book/1.png',
    'assets/book/2.png',
    'assets/book/3.png',
    'assets/book/4.png',
    'assets/book/5.png',
  ];
  List<String> urlVideos = [
    "assets/book/audio1.mp3",
    "assets/book/audio2.mp3",
    "assets/book/audio3.mp3",
    "assets/book/audio4.mp3",
    "assets/book/audio5.mp3"
  ];

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height*0.8;

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar:AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            color: Colors.black,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SelectBookScreen()),
              );
            },
            icon: Icon(Icons.arrow_back_outlined),
          ),
        ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  // height: currentHeight,
                  child:  CarouselSlider.builder(
                    carouselController: controller,
                    itemCount: urlImages.length,
                    options: CarouselOptions(
                        height: currentHeight,
                        enlargeCenterPage: true,
                        initialPage: 0,
                        viewportFraction: 1,
                        enlargeStrategy: CenterPageEnlargeStrategy.height,
                        onPageChanged: (index,reason) =>{
                          setState(()=>{
                            _current = index,
                            _urlImg=urlImages[index],
                            assetsAudioPlayer.open(
                              Audio(urlVideos[index]),
                            )
                          }),
                        }
                    ),
                    itemBuilder: (context,index,realIndex) {
                      final urlImage = urlImages[index];
                      return buildImage(urlImage,index);
                    },
                  ),
                ),
              ],
            ),
            Center(
              child: buildButons(),
            )

          ],
        )
      )
    );
  }

  Widget buildButons({bool strech = false}) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(100, 22, 44, 33),
          padding: EdgeInsets.symmetric(horizontal: 22,vertical: 22)
        ),
          onPressed: previous,
          child: Icon(Icons.arrow_back,size: 22,)
      ),
      // strech? Spacer(): SizedBox(width: 32,),
      ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(100, 22, 44, 33),
              padding: EdgeInsets.symmetric(horizontal: 22,vertical: 22)
          ),
          onPressed: next,
          child: Icon(Icons.arrow_forward,size: 22,)
      ),

    ],
  );


  Widget buildImage(String urlImage,int index) => Container(
    color: Colors.red,
    child: Image.asset(
      urlImage,
      fit: BoxFit.cover,
    ),
  );

  void next() => controller.nextPage(duration: Duration(milliseconds: 500));

  void previous() => controller.previousPage(duration: Duration(milliseconds: 500));

}
