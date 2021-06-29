import 'package:collective_intelligence_metre/surveys/survey_ui.dart';
import 'package:collective_intelligence_metre/util/save_survey.dart';
import 'package:flutter/material.dart';
import '../research_package_objects/linear_survey_objects.dart';

class LinearSurveyPage extends StatefulWidget {

  @override
  _LinearSurveyPageState createState() => _LinearSurveyPageState();
}

class _LinearSurveyPageState extends State<LinearSurveyPage> {

@override
  Widget build(BuildContext context) {

    return FutureBuilder(future: getTaskAsync(linearSurveyTask), builder: buildSurvey);
  }
}
