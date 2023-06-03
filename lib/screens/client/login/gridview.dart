import 'package:flutter/material.dart';


class Gridview1 extends StatefulWidget {
  Gridview1();

  @override
  _Gridview1State createState() => _Gridview1State();
}

class _Gridview1State extends State<Gridview1> {
  int optionSelected = 0;

  void checkOption(int index) {
    setState(() {
      optionSelected = index;
    });
  }

   List<Map<String, dynamic>> months = <Map<String, dynamic>>[
    <String, dynamic>{
      'month': 'January',
      'img': 'assets/Icon9.png',
    },
    <String, dynamic>{
      'month': 'February',
      'img': 'assets/Icon1.png',
    },
    <String, dynamic>{
      'month': 'March',
      'img': 'assets/Icon2.png',
    },
    <String, dynamic>{
      'month': 'April',
      'img': 'assets/Icon3.png',
    },
    <String, dynamic>{
      'month': 'May',
      'img': 'assets/Icon4.png',
    },
    <String, dynamic>{
      'month': 'June',
      'img': 'assets/Icon5.png',
    },
    <String, dynamic>{
      'month': 'July',
      'img': 'assets/Icon6.png'
    },
    <String, dynamic>{
      'month': 'August',
      'img': 'assets/Icon7.png',
    },
    <String, dynamic>{
      'month': 'September',
      'img': 'assets/Icon8.png',
    },
    <String, dynamic>{
      'month': 'October',
      'img': 'assets/Icon9.png',
    },
    <String, dynamic>{
      'month': 'November',
      'img': 'assets/Icon1.png',
    },
    <String, dynamic>{
      'month': 'December',
      'img': 'assets/Icon2.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selection and Settings $optionSelected'),
      ),
      body: GridView.count(
        crossAxisSpacing: 13,
       // scrollDirection: Axis.horizontal,
        crossAxisCount: 3,
        children: <Widget>[
          for (int i = 0; i < months.length; i++)
            MonthOption(
              months[i]['month'] as String,
              img: months[i]['img'] as String,
              onTap: () => checkOption(i + 1),
              selected: i + 1 == optionSelected,
            )
        ],
      ),
    );
  }
}

class MonthOption extends StatelessWidget {
  const MonthOption(
      this.title, {
        this.img,
        this.onTap,
        this.selected,
      });

  final String? title;
  final String? img;
  final VoidCallback? onTap;
  final bool? selected;

  @override
  Widget build(BuildContext context) {
    return Ink.image(
      fit: BoxFit.cover,
      image: AssetImage(img!),
      child: InkWell(
        onTap: onTap,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: selected ?? false ? Colors.greenAccent : Colors.transparent,
                  width: selected ?? false ? 5 : 0,
                ),
              ),
            ),
            padding: const EdgeInsets.all(8.0),
            child: Row(children: <Widget>[
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child:selected ==true
                  ?Container(
                  height: 30,
                  width: 30,
                  child:  Image.asset("assets/iconCheck.png",fit:BoxFit.cover,)
                ):Container(
                  width: 0,
                  height: 0,
                )
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
