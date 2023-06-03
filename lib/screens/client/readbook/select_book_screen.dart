import 'package:flutter/material.dart';
import 'package:talk_ing/reusable_widgets/custom_appbar.dart';
import 'package:talk_ing/screens/client/home/home_screen.dart';
import 'package:talk_ing/screens/client/readbook/read_book_screen.dart';
import 'package:talk_ing/screens/client/speak/speak_screen.dart';

class SelectBookScreen extends StatefulWidget {
  const SelectBookScreen({Key? key}) : super(key: key);

  @override
  State<SelectBookScreen> createState() => _SelectBookScreenState();
}

class _SelectBookScreenState extends State<SelectBookScreen> {
  final List<Map<String, dynamic>> gridMap = [
    {
      "title": "Odd Girl Out",
      "images": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ49lxrwmxHgui6kRKshUTkicWijtwh2SP6Xg&usqp=CAU",
    },
    {
      "title": "Seungha and Nari",
      "images":"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQWTTZhz1A3dlyZrQ9VM1aOGyKNOamblCWxaQ&usqp=CAU",
    },
    {
      "title": "Amazing spiderman",
      "images":"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSb4bp-2AF4VsyAOtITPj3itgIqvzG6FA_nRw&usqp=CAU"
    },
    {
      "title": "Asterix the camp",
      "images":"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSoW24SaCfRRq5lV9Kl-QWtF14ya4NWuAiEaA&usqp=CAU"
    },
    {
      "title": "Batman SupperMan",
      "images":"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTZofvcJAlTOlOzfCcGhutzSW9nPpiRttnvAw&usqp=CAU"
    },
    {
      "title": "Attas and friends",
      "images":"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRGC0-TUm1MKSiCvu5oUyojDkBR3O0uPG_X2fie255lUVc6GL2TmT0PPKJwqdyGF6ZhAmY&usqp=CAU"
    },
    {
      "title": "The daily life of Immortal",
      "images":"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT4tXc4E9xYgARKBKpG1uA_7EHN3oprRy31tQ&usqp=CAU"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(

        centerTitle: true,
        title: Text("Lựa chon sách bạn yêu thích"),
        backgroundColor: Colors.pinkAccent.shade100,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
          icon: Icon(Icons.arrow_back_outlined),
        ),
      ),
      body: SingleChildScrollView(
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
            mainAxisExtent: 171,
          ),
          itemCount: gridMap.length,
          itemBuilder: (_, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReadBookScreen()),
                );
              },
              child: AnimatedContainer(
                padding: EdgeInsets.only(bottom: 3,right: 3),
                decoration: BoxDecoration(
                  color:Colors.black12,
                  borderRadius: BorderRadius.circular(16),

                ),
                duration: const Duration(milliseconds: 100),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      16.0,
                    ),
                    color: Colors.pinkAccent.shade100,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                        child: Image.network(
                          "${gridMap.elementAt(index)['images']}",
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(
                          "${gridMap.elementAt(index)['title']}",
                          style: Theme.of(context).textTheme.subtitle1!.merge(
                            const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
