class AppUrl {
  static const String liveBaseURL = "http://138.4.110.213:8000";
  static const String localBaseURL = "http://192.168.56.101:8000";

  static const String baseURL = liveBaseURL;
  static const String login = baseURL + "/login/";
  static const String register = baseURL + "/login/register";
  static const String forgotPassword = baseURL + "/login/forgot-password";
}
