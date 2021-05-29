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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted),
            label: 'Encuestas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.watch),
            label: 'Actividad',
          ),
      //    BottomNavigationBarItem(
      //      icon: Icon(Icons.insert_chart),
       //     label: 'Estadísticas',
       //   ),
        ],
        currentIndex: 1,
        selectedItemColor: Colors.amber[800],
        //onTap: _onItemTapped,
      ),
    );
  }
}
