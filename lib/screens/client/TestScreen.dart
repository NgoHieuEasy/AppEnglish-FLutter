import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  RxInt count = 0.obs;
  RxBool isShow = true.obs;

  var listText = [
    'Chào mọi người mình là Hiếu, người sáng lập ra ứng dụng tiếng anh này',
    'Đây là bước đầu tiên tạo nhân vật mà bạn yêu thích và hãy điền tên nhân vật',
    'Chúc bạn có một trải nghiệm tuyệt vời...'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("this is test screen"),
        ),
        body: Container(
            height: 100,
            color: Colors.white24,
            child: Positioned(
              left: 0,
              bottom: 0,
              right: 0,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Image(
                      image: AssetImage("assets/nhanvat/nhanvat1.png"),
                    ),
                  ),
                  Expanded(
                    child: Obx(() =>
                        isShow.value ? Text(listText[count.value]) : Container()),
                  ),
                  Container(
                    width: 50,
                    child: TextButton(
                        onPressed: () {
                          if (count < listText.length - 1) {
                            count.value = count.value + 1;
                          } else {
                            isShow.value = false;
                          }
                        },
                        child: Text("Tiếp tục")),
                  )
                ],
              ),
            )));
  }
}
