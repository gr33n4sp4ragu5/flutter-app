import 'package:research_package/model.dart';

class SavedSurvey{

RPTaskResult rawResults;// The results as they are returned from the survey package when finalized
String lastStepAnsweredId; // The id of the last step which was answered
String userEmail; // The user whose survey we are saving, as multiple accounts can be used.
String surveyId; // Which survey we are saving.

SavedSurvey(this.rawResults, this.lastStepAnsweredId, this.userEmail, this.surveyId);

//TODO- expirationDate when we will delete this survey (Not a priority)
  SavedSurvey.FromJson(Map<String, dynamic> json)
      : rawResults = json['rawResults'],
        lastStepAnsweredId = json['lastStepAnsweredId'],
        userEmail = json['userEmail'],
        surveyId = json['surveyId'];

  Map<String, dynamic> toJson() {
    return {
      'lastStepAnsweredId': lastStepAnsweredId,
      'userEmail': userEmail,
      'surveyId': surveyId,
      'rawResults': rawResults
    };
  }

}