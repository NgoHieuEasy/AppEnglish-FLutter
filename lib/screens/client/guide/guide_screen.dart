
import 'package:flutter/material.dart';
import 'package:talk_ing/screens/client/home/home_screen.dart';

class GuideScreen extends StatefulWidget {
  const GuideScreen({Key? key}) : super(key: key);

  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
       backgroundColor: Colors.black26,
      appBar:AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          color: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
          icon: Icon(Icons.arrow_back_outlined),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Center(
            child: Container(
              height: MediaQuery.of(context).size.height*0.8,
              width: MediaQuery.of(context).size.width*0.9,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.8),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child:RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(text:"Chào mừng các mình là Hiếu, Chào mừng các bạn đến với hướng dẫn sử dụng ứng dung\n",style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500
                      )),
                      TextSpan(text:"1. Câu lệnh đăng nhập\n",style: TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                        fontWeight: FontWeight.w500
                      )),
                      TextSpan(text:"Điền vào ô tài khoản bạn có thể nói",style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,

                      ),
                      children: <InlineSpan>[
                        TextSpan(text: " My name is *tên của bạn*\n",style: TextStyle(
                          fontSize: 15,
                          color: Colors.blue,
                        ))
                      ],

                      ),

                      TextSpan(text:"Điền vào ô mật khẩu bạn có thể nói",style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,

                      ),
                        children: <InlineSpan>[
                          TextSpan(text: " My password is *tên của bạn*\n",style: TextStyle(
                            fontSize: 15,
                            color: Colors.blue,
                          ))
                        ],
                      ),

                      TextSpan(text:"Bạn muốn đi đến trang tiếp theo",style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,

                      ),
                        children: <InlineSpan>[
                          TextSpan(text: "Go to home\n",style: TextStyle(
                            fontSize: 15,
                            color: Colors.blue,
                          ))
                        ],
                      ),

                      TextSpan(text:"2. Câu lệnh trang chủ\n",style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                          fontWeight: FontWeight.w500
                      )),

                      TextSpan(text:"Bạn muốn xem hướng dẫn",style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,

                      ),
                        children: <InlineSpan>[
                          TextSpan(text: "What I can do here\n",style: TextStyle(
                            fontSize: 15,
                            color: Colors.blue,
                          ))
                        ],
                      ),
                    ]
                  ),
                )
              ),
            ),
          ),
        ),
      ),
    );
  }
}
