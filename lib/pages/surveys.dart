import 'package:collective_intelligence_metre/domain/CIMSurvey.dart';
import 'package:collective_intelligence_metre/surveys/surveys_preloaded.dart';
import 'package:collective_intelligence_metre/util/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';

class Surveys extends StatefulWidget {
  PreloadedSurveys preloadedSurveys = new PreloadedSurveys();
  

  @override
  _SurveysState createState() => _SurveysState();
}

class _SurveysState extends State<Surveys> {
  Future<dynamic> _preloaded_surveys;

  @override
  initState() {
    super.initState();
    _preloaded_surveys = getFinishedSurveys();
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _preloaded_surveys,
      builder: populateSurveys,
    );
  }

  Future<dynamic> getFinishedSurveys() {
    return auxFunction();
  }

  auxFunction() async {
    PreloadedSurveys preloadedSurveys = widget.preloadedSurveys;
    await preloadedSurveys.preloadSurveys();
    return preloadedSurveys;
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
    available_surveys.forEach((element) {formattedSurveys.add(surveyToWidget(context, element.title, element.surveyPage));});
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
          setState(() {
            _preloaded_surveys = getFinishedSurveys();
          });
        },
        enabled: enabled,
      ),
    );
  }
  
}
