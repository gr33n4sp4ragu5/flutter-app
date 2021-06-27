import 'dart:convert';

import 'package:collective_intelligence_metre/domain/saved_survey.dart';
import 'package:collective_intelligence_metre/domain/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class UserPreferences {
  Future<void> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", user.token);
    prefs.setString("refreshToken", user.refreshToken);
  }

  Future<User> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString("token");
    String refreshToken = prefs.getString("refreshToken");

    return User(
        token: token,
        refreshToken: refreshToken);
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("token");
    prefs.remove("refreshToken");
  }

  static Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    return token;
  }
}

class SurveyPreferences {
  Future<void> saveSurvey(SavedSurvey savedSurvey) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = savedSurvey.userEmail +  savedSurvey.surveyId;
    prefs.setString(key, json.encode(savedSurvey));
  }

  Future<void> removeSavedSurvey(String email, String surveyId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(email + surveyId);
  }

  Future<SavedSurvey> getSavedSurvey(String email, String surveyId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey(email + surveyId)){
      String encodedSurvey = prefs.getString(email + surveyId);
      Map<String, dynamic> decodedSurvey = jsonDecode(encodedSurvey);

      return SavedSurvey.FromJson(decodedSurvey);
    } else {
      return null;
    }
  }

}
