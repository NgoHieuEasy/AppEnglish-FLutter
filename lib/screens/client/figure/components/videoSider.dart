import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class VideoSlider extends StatefulWidget {
   String videoUrl;

  VideoSlider({required this.videoUrl});

  @override
  _VideoSliderState createState() => _VideoSliderState();
}

class _VideoSliderState extends State<VideoSlider> {
  late VideoPlayerController  _controller;


  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoUrl)
      ..initialize().then((_) {
        _controller.play();

        setState(() {});
      });
   // _controller.setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.value.isInitialized) {
      return VideoPlayer(_controller);
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}