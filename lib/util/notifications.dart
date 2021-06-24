import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../main.dart';

const String CHANNEL_ID = "CHANNEL ID";
const String CHANNEL_NAME = "CHANNEL NAME";
const String LOGO = "colintmet_logo";
const String SOUND = "notification";


void initializeNotifications(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin, Function selectNotification) {
  const initializationSettingsAndroid =
  AndroidInitializationSettings('colintmet_logo');
  final IOSInitializationSettings initializationSettingsIOS =
  IOSInitializationSettings(
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {});
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS);

  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: selectNotification);
}

void scheduleRecurringNotification() async {
  print("Notificacion recurrente scheduleada");
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    CHANNEL_ID,
    CHANNEL_NAME,
    'Channel for Alarm notification',
    icon: 'colintmet_logo',
    priority: Priority.max,
    sound: RawResourceAndroidNotificationSound(SOUND),
    largeIcon: DrawableResourceAndroidBitmap(LOGO),
  );

  var iOSPlatformChannelSpecifics = IOSNotificationDetails(
      sound: 'notification.wav',
      presentAlert: true,
      presentBadge: true,
      presentSound: true);
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.periodicallyShow(0, 'Colintmet',
      'Por favor accede a la app para enviar tus datos',
      RepeatInterval.daily, platformChannelSpecifics,
      androidAllowWhileIdle: true);
}
