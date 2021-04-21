import 'package:quiz_flutter/challenge/challenge_page.dart';
import 'package:quiz_flutter/home/home_page.dart';
import 'package:quiz_flutter/splash/splash_page.dart';

import 'package:flutter/material.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "DevQuiz",
      home: ChallengePage(),
    );
  }
}
