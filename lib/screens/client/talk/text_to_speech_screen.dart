
import 'package:flutter/material.dart';
import 'package:talk_ing/model/tts.dart';
class TTSpeechScreen extends StatelessWidget {
  const TTSpeechScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Text to Speech"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           TextField(
            controller: textController,
          ),
          ElevatedButton(
              onPressed: () {
                TextToSpeech.speak(textController.text);
              },
              child: const Text("Speak"))
        ],
      ),
    );
  }
}
