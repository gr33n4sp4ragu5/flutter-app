import 'dart:async';
import 'dart:convert';

import 'package:collective_intelligence_metre/pages/register.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:collective_intelligence_metre/domain/user.dart';
import 'package:collective_intelligence_metre/util/app_url.dart';
import 'package:collective_intelligence_metre/util/shared_preference.dart';


enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  Registering,
  LoggedOut
}

class AuthProvider with ChangeNotifier {

  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredInStatus = Status.NotRegistered;

  Status get loggedInStatus => _loggedInStatus;
  Status get registeredInStatus => _registeredInStatus;


  Future<Map<String, dynamic>> login(String email, String password) async {
    var result;

    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$email:$password'));

    Response response = await get(
        AppUrl.login,
        headers: <String, String>{'authorization': basicAuth});
    print(response.statusCode);
    print(response.body);

    _loggedInStatus = Status.Authenticating;
    notifyListeners();

    return onUserAuthentication(response, result);
  }

  Future<Map<String, dynamic>> register(String email, String password, String name, String surnames,
      DateTime birthdate, Gender gender) async {

    final Map<String, dynamic> registrationData = {
        'email': email,
        'password': password,
        'name': name,
        'surnames': surnames,
        'birthdate': birthdate.toIso8601String().substring(0, 10),
        'gender': gender.gender
    };

    return await post(AppUrl.register,
        body: json.encode(registrationData),
        headers: {'Content-Type': 'application/json'})
        .then(onValue)
        .catchError(onError);
  }

  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {

    final Map<String, dynamic> registrationData = {
      'refresh_token': refreshToken
    };

    Response response = await post(AppUrl.refreshToken,
        body: json.encode(registrationData),
        headers: {'Content-Type': 'application/json'});

    _loggedInStatus = Status.Authenticating;
    notifyListeners();
    var result;
    return onUserAuthentication(response, result);
    
  }

  onUserAuthentication(Response response, result) {
    print(response.body);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
    
      User authUser = User.fromJson(responseData);
    
      UserPreferences().saveUser(authUser);
    
      _loggedInStatus = Status.LoggedIn;
      notifyListeners();
    
      result = {'status': true, 'message': 'Successful', 'user': authUser};
    } else {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
      result = {
        'status': false,
        'message': json.decode(response.body)['error']
      };
    }
    return result;
  }

  static Future<FutureOr> onValue(Response response) async {
    var result;
    final Map<String, dynamic> responseData = json.decode(response.body);

    print(response.statusCode);
    if (response.statusCode == 201) {

      result = {
        'status': true,
        'message': 'Successfully registered'
      };
    } else {
      result = {
        'status': false,
        'message': 'Registration failed',
        'data': responseData
      };
    }

    return result;
  }

  static onError(error) {
    print("the error is $error.detail");
    return {'status': false, 'message': 'Unsuccessful Request', 'data': error};
  }

}
