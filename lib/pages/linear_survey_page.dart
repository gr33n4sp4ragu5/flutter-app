import 'dart:async';

import 'package:collective_intelligence_metre/domain/saved_survey.dart';
import 'package:collective_intelligence_metre/util/app_url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:research_package/research_package.dart';
import 'package:collective_intelligence_metre/util/shared_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../research_package_objects/linear_survey_objects.dart';
import 'dart:convert';

class LinearSurveyPage extends StatefulWidget {
  static Future<FutureOr> onValue(Response response) async {
    var result;
    final Map<String, dynamic> responseData = json.decode(response.body);

    print(response.statusCode);
    if (response.statusCode == 201) {

      result = {
        'status': true,
        'message': 'Survey answer successfully sent'
      };
    } else {
      result = {
        'status': false,
        'message': 'Failed to send the answer of the survey',
        'data': responseData
      };
    }

    return result;
  }

  static onError(error) {
    print("the error is $error.detail");
    return {'status': false, 'message': 'Unsuccessful Request', 'data': error};
  }

  @override
  _LinearSurveyPageState createState() => _LinearSurveyPageState();
}

class _LinearSurveyPageState extends State<LinearSurveyPage> {
  Future<RPOrderedTask> futureTask;

  @override
  void didUpdateWidget(covariant LinearSurveyPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    futureTask = getTaskAsync(linearSurveyTask); //TODO- check if we can do it this way or it makes no sense

  }
  String _encode(Object object) => const JsonEncoder.withIndent(' ').convert(object);

  void resultCallback(RPTaskResult result) {
    // Do anything with the result
    send_survey(result);
    print(_encode(result));
  }

  void cancelCallBack(RPTaskResult result) {
    // Do anything with the result at the moment of the cancellation
    print("The result so far:\n" + _encode(result));
  }

  Future<Map<String, dynamic>> send_survey(RPTaskResult formatted_result) async {

    final Map<String, dynamic> survey_data = {
      'survey': formatted_result
    };

    String token = await UserPreferences.getToken();

    return await post(AppUrl.sendSurveyAnswer,
        body: json.encode(survey_data),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer ' + token })
        .then(LinearSurveyPage.onValue)
        .catchError(LinearSurveyPage.onError);
  }

  void saveResultsAsync([RPTaskResult results]) async {
    String lastStepAnsweredId = getLastStepAnsweredId(results);
    String surveyId = results.identifier;
    String userEmail = await getCurrentUserEmail();

    SavedSurvey savedSurvey = SavedSurvey(results, lastStepAnsweredId, userEmail, surveyId);
    SurveyPreferences().saveSurvey(savedSurvey);
    //markSurveyAsStarted();

  }

  String getLastStepAnsweredId(RPTaskResult result) {
    DateTime latest = DateTime(1900);
    String lastId;
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

  Widget buildSurvey(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    if(snapshot.connectionState == ConnectionState.done) {
      return Theme(
        data: isDarkMode
        // Dark mode
            ? ThemeData.dark()
        // Your styling
            : ThemeData(
          primaryColor: Colors.red,
          accentColor: Colors.green,
          backgroundColor: Colors.white,
          dividerColor: Colors.grey,
          textTheme: Typography.blackMountainView,
        ),
        child: RPUITask(
          task: snapshot.data,
          onSubmit: (result) {
            resultCallback(result);
          },
          onCancel: ([RPTaskResult results]) {
            saveResultsAsync(results);
          },
          // No onCancel
          // If there's no onCancel provided the survey just quits
        ),
      );
    } else  if (snapshot.connectionState == ConnectionState.waiting){

      return Theme(
        data: isDarkMode
        // Dark mode
            ? ThemeData.dark()
        // Your styling
            : ThemeData(
          primaryColor: Colors.red,
          accentColor: Colors.green,
          backgroundColor: Colors.white,
          dividerColor: Colors.grey,
          textTheme: Typography.blackMountainView,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            Text(" Datos")
          ],
        ),
      );
    } else return Text(snapshot.connectionState.toString());

  }

@override
  Widget build(BuildContext context) {

    return FutureBuilder(future: getTaskAsync(linearSurveyTask), builder: buildSurvey);
  }
}

Future<RPOrderedTask> getTaskAsync(RPOrderedTask wholeTask) async {
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
      finalSteps.add(wholeTask.getStepAfterStep(aux, null));
      aux = wholeTask.getStepAfterStep(aux, null);
    }
    print("Returning this");
    print(new RPOrderedTask(surveyId, finalSteps));
    return new RPOrderedTask(surveyId, finalSteps);
  }

}

getCurrentUserEmail() async {
  String token = await UserPreferences.getToken();
  print("The token is:");
  print(token);

  Response response = await get(AppUrl.getProfileData,
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer ' + token });
  final Map<String, dynamic> responseData = json.decode(response.body)["profile_data"];
  return responseData['email'];
}
