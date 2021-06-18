import 'package:collective_intelligence_metre/domain/CIMSurvey.dart';
import 'package:collective_intelligence_metre/surveys/surveys_preloaded.dart';
import 'package:flutter/material.dart';

class Surveys extends StatefulWidget {
  PreloadedSurveys preloadedSurveys = new PreloadedSurveys();

  @override
  _SurveysState createState() => _SurveysState();
}

class _SurveysState extends State<Surveys> {
  @override
  Widget build(BuildContext context) {
    return ListView(
          children: [
          ...formatAvailableSurveys(context), ...formatUnavailableSurveys(context)
          ]);
  }

  List<Widget> formatAvailableSurveys(BuildContext context) {
    PreloadedSurveys preloadedSurveys = widget.preloadedSurveys;
    preloadedSurveys.preloadSurveys();
    List<CIMSurvey> surveys = preloadedSurveys.preloaded_surveys;
    print("Las encuestas cargadas son");
    print(surveys.toString());
    List<CIMSurvey> available_surveys = surveys.where((survey) => SurveyState.NEW == survey.state).toList();
    List<Widget> formattedSurveys = [
      Text(
        "Encuestas disponibles",
        style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5),
    )];
    available_surveys.forEach((element) {formattedSurveys.add(element.toWidget(context));});
    return formattedSurveys;
  }

  List<Widget> formatUnavailableSurveys(BuildContext context) {
    List<CIMSurvey> surveys = widget.preloadedSurveys.preloaded_surveys;
    List<CIMSurvey> finished_surveys = surveys.where((survey) => SurveyState.FINISHED == survey.state).toList();
    List<Widget> formattedSurveys = [
      Text(
        "Encuestas finalizadas",
        style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5),
      )];
    finished_surveys.forEach((element) {formattedSurveys.add(element.toWidget(context, enabled: false));});
    return formattedSurveys;
  }
}
