import 'package:flutter/material.dart';

import '../utils/color_util.dart';

class CustomButton extends StatefulWidget {
  VoidCallback onTap;

  CustomButton({required this.onTap}) ;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Container(
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
          await Future.delayed(Duration(seconds: 2));
          setState(() {
            isLoading = false;
          });

          widget.onTap;

        },
      ),
    );
  }
}
