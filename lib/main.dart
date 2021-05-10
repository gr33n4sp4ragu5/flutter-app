import 'package:flutter/material.dart';
import 'package:collective_intelligence_metre/pages/survey.dart';
import 'package:collective_intelligence_metre/pages/login.dart';
import 'package:collective_intelligence_metre/pages/register.dart';
import 'package:collective_intelligence_metre/providers/auth.dart';
import 'package:collective_intelligence_metre/providers/user_provider.dart';
import 'package:collective_intelligence_metre/util/shared_preference.dart';
import 'package:provider/provider.dart';

import 'domain/user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<User> getUserData() => UserPreferences().getUser();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
          title: 'Collective Intelligence Metre',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: FutureBuilder(
              future: getUserData(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return CircularProgressIndicator();
                  default:
                    if (snapshot.hasError)
                      return Text('Error: ${snapshot.error}');
                    else if (snapshot.data.token == null)
                      return Login();
                    else
                      UserPreferences().removeUser();
                    return Survey(user: snapshot.data);
                }
              }),
          routes: {
            '/login': (context) => Login(),
            '/register': (context) => Register(),
          }),
    );
  }
}
