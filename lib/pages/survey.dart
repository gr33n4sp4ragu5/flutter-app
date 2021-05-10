import 'package:flutter/material.dart';
import 'package:collective_intelligence_metre/domain/user.dart';
import 'package:collective_intelligence_metre/providers/user_provider.dart';
import 'package:provider/provider.dart';

class Survey extends StatelessWidget {
  final User user;

  Survey({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<UserProvider>(context).setUser(user);

    return Scaffold(
      body: Container(
        child: Center(
          child: Text("Comienza a responder una encuesta"),
        ),
      ),
    );
  }
}
