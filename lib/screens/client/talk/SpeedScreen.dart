import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:talk_ing/api/api_services.dart';
import 'package:talk_ing/model/chat_model.dart';
import 'package:talk_ing/model/tts.dart';
import 'package:talk_ing/screens/client/home/home_screen.dart';
import 'package:talk_ing/utils/color_util.dart';
import 'package:translator/translator.dart';

class SpeedScreen extends StatefulWidget {
  const SpeedScreen({Key? key}) : super(key: key);

  @override
  State<SpeedScreen> createState() => _SpeedScreenState();
}

class _SpeedScreenState extends State<SpeedScreen> {
  GoogleTranslator translator = GoogleTranslator();
  SpeechToText speechToText = SpeechToText();
  var text = "Giữ nút và nói";
  var isListening = false;
  var isTranslate = true;
  var scrollController = ScrollController();
  final List<ChatMessage> message = [];

  scrollMethod() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  @override
  void dispose(){
    scrollController.dispose();
    speechToText.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        endRadius: 75.0,
        animate: isListening,
        duration: Duration(milliseconds: 2000),
        glowColor: bgColor,
        repeat: true,
        repeatPauseDuration: Duration(milliseconds: 100),
        showTwoGlows: true,
        child: GestureDetector(
          onTapDown: (dl) async {
            if (!isListening) {
              var available = await speechToText.initialize();
              if (available) {
                setState(() {
                  isListening = true;
                  speechToText.listen(onResult: (result) {
                    setState(() {
                      text = result.recognizedWords;
                    });
                  });
                });
              }
            }
          },
          onTapUp: (dl) async {
            setState(() {
              isListening = false;
            });
            await speechToText.stop();

            if (text.isNotEmpty &&
                text != "Hold the button and start speaking") {
              message.add(ChatMessage(text: text, type: ChatMessageType.user));
              var msg = await ApiServices.sendMessage(text);
              msg = msg.trim();

              setState(() {
                message.add(ChatMessage(text: msg, type: ChatMessageType.bot));
              });
              Future.delayed(const Duration(milliseconds: 500), () {
                TextToSpeech.speak(msg);
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Failed to process. Try again!")));
            }
          },
          child: CircleAvatar(
            backgroundColor: Colors.lightBlueAccent,
            radius: 35,
            child: Icon(
              isListening ? Icons.mic : Icons.mic_none,
              color: Colors.white,
            ),
          ),
        ),
      ),
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HomeScreen())
            );

          },
          child: const Icon(
            Icons.keyboard_backspace_rounded,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFFF6DA7),
        elevation: 0.0,
        title: const Text(
          "Trò chuyện",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
      body: Column(
        children: [
          Text(
            text,
            style: TextStyle(
                color: isListening ? Colors.black87 : Colors.black54,
                fontWeight: FontWeight.w600,
                fontSize: 18),
          ),
          const SizedBox(
            height: 12,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                  color: chatBgColor, borderRadius: BorderRadius.circular(12)),
              child: ListView.builder(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: message.length,
                itemBuilder: (BuildContext context, int index) {
                  var chat = message[index];
                  return Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Color(0xFFFF6DA7),
                        child: chat.type == ChatMessageType.bot
                            ?Lottie.network("https://assets2.lottiefiles.com/packages/lf20_D2Bl7ZTvwe.json")
                            : Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: chat.type == ChatMessageType.bot
                                  ? bgColor
                                  : Colors.white,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                  bottomLeft: Radius.circular(12)),
                            ),
                            child: isTranslate? Column(
                              children: [
                                Text(
                                  "${chat.text}",
                                  style: TextStyle(
                                    color: chat.type == ChatMessageType.bot
                                        ? textColor
                                        : bgColor,
                                    fontSize: 15,
                                    fontWeight: chat.type == ChatMessageType.bot
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                ),
                                TextButton.icon(
                                  style: TextButton.styleFrom(
                                    primary:
                                    Colors.lightBlueAccent, // text + icon color
                                  ),
                                  icon: Icon(Icons.add, size: 15),
                                  label: Text('translate',
                                      style: TextStyle(fontSize: 13)),
                                  onPressed: () {
                                    translator
                                        .translate(chat.text.toString(),
                                            to: "vi")
                                        .then((value) {
                                      setState(() {
                                        chat.text = value.toString();
                                        isTranslate = false;
                                      });
                                    });
                                  },
                                ),
                              ],
                            ):  Column(
                              children: [
                                Text(
                                  "${chat.text}",
                                  style: TextStyle(
                                    color: chat.type == ChatMessageType.bot
                                        ? textColor
                                        : bgColor,
                                    fontSize: 15,
                                    fontWeight: chat.type == ChatMessageType.bot
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                ),
                                TextButton.icon(
                                  style: TextButton.styleFrom(
                                    primary:
                                    Colors.lightBlueAccent, // text + icon color
                                  ),
                                  icon: Icon(Icons.add, size: 15),
                                  label: Text('translate',
                                      style: TextStyle(fontSize: 16)),
                                  onPressed: () {
                                    translator
                                        .translate(chat.text.toString(),
                                        to: "en")
                                        .then((value) {
                                      setState(() {
                                        chat.text = value.toString();
                                        isTranslate = true;
                                      });
                                    });
                                  },
                                ),
                              ],
                            )
                        )
                      ),
                    ],
                  );

                  //   chatBubble(
                  //   chattext: chat.text,
                  //   type: chat.type
                  // );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget chatBubble({required chattext, required ChatMessageType? type}) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: bgColor,
          child: type == ChatMessageType.bot
              ? Icon(Icons.ac_unit_outlined)
              : Icon(
                  Icons.person,
                  color: Colors.white,
                ),
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: type == ChatMessageType.bot ? bgColor : Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12)),
            ),
            child: Text(
              "$chattext",
              style: TextStyle(
                color: type == ChatMessageType.bot ? textColor : bgColor,
                fontSize: 15,
                fontWeight: type == ChatMessageType.bot
                    ? FontWeight.w600
                    : FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
