import 'package:collective_intelligence_metre/pages/linear_survey_page.dart';
import 'package:collective_intelligence_metre/pages/login.dart';
import 'package:collective_intelligence_metre/pages/profile.dart';
import 'package:collective_intelligence_metre/pages/surveys.dart';
import 'package:collective_intelligence_metre/pages/health_data.dart';
import 'package:collective_intelligence_metre/pages/tds.dart';
import 'package:collective_intelligence_metre/util/shared_preference.dart';
import 'package:flutter/material.dart';

/// This is the stateful widget that the main application instantiates.
class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static  List<Widget> _widgetOptions = <Widget>[
    Profile(),
    Surveys(),
    HealthData()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ColIntMet'),
        actions: <Widget>[
          IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            UserPreferences().removeUser();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Login()),
            );
          },
        )]
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
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
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

