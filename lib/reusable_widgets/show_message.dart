import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:lottie/lottie.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';

class ShowMessage {
  static void showMessage(FToast fToast,String message,bool isCheck) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color:isCheck ? Colors.greenAccent : Colors.redAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          isCheck ? Icon(Icons.check) : Icon(Icons.sms_failed_outlined),
          SizedBox(
            width: 12.0,
          ),
          Text(message),
        ],
      ),
    );


    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );

  }

  static  void showToast(context,VoidCallback onTap,String url) {
    Dialogs.materialDialog(
        color: Colors.white,
        msg: 'Bạn đã chắc chắn chưa?',
        title: 'Cảnh báo!',
        lottieBuilder: Lottie.network(
          url,
          fit: BoxFit.contain,
        ),
        context: context,
        actions: [
          IconsOutlineButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            text: 'Hủy',
            iconData: Icons.cancel_outlined,
            textStyle: TextStyle(color: Colors.grey),
            iconColor: Colors.grey,
          ),
          IconsButton(
            onPressed: onTap,
            text: 'Đồng ý',
            iconData: Icons.verified_user,
            color: Colors.blue,
            textStyle: TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ]
    );
  }

  static  void showToastClient(context,VoidCallback onTap,String url,String msg,bool isCheck) {
    Dialogs.materialDialog(
        color: Colors.white,
        msg: msg,
        title: 'Thông báo!',
        lottieBuilder: Lottie.network(
          url,
          fit: BoxFit.contain,
        ),
        context: context,
        actions: [

          isCheck?Center(
            child: IconsButton(
              onPressed: onTap,
              text: 'Tiếp theo',
              iconData: Icons.verified_user,
              color: Colors.blue,
              textStyle: TextStyle(color: Colors.white),
              iconColor: Colors.white,
            ),
          ):Center(
            child: IconsButton(
              onPressed: onTap,
              text: 'Thử lại',
              iconData: Icons.verified_user,
              color: Colors.red,
              textStyle: TextStyle(color: Colors.white),
              iconColor: Colors.white,
            ),
          ),
        ]
    );
  }


}