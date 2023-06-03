import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:talk_ing/api/FirebaseUser.dart';
import 'package:talk_ing/model/user.dart';
import 'package:talk_ing/reusable_widgets/reusable_widget.dart';
import 'package:talk_ing/screens/client/home/home_screen.dart';
import 'package:talk_ing/screens/client/login/signin_screen.dart';
import 'package:talk_ing/utils/color_util.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _againPassController = TextEditingController();

  Future<void> SignUp() async{
    if(_passwordController.text != _againPassController.text) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("Mật khẩu không khớp"),
            );
          });
    }else{
      final user = Users(username: _usernameController.text,
          email: _emailController.text,password: _passwordController.text);
      final response = await FirebaseUser.signUpUser(user);



      if(response.code != 200) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(response.message.toString()),
              );
            });
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignInScreen()),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Đăng ký",
          style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              hexStringColor("CB2B93"),
              hexStringColor("9546C4"),
              hexStringColor("5E61F4"),
            ],begin: Alignment.topCenter,end: Alignment.bottomCenter)
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2,
                20, 0),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                reusableTexField(("Tên tài khoản..."), Icons.person, false,
                    _usernameController),
                SizedBox(
                  height: 20,
                ),
                reusableTexField(("Email..."), Icons.email_outlined, false,
                    _emailController),
                SizedBox(
                  height: 20,
                ),
                reusableTexField(("Mật khẩu..."), Icons.verified_user, true,
                    _passwordController),
                SizedBox(
                  height: 20,
                ),
                reusableTexField(("Xác nhận mật khẩu..."), Icons.verified_user, true,
                    _againPassController),
                SizedBox(
                  height: 20,
                ),


                firebaseButton(context, "Đăng nhập",() {
                  SignUp();
                }),


              ],
            ),
          ),
        ),
      ),

    );
  }
}
