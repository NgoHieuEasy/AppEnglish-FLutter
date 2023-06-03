import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:talk_ing/screens/client/home/home_screen.dart';
import 'package:talk_ing/screens/client/leaBoard/leader_board.dart';
import 'package:talk_ing/screens/client/login/signin_screen.dart';
import 'package:talk_ing/screens/client/profile/profile_screen.dart';
import 'package:talk_ing/screens/client/savedVoca/saved_voca_screen.dart';
import 'package:talk_ing/screens/client/settings/languages_screen.dart';
import 'package:talk_ing/screens/client/settings/menu_setting_screen.dart';
import 'package:talk_ing/utils/color_util.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width / 1.5,
      child: ListView(
        shrinkWrap: true,
        children: [
          Container(
            height: 100,
            width: double.infinity,
            child:Lottie.network("https://assets10.lottiefiles.com/packages/lf20_cUG5w8.json") ,
          ),
          DrawerListTile(
            urlImage: "assets/iconWan.png",
            title: getLanguages=='English'?'feature':"Chức năng",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
          ),
          DrawerListTile(
            urlImage: "assets/iconRank.png",
            title: getLanguages=='English'?"Leader board":"Bảng xếp hạng",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LeaderBoardScreen()),
              );
            },
          ),
          DrawerListTile(
            urlImage: "assets/iconInfo.png" ,
            title:getLanguages=="English"?"Information":"Thông tin cá nhân",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );

            },
          ),
          DrawerListTile(
            urlImage: "assets/iconSaved.png",
            title: getLanguages=="English"?"Vocabulary saved":"Từ vựng đã lưu",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SavedVocabularyScreen()),
              );
            },
          ),
          DrawerListTile(
            urlImage: "assets/iconSetting.png",
            title: getLanguages=="English"?"Settings":"Cài đặt",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MenuSettingScreen(


                )),
              );
            },
          ),
          const SizedBox(
            height: 10,
          ),
          DrawerListTile(
            urlImage: "assets/iconLogout.png",
            title:getLanguages=="English"?"Log out":"Đăng xuất",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignInScreen()),
              );
            },
          ),
          
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.urlImage,
    required this.title,
    required this.onTap,
  }) : super(key: key);
  final String urlImage;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      horizontalTitleGap: 0,
      leading:  Image.asset(
        urlImage,
        width: 40.0,
        height: 40.0,
        fit: BoxFit.cover,
      ),
      title: Text(
        title,
        style: const TextStyle(
            fontSize: 17,
            color: Colors.grey),
      ),
    );
  }
}