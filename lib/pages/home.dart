import 'package:collective_intelligence_metre/pages/linear_survey_page.dart';
import 'package:collective_intelligence_metre/pages/tds.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ColIntMet'),
      ),
      body: Column(
        children: [
          ElevatedButton(
          child: Text('Comienza a responder una encuesta'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LinearSurveyPage()),
            );
          },
        ),
          ElevatedButton(
            child: Text('Comienza a responder una encuesta'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TDSSurveyPage()),
              );
            },
          ),
        ]
      ),
    );
  }
}
