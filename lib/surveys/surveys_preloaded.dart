import 'dart:convert';

import 'package:collective_intelligence_metre/domain/CIMSurvey.dart';
import 'package:collective_intelligence_metre/util/app_url.dart';
import 'package:collective_intelligence_metre/util/errors.dart';
import 'package:collective_intelligence_metre/util/shared_preference.dart';
import 'package:http/http.dart';

import '../pages/linear_survey_page.dart';
import '../pages/tds.dart';

class PreloadedSurveys {
  List<CIMSurvey> preloaded_surveys = [];

  void preloadSurveys() async {
    List<CIMSurvey>  surveys = [];
    SurveyState read_mid_eyes_survey_state = await getCurrentSurveyState("surveyTaskID");
    SurveyState tds_state = await getCurrentSurveyState("surveyTDS");
    CIMSurvey read_mind_eyes = new CIMSurvey(LinearSurveyPage(), "surveyTaskID", read_mid_eyes_survey_state, "ninguno", "Reading the mind in the eyes");
    CIMSurvey team_diagnostic_survey = new CIMSurvey(TDSSurveyPage(), "surveyTDS"
        "", tds_state, "ninguno", "Team Diagnostic Survey");
    surveys.add(read_mind_eyes);
    surveys.add(team_diagnostic_survey);
    preloaded_surveys = surveys;
  }

  Future<SurveyState> getCurrentSurveyState(String surveyId) async {
    String token = await UserPreferences.getToken();

    final finished_surveys = await get(AppUrl.getFinishedSurveys,
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer ' + token })
        .then(deserializeFInishedSurveysResponse)
        .catchError(onError);
    final activated_surveys = await get(AppUrl.getActivatedSurveys,
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer ' + token })
        .then(deserializeFInishedSurveysResponse)
        .catchError(onError);
    if (finished_surveys.contains(surveyId)) {
      return SurveyState.FINISHED;
    } else if (activated_surveys.contains(surveyId)){
      return SurveyState.AVAILABLE;
    } else {
      return SurveyState.NOT_ACTIVATED;
    }
  }

  List deserializeFInishedSurveysResponse(Response response) {
    final List finished_surveys = json.decode(response.body)["finished_surveys"];
    print("finished_surveys");
    print(finished_surveys);
    return finished_surveys;
  }

  List deserializeActivatedSurveysResponse(Response response) {
    final List activated_surveys = json.decode(response.body)["activated_surveys"];
    print("activated_surveys");
    print(activated_surveys);
    return activated_surveys;
  }
}
