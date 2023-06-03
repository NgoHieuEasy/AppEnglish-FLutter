import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class BackgroundVideoWidget extends StatefulWidget {
  int? idImg;
   BackgroundVideoWidget({this.idImg});

  @override
  State<BackgroundVideoWidget> createState() => _BackgroundVideoWidgetState();
}

class _BackgroundVideoWidgetState extends State<BackgroundVideoWidget> {
  late final VideoPlayerController videoController;
  List<String> urlImages = [
    'assets/video/nhanvat1.mp4',
    'assets/video/nhanvat2.mp4',
    'assets/video/nhanvat3.mp4',
    'assets/video/nhanvat4.mp4',
    'assets/video/nhanvat5.mp4',
    'assets/video/nhanvat6.mp4'
  ];


  @override
  void initState() {
    runVideo();
    super.initState();
  }

  void runVideo() {
    for(var i=0;i<urlImages.length;i++){
      if(i==widget.idImg){

        videoController = VideoPlayerController.asset(urlImages[i])
          ..initialize().then((_) {
            videoController.play();
            videoController.setLooping(true);
          });
      }
    }
  }

  @override
  void dispose() {
    videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => VideoPlayer(videoController);
}