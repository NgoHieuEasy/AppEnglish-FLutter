import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget {
    String title;
    VoidCallback onTap;
   CustomAppBar({required this.title,required this.onTap});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: widget.onTap,
        icon: Icon(Icons.arrow_back_outlined),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30)
          )
      ),
      brightness: Brightness.light,
      centerTitle: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)
            ),
            gradient: LinearGradient(
                colors: [Colors.pink,Colors.pinkAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight
            )
        ),
      ),
      title: Text(widget.title,style: TextStyle(color: Colors.black),),
    );
  }
}

