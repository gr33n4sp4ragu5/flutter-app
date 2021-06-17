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
            Text(
            "Encuestas disponibles",
            style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5),
          ),
          ...formatSurveys(context)
          ]);
  }

  List<Widget> formatSurveys(BuildContext context) {
    List<CIMSurvey> surveys = widget.preloadedSurveys.preloaded_surveys;
    List<Widget> formattedSurveys = [];
    surveys.forEach((element) {formattedSurveys.add(element.toWidget(context));});
    return formattedSurveys;
  }
}
