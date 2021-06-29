import 'dart:async';

import 'package:collective_intelligence_metre/domain/saved_survey.dart';
import 'package:collective_intelligence_metre/util/app_url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:research_package/research_package.dart';
import 'package:collective_intelligence_metre/util/shared_preference.dart';
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
    print("the error is $error.detail, $error");
    throw Exception("please retry");
  }

  @override
  _LinearSurveyPageState createState() => _LinearSurveyPageState();
}

class _LinearSurveyPageState extends State<LinearSurveyPage> {


  void resultCallback(RPTaskResult results) async {
    String lastStepAnsweredId = getLastStepAnsweredId(results);
    String surveyId = results.identifier;
    String userEmail = await getCurrentUserEmail();

    SavedSurvey savedSurvey = SavedSurvey(results, lastStepAnsweredId, userEmail, surveyId);
    await SurveyPreferences().saveSurvey(savedSurvey);
    SavedSurvey finalResult = await SurveyPreferences().getSavedSurvey(userEmail, surveyId);

    try{
      await send_survey(finalResult.rawResults);
    } catch(error) {
      print(error);
      print("Error sending survey, retrying...");
      await send_survey(finalResult.rawResults);
    }

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
        .then(LinearSurveyPage.onValue);
  }

  void saveResultsAsync([RPTaskResult results]) async {
    print("Saving survey");
    String lastStepAnsweredId = getLastStepAnsweredId(results);
    String surveyId = results.identifier;
    String userEmail = await getCurrentUserEmail();

    SavedSurvey savedSurvey = SavedSurvey(results, lastStepAnsweredId, userEmail, surveyId);
    await SurveyPreferences().saveSurvey(savedSurvey);
    //markSurveyAsStarted();

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

  Widget buildSurvey(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    if(snapshot.hasError){
      print("The error in snapshot is");
      print(snapshot.error);
      return Text("Se ha producido un error.");

    } else if(snapshot.connectionState == ConnectionState.done) {
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

Map<String, dynamic> rPOrderedTaskToJson(RPOrderedTask instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('identifier', instance.identifier);
  writeNotNull('close_after_finished', instance.closeAfterFinished);

  List<RPStep> steps = instance.steps;
  StringBuffer concatenatedSteps = new StringBuffer();
  for(int i = 0; i < steps.length; i++) {
    var jsonStep = RPStepToJson(steps[i]);
    String aux = jsonEncode(jsonStep);
    concatenatedSteps.write(aux);
  }
  String resul = concatenatedSteps.toString();
  writeNotNull('steps', resul);

  return val;
}

Map<String, dynamic> RPStepToJson(RPStep instance) {
  final val = <String, dynamic>{};
if(instance == null) return val;
  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('identifier', instance.identifier);
  writeNotNull('title', instance.title);
  writeNotNull('text', instance.text);
  writeNotNull('optional', instance.optional);
  return val;
}

Future<RPOrderedTask> getTaskAsync(RPOrderedTask wholeTask) async {
  if(wholeTask == null){
    print("the whole task is null");
    return linearSurveyTask;
  }
  String surveyId = wholeTask.identifier;
  String userEmail = await getCurrentUserEmail();
  SavedSurvey survey = await SurveyPreferences().getSavedSurvey(userEmail, surveyId);
  String token = await UserPreferences.getToken();
  if(survey == null) {

    if(wholeTask == null) throw Exception("wholetask es null");
    return wholeTask;
  } else {
    print("survey found for this user and survey ID");
    print(survey.lastStepAnsweredId);// a veces esta vacio
    List<RPStep> finalSteps = [];
    RPStep lastStepAnswered = wholeTask.getStepWithIdentifier(survey.lastStepAnsweredId);// si esta vacio pues devuelve null
    RPStep aux = wholeTask.getStepAfterStep(lastStepAnswered, null);// cuando es null devuelve el primero
    while(aux != null) {
      print("A ver cuantos pasos me metes");
      print(aux.identifier);
      finalSteps.add(aux);
      aux = wholeTask.getStepAfterStep(aux, null);
    }
    print("Returning this");
    print(new RPOrderedTask(surveyId, finalSteps));

    RPOrderedTask resultadito = new RPOrderedTask(surveyId, finalSteps);
    if(resultadito == null) throw Exception("resultadito es null");

    return resultadito;
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
