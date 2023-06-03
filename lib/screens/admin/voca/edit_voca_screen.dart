import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_field/date_time_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:talk_ing/api/FirebaseTopic.dart';
import 'package:talk_ing/api/FirebaseVocabulary.dart';
import 'package:talk_ing/model/vocabulary.dart';
import 'package:talk_ing/reusable_widgets/animated_textfield.dart';
import 'package:talk_ing/reusable_widgets/custom_appbar.dart';
import 'package:talk_ing/reusable_widgets/show_message.dart';
import 'package:talk_ing/screens/admin/voca/list_voca_screen.dart';
import 'package:talk_ing/utils/color_util.dart';


class EditVocabularyScreen extends StatefulWidget {
 Vocabulary? vocabulary;
  EditVocabularyScreen({this.vocabulary});


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _EditVocabularyScreen();
  }
}

class _EditVocabularyScreen extends State<EditVocabularyScreen> {
  bool isLoading = false;
  final TextEditingController _vocaController = TextEditingController();
  final TextEditingController _exampleController = TextEditingController();
  final Stream<QuerySnapshot> collectionTopic = FirebaseTopic.readTopic();
  late FToast fToast;
  String _imgUrl ='';
  String _audioUrl ='';
  String? _currentTopic ='0';
  String? _idVoca='';
  String urlRadio1 ='';
  String imgUrl1 ='';



  File? _image;
  File? _audio;
  ImagePicker picker = ImagePicker();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future uploadImage(File _image) async{
    String url;
    String imgId = DateTime.now().microsecondsSinceEpoch.toString();
    Reference reference =await FirebaseStorage.instance.ref().child("images${imgId}");
    await reference.putFile(_image);
    url = await reference.getDownloadURL();
    imgUrl1 = url;
    return url;
  }


  Future imagePicker() async{
    try{
      final pick =
      await picker.pickImage(source: ImageSource.gallery);
      setState(() {
        if(pick != null) {
          _image = File(pick.path);
        }
      });
    }catch(e){
      print(e);
    }
  }


  // audio

  Future uploadAudio(File _audio) async{
    String url;
    String imgId = DateTime.now().microsecondsSinceEpoch.toString();
    Reference reference =await FirebaseStorage.instance.ref().child("images${imgId}");
    await reference.putFile(_audio);
    url = await reference.getDownloadURL();
    urlRadio1 = url;
    return url;
  }


  Future audioPicker() async{
    try{
      // final pick =
      //  await picker.pickImage(source: ImageSource.gallery);
      final pick = await FilePicker.platform.pickFiles(
          type: FileType.any
      );
      setState(() {
        if(pick != null) {
          _audio = File(pick.files.single.path ?? "");
        }
      });
    }catch(e){
      print(e);
    }
  }


  //button edit

  Future<void> editVoca() async{
    print("aaaaaaaaaaaa ");
    // String urlRadio =await uploadAudio(_audio!);
    // String imgUrl =await uploadImage(_image!);

    if(urlRadio1 == '' && imgUrl1 == ''){
      print('111111111111');
      final voca = Vocabulary(
          voca: _vocaController.text,
          example: _exampleController.text,
          urlImage: _imgUrl,
          urlAudio: _audioUrl,
          idTopic: _currentTopic,
          uId: _idVoca
      );
      var response = await FirebaseVocabulary.editVoca(voca);
      if (response.code != 200) {
        ShowMessage.showMessage(fToast, response.message.toString(), false);
      } else {
        ShowMessage.showMessage(fToast, response.message.toString(), true);
      }
    }else if(urlRadio1 == '') {
      print('22222222222222');
      final voca = Vocabulary(
          voca: _vocaController.text,
          example: _exampleController.text,
          urlImage: imgUrl1,
          urlAudio: _audioUrl,
          idTopic: _currentTopic,
          uId: _idVoca
      );
      var response = await FirebaseVocabulary.editVoca(voca);
      if (response.code != 200) {
        ShowMessage.showMessage(fToast, response.message.toString(), false);
      } else {
        ShowMessage.showMessage(fToast, response.message.toString(), true);
      }

    }else if(imgUrl1 == '') {
      print('3333333333333333');
      final voca = Vocabulary(
          voca: _vocaController.text,
          example: _exampleController.text,
          urlImage: _imgUrl,
          urlAudio: urlRadio1,
          idTopic: _currentTopic,
          uId: _idVoca
      );
      var response = await FirebaseVocabulary.editVoca(voca);
      if (response.code != 200) {
        ShowMessage.showMessage(fToast, response.message.toString(), false);
      } else {
        ShowMessage.showMessage(fToast, response.message.toString(), true);
      }
    }else{
      print('4444444444444444444444');
      final voca = Vocabulary(
          voca: _vocaController.text,
          example: _exampleController.text,
          urlImage: imgUrl1,
          urlAudio: urlRadio1,
          idTopic: _currentTopic,
          uId: _idVoca
      );
      var response = await FirebaseVocabulary.editVoca(voca);
      if (response.code != 200) {
        ShowMessage.showMessage(fToast, response.message.toString(), false);
      } else {
        ShowMessage.showMessage(fToast, response.message.toString(), true);
      }

    }


  }

