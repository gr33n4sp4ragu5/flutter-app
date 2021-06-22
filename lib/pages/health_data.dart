import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;
import 'package:collective_intelligence_metre/util/app_url.dart';
import 'package:http/http.dart';
import 'package:collective_intelligence_metre/util/shared_preference.dart';
import 'dart:convert';

import '../main.dart';

class HealthData extends StatefulWidget {
  @override
  _HealthDataState createState() => _HealthDataState();
}

enum AppState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTH_NOT_GRANTED
}

class _HealthDataState extends State<HealthData> {
  List<HealthDataPoint> _healthDataList = [];
  AppState _state = AppState.DATA_NOT_FETCHED;

  @override
  void initState() {
    super.initState();
  }

  Future fetchData() async {

    if (Platform.isAndroid) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.activityRecognition,
        Permission.sensors,
      ].request();

      print(statuses[Permission.activityRecognition]);
      print(statuses[Permission.sensors]);

    }
    
    DateTime startDate = DateTime(2021, 05, 20, 0, 0, 0);
    DateTime endDate = DateTime(2021, 05, 29, 23, 59, 59);


    HealthFactory health = HealthFactory();

    /// Define the types to get.
    List<HealthDataType> types = [
      HealthDataType.STEPS,
      HealthDataType.HEART_RATE
    ];

    setState(() => _state = AppState.FETCHING_DATA);

    /// You MUST request access to the data types before reading them
    bool accessWasGranted = await health.requestAuthorization(types);

    int steps = 0;

    if (accessWasGranted) {
      try {
        /// Fetch new data
        List<HealthDataPoint> healthData =
        await health.getHealthDataFromTypes(startDate, endDate, types);

        /// Save all the new data points
        _healthDataList.addAll(healthData);
      } catch (e) {
        print("Caught exception in getHealthDataFromTypes: $e");
      }

      /// Filter out duplicates
      _healthDataList = HealthFactory.removeDuplicates(_healthDataList);

      /// Print the results
      _healthDataList.forEach((x) {
        print("Data point: $x");
        steps += x.value.round();
      });

      print("Steps: $steps");

      ///Send the results to endpoint
      sendPhysiologicalData(_healthDataList);

      /// Update the UI to display the results
      setState(() {
        _state =
        _healthDataList.isEmpty ? AppState.NO_DATA : AppState.DATA_READY;
      });
    } else {
      print("Authorization not granted");
      setState(() => _state = AppState.DATA_NOT_FETCHED);
    }
  }

  Widget _contentFetchingData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(
              strokeWidth: 10,
            )),
        Text('Fetching data...')
      ],
    );
  }

  Widget _contentDataReady() {
    return ListView.builder(
        itemCount: _healthDataList.length,
        itemBuilder: (_, index) {
          HealthDataPoint p = _healthDataList[index];
          return ListTile(
            title: Text("${p.typeString}: ${p.value}"),
            trailing: Text('${p.unitString}'),
            subtitle: Text('${p.dateFrom} - ${p.dateTo}'),
          );
        });
  }

  Widget _contentNoData() {
    return Text('No se han encontrado datos');
  }

  Widget _contentNotFetched() {
    return Text('Pulsa el botón para compartir tus datos fisiológicos');
  }

  Widget _authorizationNotGranted() {
    return Text('''Authorization not given.
        For Android please check your OAUTH2 client ID is correct in Google Developer Console.
         For iOS check your permissions in Apple Health.''');
  }

  Widget _content() {
    if (_state == AppState.DATA_READY)
      return _contentDataReady();
    else if (_state == AppState.NO_DATA)
      return _contentNoData();
    else if (_state == AppState.FETCHING_DATA)
      return _contentFetchingData();
    else if (_state == AppState.AUTH_NOT_GRANTED)
      return _authorizationNotGranted();

    return _contentNotFetched();
  }

  Future<Map<String, dynamic>> sendPhysiologicalData(List<HealthDataPoint> formattedResult) async {

    final Map<String, dynamic> survey_data = {
      'formatted_result': getFormatedResult(formattedResult)
    };
    print(jsonEncode(survey_data));

    String token = await UserPreferences.getToken();

    return await post(AppUrl.sendPhysiologicalData,
        body: jsonEncode(survey_data),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer ' + token })
        .then(onValue)
        .catchError(onError);
  }

  List<Map<String, dynamic>> getFormatedResult (List<HealthDataPoint> rawResults) {
    return rawResults.map((raw_result) => serialize_result(raw_result)).toList();
  }

  Map<String, dynamic> serialize_result(HealthDataPoint raw_result) {
    return {
      'unit': raw_result.unitString,
      'value': raw_result.value,
      'date_from': raw_result.dateFrom.toString(),
      'date_to': raw_result.dateTo.toString(),
      'type': raw_result.typeString,
      'device_id': raw_result.deviceId,
      'platform': raw_result.platform.toString()
    };
  }

  static Future<FutureOr> onValue(Response response) async {
    var result;
    final Map<String, dynamic> responseData = json.decode(response.body);

    print(response.statusCode);
    if (response.statusCode == 201) {

      result = {
        'status': true,
        'message': 'Physiological data successfully sent'
      };
    } else {
      result = {
        'status': false,
        'message': 'Failed to send the physiological data',
        'data': responseData
      };
    }

    return result;
  }

  static onError(error) {
    print("the error is $error.detail");
    return {'status': false, 'message': 'Unsuccessful Request', 'data': error};
  }

  void scheduleNotification() async {
    print("Notificacion scheduleada");
    var scheduledNotificationDateTime = DateTime.now().add(Duration(seconds: 30));
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

  @override
  Widget build(BuildContext context) {
    return GridView.count(
            crossAxisCount: 1,
            children: [
              IconButton(
                icon: Icon(Icons.file_upload),
                onPressed: () {
                  fetchData();
                },
              ),
              IconButton(
                icon: Icon(Icons.notifications_active),
                onPressed: () {
                  scheduleNotification();
                },
              ),
              _content(),]
          );
  }
}