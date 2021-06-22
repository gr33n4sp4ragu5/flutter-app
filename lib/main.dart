import 'package:collective_intelligence_metre/constants/constants.dart';
import 'package:collective_intelligence_metre/util/notifications.dart';
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
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'domain/user.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    initializeNotifications(flutterLocalNotificationsPlugin, selectNotification);
  }

  Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    navigatorKey.currentState.pushNamed("/health");
  }

  @override
  Widget build(BuildContext context) {
    Future<User> getUserData() => UserPreferences().getUser();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
          navigatorKey: navigatorKey,
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
                    return Home(defaultIndex: PROFILE_INDEX);
                }
              }),
          routes: {
            '/survey': (context) => Home(defaultIndex: SURVEYS_INDEX),
            '/login': (context) => Login(),
            '/register': (context) => Register(),
            '/home': (context) => Home(defaultIndex: PROFILE_INDEX),
            '/health': (context) => Home(defaultIndex: HEALTH_DATA_INDEX),
          }),
    );
  }
}
