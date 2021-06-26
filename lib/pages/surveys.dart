import 'package:collective_intelligence_metre/domain/CIMSurvey.dart';
import 'package:collective_intelligence_metre/surveys/surveys_preloaded.dart';
import 'package:flutter/material.dart';

class Surveys extends StatefulWidget {
  @override
  _SurveysState createState() => _SurveysState();
}

class _SurveysState extends State<Surveys> {
  PreloadedSurveys preloadedSurveys = new PreloadedSurveys();

  void updatePreloadedSurveysState() async {
    PreloadedSurveys aux =  await getPreloadedSurveys();
    setState(() {preloadedSurveys = aux;});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getPreloadedSurveys(),
      builder: populateSurveys,
    );
  }

  Future<PreloadedSurveys> getPreloadedSurveys() async {
    PreloadedSurveys preloadedSurveys = this.preloadedSurveys;
    await preloadedSurveys.preloadSurveys();
    return preloadedSurveys;
  }

  List<Widget> formatAvailableSurveys(BuildContext context) {
    PreloadedSurveys preloadedSurveys = this.preloadedSurveys;
    preloadedSurveys.preloadSurveys();
    List<CIMSurvey> surveys = preloadedSurveys.preloaded_surveys;
    List<CIMSurvey> available_surveys = surveys.where((survey) => SurveyState.NEW == survey.state).toList();
    List<Widget> formattedSurveys = [
      Text(
        "Encuestas disponibles",
        style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5),
      )];
    available_surveys.forEach((element) {formattedSurveys.add(surveyToWidget(context, element.title, element.surveyPage));});
    return formattedSurveys;
  }

  List<Widget> formatUnavailableSurveys(BuildContext context) {
    List<CIMSurvey> surveys = this.preloadedSurveys.preloaded_surveys;
    List<CIMSurvey> finished_surveys = surveys.where((survey) => SurveyState.FINISHED == survey.state).toList();
    List<Widget> formattedSurveys = [
      Text(
        "Encuestas finalizadas",
        style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5),
      )];
    finished_surveys.forEach((element) {formattedSurveys.add(surveyToWidget(context, element.title, element.surveyPage, enabled: false));});
    return formattedSurveys;
  }

  Widget populateSurveys(BuildContext context, AsyncSnapshot snapshot) {
    if(snapshot.connectionState == ConnectionState.done){
      return ListView(
          children: [
            ...formatAvailableSurveys(context), ...formatUnavailableSurveys(context)
          ]);
    } else {
      return  Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          Text(" Guardando los cambios... Por favor espere")
        ],
      );
    }
  }

  Widget surveyToWidget(BuildContext context, title, surveyPage, {bool enabled=true}) {
    return Card(
      child: ListTile(
        title: Text(title),
        tileColor: Color(0xFF36ABC4),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => surveyPage),
          );
          updatePreloadedSurveysState();
        },
        enabled: enabled,
      ),
    );
  }
  
}
