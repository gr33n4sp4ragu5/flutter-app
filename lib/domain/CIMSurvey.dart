import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum SurveyState {
  FINISHED, STARTED, NEW
}

class CIMSurvey {
  Widget surveyPage;
  SurveyState state;
  String nextQuestionStep; //Field which indicates the next step id when the survey is saved without being submitted
  String surveyId;
  String title;

  CIMSurvey(this.surveyPage, this.surveyId, this.state, this.nextQuestionStep, this.title);

}
