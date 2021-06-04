import 'package:collective_intelligence_metre/pages/linear_survey_page.dart';
import 'package:collective_intelligence_metre/pages/tds.dart';
import 'package:flutter/material.dart';

class Surveys extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
          children: [
            Text(
              "Encuestas disponibles",
              style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5),
            ),
            ListTile(
              title: Text('Reading the mind in the eyes'),
              tileColor: Color(0xFF36ABC4),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LinearSurveyPage()),
                );
              },
            ),
            ListTile(
              title: Text('Team Diagnostic Survey'),
              tileColor: Color(0xFF36ABC4),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TDSSurveyPage()),
                );
              },
            ),
          ]
      );
  }
}
