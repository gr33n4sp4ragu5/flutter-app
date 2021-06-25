class User {

  String token;
  String refreshToken;
  DateTime tokenExpiration;
  DateTime refreshTokenExpiration;

  User({this.token, this.refreshToken, this.tokenExpiration, this.refreshTokenExpiration});

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
        token: responseData['access_token'],
        refreshToken: responseData['refresh_token'],
        tokenExpiration: DateTime.now().add(Duration(seconds: responseData["token_expires_in"])),
        refreshTokenExpiration: DateTime.now().add(Duration(seconds: responseData["refresh_expires_in"]))
    );
  }
}
