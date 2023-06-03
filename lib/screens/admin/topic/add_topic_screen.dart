import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:talk_ing/api/FirebaseTopic.dart';
import 'package:talk_ing/model/topic.dart';
import 'package:talk_ing/reusable_widgets/animated_textfield.dart';
import 'package:talk_ing/reusable_widgets/custom_appbar.dart';
import 'package:talk_ing/reusable_widgets/custom_button.dart';
import 'package:talk_ing/reusable_widgets/show_message.dart';
import 'package:talk_ing/screens/admin/topic/list_topic_screen.dart';

import '../../../utils/color_util.dart';

class AddTopicScreen extends StatefulWidget {
  const AddTopicScreen({Key? key}) : super(key: key);

  @override
  State<AddTopicScreen> createState() => _AddTopicScreenState();
}

class _AddTopicScreenState extends State<AddTopicScreen> {
  bool isLoading = false;
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    // if you want to use context from globally instead of content we need to pass navigatorKey.currentContext!
    fToast.init(context);
  }
  TextEditingController _topicController = TextEditingController();
  Future<void> addTopic() async{
      final topic = Topic(name: _topicController.text);
      if(_topicController.text == ''){
        ShowMessage.showMessage(fToast, 'Không được để trống',false);
      }else{
        final response = await FirebaseTopic.addTopic(topic);
        if(response.code != 200) {
          ShowMessage.showMessage(fToast, response.message.toString(),false);
        } else {
          ShowMessage.showMessage(fToast, response.message.toString(),true);

        }
      }

  }

  Widget CustomButton() {
    return  Container(
      width: 250,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          textStyle: TextStyle(fontSize: 19),
          minimumSize: Size.fromHeight(45),
          shape: StadiumBorder(),
          backgroundColor: bgColor,
        ),
        child:isLoading ?
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white,),
            const SizedBox(width: 24,),
            Text('Xin chờ...')
          ],
        )

            : Text('Đồng ý'),
        onPressed: () async{
          if(isLoading) return;
          setState(() {
            isLoading = true;
          });
          addTopic();
          setState(() {
            isLoading = false;
          });
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: CustomAppBar(onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ListTopicSreen()),
            );

          },title: "Thêm chủ đề",)
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              AnimatedTextField(label: 'Thêm chủ đề', controller: _topicController,),
              SizedBox(
                height: 35,
              ),
              CustomButton()

            ],
          ),
        ),
      ),
    );
  }


}
