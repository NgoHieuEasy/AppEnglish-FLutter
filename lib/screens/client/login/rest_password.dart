
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:talk_ing/reusable_widgets/reusable_widget.dart';
import 'package:talk_ing/utils/color_util.dart';

class RestPasswordScreen extends StatefulWidget {
  const RestPasswordScreen({Key? key}) : super(key: key);

  @override
  State<RestPasswordScreen> createState() => _RestPasswordScreenState();
}

class _RestPasswordScreenState extends State<RestPasswordScreen> {
  TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Reset mật khẩu",
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
                reusableTexField(("Email..."), Icons.person_outline, false,
                    _emailTextController),
                SizedBox(
                  height: 20,
                ),
                firebaseButton(context,"Rest mật khẩu",() {
                  FirebaseAuth.instance
                      .sendPasswordResetEmail(email: _emailTextController.text)
                      .then((value) => Navigator.of(context).pop());
                })
              ],
            ),
          ),
        ),
      ),

    );
  }
}
