import 'package:collective_intelligence_metre/research_package_objects/tds_survey.dart';
import 'package:collective_intelligence_metre/surveys/survey_ui.dart';
import 'package:collective_intelligence_metre/util/save_survey.dart';
import 'package:flutter/material.dart';


class TDSSurveyPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(future: getTaskAsync(tdsLinearSurveyTask), builder: buildSurvey);
  }
}
