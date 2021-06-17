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

  Widget toWidget(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(this.title),
        tileColor: Color(0xFF36ABC4),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => this.surveyPage),
          );
        },
      ),
    );
  }
}
