import 'package:flutter/material.dart';
import 'package:talk_ing/model/Questions.dart';
import 'package:talk_ing/screens/client/quizz/components/question_card.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final _controllerPageView = PageController(initialPage: 1);
  late List<Question> _questions;
  int numberPage = 0;

  @override
  void initState(){
    getData();
    super.initState();
  }


  @override
  void dispose(){
    _controllerPageView.dispose();
    super.dispose();
  }

   List sample_data1 = [
    {
      "id": 1,
      "question":
      "Flutter is an open-source UI software development kit created by ______",
      "options": ['Apple', 'Google', 'Facebook', 'Microsoft'],
      "answer_index": 1,
    },
    {
      "id": 2,
      "question": "When google release Flutter.",
      "options": ['Jun 2017', 'Jun 2017', 'May 2017', 'May 2018'],
      "answer_index": 2,
    },
    {
      "id": 3,
      "question": "A memory location that holds a single letter or number.",
      "options": ['Double', 'Int', 'Char', 'Word'],
      "answer_index": 2,
    },
    {
      "id": 4,
      "question": "What command do you use to output data to the screen?",
      "options": ['Cin', 'Count>>', 'Cout', 'Output>>'],
      "answer_index": 2,
    },

  ];

  void getData() {
     _questions = sample_data1
        .map(
          (question) => Question(
          id: question['id'],
          question: question['question'],
          options: question['options'],
          answer: question['answer_index']),
    )
        .toList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("app bar"),
        actions: [
          IconButton(
          onPressed: (){
            _controllerPageView.previousPage(
                duration: Duration(seconds: 1),
                curve: Curves.easeInOut);

          }, icon: Icon(Icons.keyboard_arrow_left)),
          IconButton(
              onPressed: (){
                _controllerPageView.nextPage(
                    duration: Duration(seconds: 1),
                    curve: Curves.easeInOut);
              }, icon: Icon(Icons.keyboard_arrow_right))
        ],
      ),
      body: PageView.builder(
        physics: NeverScrollableScrollPhysics(),
        controller: _controllerPageView,
        onPageChanged:(index) {
          numberPage =index;
          print('page ${index}');
        },
        itemCount: _questions.length,
        itemBuilder: (context, index) => QuestionCard(
            question: _questions[index],numberPage: numberPage,numberTotal:_questions.length),
      ),
    );
  }
}
