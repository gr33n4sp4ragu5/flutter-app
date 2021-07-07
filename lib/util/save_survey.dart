import 'dart:async';
import 'dart:convert';

import 'package:collective_intelligence_metre/domain/saved_survey.dart';
import 'package:collective_intelligence_metre/util/shared_preference.dart';
import 'package:collective_intelligence_metre/util/util.dart';
import 'package:http/http.dart';
import 'package:research_package/model.dart';

import 'app_url.dart';

void saveResultsAsync([RPTaskResult results]) async {
  if(results.results.isNotEmpty) {

    print("Saving survey");
    String lastStepAnsweredId = getLastStepAnsweredId(results);
    String surveyId = results.identifier;
    String userEmail = await getCurrentUserEmail();

    SavedSurvey savedSurvey = SavedSurvey(results, lastStepAnsweredId, userEmail, surveyId);
    await SurveyPreferences().saveSurvey(savedSurvey);
    //markSurveyAsStarted();
  } else {
    print("Results esta vacio");
  }

}

String getLastStepAnsweredId(RPTaskResult result) {
  DateTime latest = DateTime(1900);
  String lastId = "";
  Map<String, RPResult> answers = result.results;
  answers.forEach((key, value) {
    if(value.startDate.isAfter(latest)) {
      latest = value.startDate;
      lastId = key;
    }
  });
  print("The lastId is: " + lastId);
  return lastId;
}

send_survey(RPTaskResult formatted_result) async {

  final Map<String, dynamic> survey_data = {
    'survey': formatted_result
  };

  String token = await UserPreferences.getToken();
  String myBody = json.encode(survey_data);

  return await post(AppUrl.sendSurveyAnswer,
      body: myBody,
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer ' + token })
      .then(onValue);
}

Future<FutureOr> onValue(Response response) async {
  var result;
  final Map<String, dynamic> responseData = json.decode(response.body);

  print(response.statusCode);
  if (response.statusCode == 201) {
    result = {'status': true, 'message': 'Survey answer successfully sent'};
  } else {
    result = {
      'status': false,
      'message': 'Failed to send the answer of the survey',
      'data': responseData
    };
  }

  return result;
}

void resultCallback(RPTaskResult results) async {
  String lastStepAnsweredId = getLastStepAnsweredId(results);
  String surveyId = results.identifier;
  String userEmail = await getCurrentUserEmail();

  SavedSurvey savedSurvey = SavedSurvey(results, lastStepAnsweredId, userEmail, surveyId);
  await SurveyPreferences().saveSurvey(savedSurvey);
  SavedSurvey finalResult = await SurveyPreferences().getSavedSurvey(userEmail, surveyId);

  try{
    await sendAndRemoveSurvey(finalResult, userEmail, surveyId);
  } catch(error) {
    print(error);
    print("Error sending survey, retrying...");
    await sendAndRemoveSurvey(finalResult, userEmail, surveyId);
  }

}

Future sendAndRemoveSurvey(SavedSurvey finalResult, String userEmail, String surveyId) async {
  var response = await send_survey(finalResult.rawResults);
  if(response['status'] == true) {
    await SurveyPreferences().removeSavedSurvey(userEmail, surveyId);
    print("Removed the saved survey");
  }
}

Future<RPOrderedTask> getTaskAsync(RPOrderedTask wholeTask) async {
  if(wholeTask == null){
    print("the whole task is null");
    throw Exception("The RPOrderedTask passed is null");
  }
  String surveyId = wholeTask.identifier;
  String userEmail = await getCurrentUserEmail();
  SavedSurvey survey = await SurveyPreferences().getSavedSurvey(userEmail, surveyId);

  if(survey == null) {
    return wholeTask;
  } else {
    print("survey found for this user and survey ID");
    print(survey.lastStepAnsweredId);
    List<RPStep> finalSteps = [];
    RPStep lastStepAnswered = wholeTask.getStepWithIdentifier(survey.lastStepAnsweredId);
    RPStep aux = wholeTask.getStepAfterStep(lastStepAnswered, null);
    while(aux != null) {
      finalSteps.add(aux);
      aux = wholeTask.getStepAfterStep(aux, null);
    }
    print("Returning this");
    print(new RPOrderedTask(surveyId, finalSteps));

    RPOrderedTask finalTask = new RPOrderedTask(surveyId, finalSteps);
    if(finalTask == null) throw Exception("finalTask es null");

    return finalTask;
  }

}

onError(error) {
  print("the error is $error.detail, $error");
  throw Exception("please retry");
}