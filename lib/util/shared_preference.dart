import 'package:collective_intelligence_metre/domain/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class UserPreferences {
  Future<void> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", user.token);
    prefs.setString("refreshToken", user.refreshToken);
    prefs.setString("tokenExpiration", user.tokenExpiration.toIso8601String());
    prefs.setString("refreshTokenExpiration", user.refreshTokenExpiration.toIso8601String());
  }

  Future<User> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime tokenExpiration = getTokenExpiration(prefs, 'tokenExpiration');
    DateTime refreshTokenExpiration = getTokenExpiration(prefs, 'refreshTokenExpiration');
    String token = prefs.getString("token");
    String refreshToken = prefs.getString("refreshToken");

    return User(
        token: token,
        refreshToken: refreshToken,
        tokenExpiration: tokenExpiration,
        refreshTokenExpiration: refreshTokenExpiration
    );
  }

  DateTime getTokenExpiration(SharedPreferences prefs, String prefsProperty) {
    String tokenExpirationPref = prefs.get(prefsProperty);
    if(tokenExpirationPref == null) {
      return null;
    } else {
      return DateTime.parse(tokenExpirationPref);
    }
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
