import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../main.dart';

void scheduleNotification() async {
  print("Notificacion scheduleada");
  var scheduledNotificationDateTime = DateTime.now().add(Duration(seconds: 10));
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'alarm_notif',
    'alarm_notif',
    'Channel for Alarm notification',
    icon: 'colintmet_logo',
    sound: RawResourceAndroidNotificationSound('notification'),
    largeIcon: DrawableResourceAndroidBitmap('colintmet_logo'),
  );

  var iOSPlatformChannelSpecifics = IOSNotificationDetails(
      sound: 'notification.wav',
      presentAlert: true,
      presentBadge: true,
      presentSound: true);
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.schedule(0, 'Colintmet','Por favor accede a la app para enviar tus datos',
      scheduledNotificationDateTime, platformChannelSpecifics);
}

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
