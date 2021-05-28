import 'dart:async';

import 'package:collective_intelligence_metre/util/app_url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:research_package/research_package.dart';
import 'package:collective_intelligence_metre/util/shared_preference.dart';
import '../research_package_objects/linear_survey_objects.dart';
import 'dart:convert';

class LinearSurveyPage extends StatelessWidget {
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
        .then(onValue)
        .catchError(onError);
  }
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
  Widget build(BuildContext context) {
    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
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
        task: linearSurveyTask,
        onSubmit: (result) {
          resultCallback(result);
        },
        onCancel: ([res]) => print('survey canceled'),
        // No onCancel
        // If there's no onCancel provided the survey just quits
      ),
    );
  }
}
