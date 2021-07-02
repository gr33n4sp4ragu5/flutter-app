import 'package:collective_intelligence_metre/util/save_survey.dart';
import 'package:flutter/material.dart';
import 'package:research_package/model.dart';
import 'package:research_package/ui.dart';

Widget buildSurvey(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
  bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
  if(snapshot.hasError){
    print("The error in snapshot is");
    print(snapshot.error);
    return Text("Se ha producido un error.");

  } else if(snapshot.connectionState == ConnectionState.done) {
    return Theme(
      data: isDarkMode
      // Dark mode
          ? ThemeData.dark()
      // Your styling
          : ThemeData(
        primaryColor: Colors.red,
        accentColor: Colors.green,
        backgroundColor: Colors.white,
        dividerColor: Colors.grey,
        textTheme: Typography.blackMountainView,
      ),
      child: RPUITask(
        task: snapshot.data,
        onSubmit: (result) {
          resultCallback(result);
        },
        onCancel: ([RPTaskResult results]) {
          saveResultsAsync(results);
        },
      ),
    );
  } else  if (snapshot.connectionState == ConnectionState.waiting){

    return Theme(
      data: isDarkMode
      // Dark mode
          ? ThemeData.dark()
      // Your styling
          : ThemeData(
        primaryColor: Colors.red,
        accentColor: Colors.green,
        backgroundColor: Colors.white,
        dividerColor: Colors.grey,
        textTheme: Typography.blackMountainView,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          Text(" Datos")
        ],
      ),
    );
  } else return Text(snapshot.connectionState.toString());

}
