import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talk_ing/model/Questions.dart';

import '../../../../api/question_controller.dart';
import '../../../../utils/color_util.dart';
import 'option.dart';

class QuestionCard extends StatelessWidget {
  final Question question;
  final int? numberPage;
  final int? numberTotal;
   QuestionCard({
    required this.question,required this.numberPage,this.numberTotal
  }) ;



  @override
  Widget build(BuildContext context) {
    QuestionController _controller = Get.put(QuestionController());
    return Container(
      margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
      padding: EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          Text(
            "${numberPage.toString()} / ${numberTotal}"
          ),
          Text(
            question.question.toString(),
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(color: kBlackColor),
          ),
          SizedBox(height: kDefaultPadding / 2),
          ...List.generate(
            question.options!.length,
            (index) => Option(
              index: index,
              text: question.options![index],
              press: () {
                //=> _controller.checkAns(question, index),
                print(index);
              }

            ),
          ),
        ],
      ),
    );
  }
}
