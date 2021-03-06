import 'package:collective_intelligence_metre/pages/health_data.dart';
import 'package:flutter/material.dart';
import 'package:collective_intelligence_metre/pages/home.dart';
import 'package:collective_intelligence_metre/pages/login.dart';
import 'package:collective_intelligence_metre/pages/register.dart';
import 'package:collective_intelligence_metre/providers/auth.dart';
import 'package:collective_intelligence_metre/providers/user_provider.dart';
import 'package:collective_intelligence_metre/util/shared_preference.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:research_package/research_package.dart';

import 'domain/user.dart';
import 'pages/linear_survey_page.dart';

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
          supportedLocales: [
            Locale('en'),
            Locale('es'),
          ],
          localizationsDelegates: [
            // A class which loads the translations from JSON files
            RPLocalizations.delegate,
            // Built-in localization of basic text for Cupertino widgets
            GlobalCupertinoLocalizations.delegate,
            // Built-in localization of basic text for Material widgets
            GlobalMaterialLocalizations.delegate,
            // Built-in localization for text direction LTR/RTL
            GlobalWidgetsLocalizations.delegate,
          ],
          // Returns a locale which will be used by the app
          localeResolutionCallback: (locale, supportedLocales) {
            // Check if the current device locale is supported
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale.languageCode
              /*  && supportedLocale.countryCode == locale.countryCode */
              // TODO: Test on physical iPhone if Locale should use countryCode instead
              ) {
                return supportedLocale;
              }
            }
            // If the locale of the device is not supported, use the first one
            // from the list (English, in this case).
            return supportedLocales.first;
          },
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
                    return Home();
                }
              }),
          routes: {
            '/survey': (context) => LinearSurveyPage(),
            '/login': (context) => Login(),
            '/register': (context) => Register(),
            '/home': (context) => Home(),
            '/health': (context) => HealthData(),
          }),
    );
  }
}
