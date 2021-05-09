class User {

  String token;
  String refreshToken;

  User({this.token, this.refreshToken});

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
        token: responseData['access_token'],
        refreshToken: responseData['refresh_token']
    );
  }
}
