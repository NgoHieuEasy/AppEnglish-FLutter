import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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


class AddVocabularyScreen extends StatefulWidget {
  const AddVocabularyScreen({Key? key}) : super(key: key);

  @override
  State<AddVocabularyScreen> createState() => _AddVocabularyScreenState();
}

class _AddVocabularyScreenState extends State<AddVocabularyScreen> {
  bool isLoading = false;
  late FToast fToast;

  TextEditingController _vocaController = TextEditingController();
  TextEditingController _exampleController = TextEditingController();

  File? _audio;
  ImagePicker picker = ImagePicker();
  File? _image;
  String? _currentTopic ='0';

  final Stream<QuerySnapshot> collectionTopic = FirebaseTopic.readTopic();



  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }


  // images
  Future uploadImage(File _image) async{
    String url;
    String imgId = DateTime.now().microsecondsSinceEpoch.toString();
    Reference reference =await FirebaseStorage.instance.ref().child("images${imgId}");
    await reference.putFile(_image);
    url = await reference.getDownloadURL();
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
  //button add

  Future<void> addVoca() async{
    final urlRadio =await uploadAudio(_audio!);
    final imgUrl =await uploadImage(_image!);
    final voca = Vocabulary(
      voca: _vocaController.text,
      example: _exampleController.text,
      urlImage: imgUrl,
      urlAudio: urlRadio,
      idTopic: _currentTopic
    );
    var response = await FirebaseVocabulary.addVoca(voca,_currentTopic!);
    // ỏ đay 200 thanh cong
    if (response.code != 200) {
      ShowMessage.showMessage(fToast, response.message.toString(), false);
    } else {
      ShowMessage.showMessage(fToast, response.message.toString(), true);
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
          await Future.delayed(Duration(seconds: 1));
          setState(() {
            isLoading = false;
          });
          addVoca();
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

          },title: "Thêm chủ đề",)
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 15,),
            Container(
              height: 150,
              child: Column(
                children: [
                  // Expanded(child: Center(child: _image==null?Text("Không có hình ảnh")
                  //     :Image.file(_image!,height: 80,width: 80,)
                  //
                  // )),
                  Container(
                    height: 80,
                    width: 80,
                  child: _image==null?Text("Không có hình ảnh")
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
                  )
                ],
              ),
            ),
            SizedBox(height: 15,),
            Container(
              height: 100,
              child: Column(
                children: [
                  Expanded(child: Center(child: _audio==null?Text("Không dữ liệu")
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
            SizedBox(height: 15,),
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
                            child: Text('Chọn học chủ đề'),
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
                       // FirebaseCourseTeacher.getData(clientValue);
                      },
                      value: _currentTopic,
                      isExpanded: false,
                    );
                  },
                )
            ),
            AnimatedTextField(label: 'Thêm từ vựng', controller: _vocaController,),
            SizedBox(height: 10,),
            AnimatedTextField(label: 'Thêm ví dụ', controller: _exampleController,),
            SizedBox(
              height: 35,
            ),
            CustomButton()

          ],
        ),
      ),
    );
  }
}
