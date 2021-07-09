import 'dart:convert';

import 'package:collective_intelligence_metre/util/shared_preference.dart';
import 'package:http/http.dart';

import 'app_url.dart';

getCurrentUserEmail() async {
  String token = await UserPreferences.getToken();
  print("The token is:");
  print(token);

  Response response = await get(AppUrl.getProfileData,
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer ' + token });
  final Map<String, dynamic> responseData = json.decode(response.body)["profile_data"];
  return responseData['email'];
}