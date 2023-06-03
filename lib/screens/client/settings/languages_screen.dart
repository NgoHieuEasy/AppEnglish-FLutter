import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talk_ing/reusable_widgets/show_message.dart';
import 'package:talk_ing/screens/client/home/home_screen.dart';
import 'package:talk_ing/screens/client/settings/menu_setting_screen.dart';
import 'package:talk_ing/utils/color_util.dart';

class LanguagesScreen extends StatefulWidget {
  const LanguagesScreen({Key? key}) : super(key: key);

  @override
  State<LanguagesScreen> createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  List<String> languages = ['Việt Nam', 'English'];
  late String _radioValue = ''; //Initial definition of radio button value
  late String choice;
  late FToast fToast;


  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    setState(() {
      _radioValue = getLanguage().toString();
    });
  }

  Future<String> getLanguage() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('language')!;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text("Chọn ngôn ngữ",
          style: TextStyle(
            color: Colors.black
          ),

          ),
          leading: IconButton(
            color: Colors.black,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MenuSettingScreen()),
              );
            },
            icon: Icon(Icons.arrow_back_outlined),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(15),
          child: ListView.builder(
            itemCount: languages.length,
            itemBuilder: (context, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    languages[index],
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                    ),
                  ),
                  Radio(
                    value: languages[index],
                    groupValue: _radioValue,
                    onChanged: (newValue) {

                      ShowMessage.showToast(context,() async{
                        final prefs = await SharedPreferences.getInstance();
                        setState(() {
                          _radioValue = newValue!;
                        });
                        await prefs.setString('language', _radioValue);
                        getLanguages = prefs.getString('language')!;
                        print(getLanguages);
                        Navigator.of(context).pop();
                      },'https://assets1.lottiefiles.com/packages/lf20_ntbhn8nr.json');

                    },
                  ),

                ],
              );
            },
          ),
        ));
  }
}
