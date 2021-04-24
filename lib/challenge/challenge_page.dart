import 'package:flutter/material.dart';
import 'package:quiz_flutter/challenge/challenge_controller.dart';

import 'package:quiz_flutter/challenge/widgets/next_button/next_button_widget.dart';
import 'package:quiz_flutter/challenge/widgets/question_indicator/question_indicator_widget.dart';
import 'package:quiz_flutter/challenge/widgets/quiz/quiz_widget.dart';
import 'package:quiz_flutter/result/result_page.dart';
import 'package:quiz_flutter/shared/models/question_model.dart';

class ChallengePage extends StatefulWidget {
  final List<QuestionModel> questions;
  final String title;
  const ChallengePage({
    Key? key,
    required this.questions,
    required this.title,
  }) : super(key: key);

  @override
  _ChallengePageState createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  final controller = ChallengeController();
  final pageController = PageController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController.addListener(() {
      controller.currentPage = pageController.page!.toInt() + 1;
    });
  }

  void nextPage() {
    if (controller.currentPage < widget.questions.length)
      pageController.nextPage(
          duration: Duration(milliseconds: 500), curve: Curves.linear);
  }

  void onSelected(bool value) {
    if (value) {
      controller.qtdAwnserRight++;
    }
    nextPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(86),
        child: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BackButton(),
            ValueListenableBuilder<int>(
              valueListenable: controller.currentPageNotifier,
              builder: (context, value, _) => QuestionIndicatorWidget(
                  currentPage: value, length: widget.questions.length),
            ),
          ],
        )),
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        children: widget.questions
            .map((e) => QuizWidget(
                  question: e,
                  onSelected: onSelected,
                ))
            .toList(),
      ),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: ValueListenableBuilder<int>(
            valueListenable: controller.currentPageNotifier,
            builder: (context, value, _) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (value < widget.questions.length)
                  Expanded(
                      child: NextButtonWidget.white(
                    label: "Pular",
                    onTap: nextPage,
                  )),
                if (value == widget.questions.length)
                  Expanded(
                      child: NextButtonWidget.green(
                    label: "Confirmar",
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ResultPage(
                                    result: controller.qtdAwnserRight,
                                    title: widget.title,
                                    length: widget.questions.length,
                                  )));
                    },
                  ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
