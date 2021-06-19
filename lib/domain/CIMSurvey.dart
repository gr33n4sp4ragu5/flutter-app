import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum SurveyState {
  FINISHED, STARTED, NEW
}

class CIMSurvey {
  StatelessWidget surveyPage;
  SurveyState state;
  String nextQuestionStep;
  String surveyId;
  String title;

  CIMSurvey(this.surveyPage, this.surveyId, this.state, this.nextQuestionStep, this.title);

}