  @override
  void initState() {
    // TODO: implement initState
    fToast = FToast();
    fToast.init(context);

    _vocaController.value = TextEditingValue(text: widget.vocabulary!.voca.toString());
    _exampleController.value = TextEditingValue(text: widget.vocabulary!.example.toString());
    _imgUrl = widget.vocabulary!.urlImage.toString();
    _audioUrl = widget.vocabulary!.urlAudio.toString();
    _currentTopic = widget.vocabulary!.idTopic.toString();
    _idVoca = widget.vocabulary!.uId.toString();

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
          await Future.delayed(Duration(seconds: 1));
          setState(() {
            isLoading = false;
          });
          editVoca();
         // addVoca();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:  PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: CustomAppBar(onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ListVocaScreen()),
            );

          },title: "Chỉnh sửa từ vựng",)
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 15,),
            Container(
                height: 80,
                width: 80,
                child: _image==null?Image.network(_imgUrl)
                    :Image.file(_image!,fit: BoxFit.cover,)
            ),
            Container(
              height: 60,
              child: InkWell(
                onTap: () {
                  imagePicker().whenComplete((){
                    uploadImage(_image!);
                  });
                },
                child: Lottie.network("https://assets5.lottiefiles.com/packages/lf20_qSkIccSXCE.json"),
              ),
            ),
            SizedBox(height: 15,),
            Container(
              height: 100,
              child: Column(
                children: [
                  Expanded(child: Center(child: _audioUrl==null?Text(_audioUrl)
                      : Text('Âm thanh đã sẵn sàng')
                  )),

                  Container(
                    height: 60,
                    child: InkWell(
                      onTap: () {
                        audioPicker().whenComplete((){
                          uploadAudio(_audio!);
                        });
                      },
                      child: Lottie.network("https://assets3.lottiefiles.com/packages/lf20_c1b2r3ac.json"),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 10,),
            Container(
                height: 50,
                child:  StreamBuilder(
                  stream:collectionTopic,
                  builder: (context,snapshot){
                    List<DropdownMenuItem> menuItems = [];
                    if(!snapshot.hasData) {
                      const CircularProgressIndicator();
                    }else{
                      final clients = snapshot.data?.docs.reversed.toList();
                      menuItems.add(
                          DropdownMenuItem(
                            value: '0',
                            child: Text('Chọn chủ đề'),
                          )
                      );
                      for(var client in clients!) {
                        menuItems.add(
                            DropdownMenuItem(
                              value: client.id,
                              child: Text(client['name']),
                            )
                        );
                      }
                    }
                    return DropdownButton(
                      items: menuItems,
                      onChanged: (clientValue) {
                        setState(() {
                          _currentTopic = clientValue;
                        });
                        //FirebaseCourseTeacher.getData(clientValue);
                      },
                      value: _currentTopic,
                      isExpanded: false,
                    );
                  },
                )
            ),

            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 25.0),
                    AnimatedTextField(label: 'Thêm từ vựng', controller: _vocaController,),
                    const SizedBox(height: 25.0),
                    AnimatedTextField(label: 'Thêm ví dụ', controller: _exampleController,),
                    const SizedBox(height: 25.0),
                    CustomButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}