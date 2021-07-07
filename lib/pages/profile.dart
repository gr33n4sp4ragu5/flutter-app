import 'dart:async';
import 'dart:convert';

import 'package:collective_intelligence_metre/util/app_url.dart';
import 'package:collective_intelligence_metre/util/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:collective_intelligence_metre/util/validators.dart';
import 'package:collective_intelligence_metre/util/widgets.dart';
import 'package:http/http.dart';
import 'package:collective_intelligence_metre/util/constants.dart';
import 'package:collective_intelligence_metre/pages/register.dart';
import 'package:async/async.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final formKey = new GlobalKey<FormState>();

  String _email, _name, _surnames;
  DateTime _birthdate;
  Gender _gender;
  int _genderSelectedValue = 0;
  DateTime selectedDate;
  final AsyncMemoizer _memoizer = AsyncMemoizer();
  final emailController = new TextEditingController();
  final nameController = new TextEditingController();
  final surnamesController = new TextEditingController();
  final birthdateController = new TextEditingController();
  final genderController = new TextEditingController();
  Future<dynamic> _profileData;

// Only fetch data once and set its text value
// Setting it here ensures that the value doesn't go back
// to the stored user value on every widget rebuild

  Future<dynamic> getProfileData() {
    return this._memoizer.runOnce(() async {
      String token = await UserPreferences.getToken();
      print("The token is:");
      print(token);

      final profile_data = await get(AppUrl.getProfileData,
          headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer ' + token })
          .then(deserializeProfileData)
          .catchError(onError);
      print(profile_data);
      emailController.text = profile_data["email"];
      nameController.text = profile_data["name"];
      surnamesController.text = profile_data["surnames"];
      birthdateController.text = profile_data["birthdate"];
      genderController.text = translateGender(profile_data["gender"]);

      return profile_data;
    });
  }

  String translateGender(String gender) {
    switch(gender){
      case "male":
        return "H";
        break;
      case "female":
        return "M";
        break;
      case "other":
        return "N/A";
        break;
    }
  }

  deserializeProfileData(Response response) {
    //TODO- Add gender, birthdate and think if email can be changed
    final Map<String, dynamic> responseData = json.decode(response.body)["profile_data"];
    setState(() => _name = responseData["name"]);
    setState(() => _surnames = responseData["surnames"]);
    return responseData;
  }
  /*
    setState(() => this._email = responseData["email"]);
    setState(() => _birthdate = DateTime.parse(responseData["birthdate"]));
    setState(() =>  _gender = Gender(responseData["gender"]));
   */

  Map<String, dynamic> getChanges() {
    //TODO- send only the properties which changed
    //TODO- add biirthdate and gender
    return {"name": _name, "surnames": _surnames};
  }

  Future<Map<String, dynamic>> modifyProfileData() async {
    final form = formKey.currentState;
    form.save();

    final Map<String, dynamic> survey_data = getChanges();
    print(survey_data);

    String token = await UserPreferences.getToken();

    return await put(AppUrl.modifyProfileData,
        body: json.encode(survey_data),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer ' + token })
        .then(onValue)
        .catchError(onError);
  }

   Future<FutureOr> onValue(Response response) async {
    var result;
    final Map<String, dynamic> responseData = json.decode(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      result = {
        'status': true,
        'message': 'Profile successfully updated'
      };
      final snackBar = SnackBar(
          content: Row(
            children: [
              Icon(Icons.save,
                  color: Colors.white),
              SizedBox(width: 20),
              Expanded(
                  child: Text('Cambios guardados')
              )
            ],

          )

      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      result = {
        'status': false,
        'message': 'Failed to update profile',
        'data': responseData
      };
      final snackBar = SnackBar(
          content: Row(
            children: [
              Icon(Icons.error,
                  color: Colors.red),
              SizedBox(width: 20),
              Expanded(
                  child: Text('Error, los cambios no se han guardado')
              )
            ],

          )

      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    return result;
  }

  static onError(error) {
    print("the error is $error");
    return {'status': false, 'message': 'Unsuccessful Request', 'data': error};
  }
  
  @override
  initState() {
    super.initState();
    _profileData = getProfileData();
    selectedDate = DateTime(1990);
    _email = "pruebilla@gmail.com";
  }
  Widget populateForm(BuildContext context, AsyncSnapshot snapshot) {
    final emailField = TextFormField(
      autofocus: false,
      validator: validateEmail,
      enabled: false,
      decoration: buildInputDecoration(ENTER_EMAIL, Icons.email),
      controller: emailController,
    );

    final nameField = TextFormField(
      autofocus: false,
      validator: validateName,
      onSaved: (value) => _name = value,
      controller: nameController,
    );

    final surnamesField = TextFormField(
      autofocus: false,
      validator: validateName,
      onSaved: (value) => _surnames = value,
      controller: surnamesController,
    );

    final birthdateField = TextFormField(
      autofocus: false,
      validator: validateName,
      enabled: false,
      controller: birthdateController,
    );

    final genderField = TextFormField(
      autofocus: false,
      validator: validateName,
      enabled: false,
      controller: genderController,
    );


    if(snapshot.connectionState == ConnectionState.done){
      return SafeArea(
        child: Scaffold(
          body: Container(
            padding: EdgeInsets.all(40.0),
            child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: Icon(Icons.person, size: 100,),),
                      SizedBox(height: 15.0),
                      label("Email"),
                      SizedBox(height: 5.0),
                      emailField,
                      SizedBox(height: 15.0),
                      label("Fecha de nacimiento"),
                      SizedBox(height: 10.0),
                      birthdateField,
                      SizedBox(height: 15.0),
                      label("Nombre"),
                      SizedBox(height: 10.0),
                      nameField,
                      SizedBox(height: 15.0),
                      label("Apellidos"),
                      SizedBox(height: 10.0),
                      surnamesField,
                      SizedBox(height: 10.0),
                      label("Sexo:"),
                      genderField,
                      longButtons("Guardar cambios", modifyProfileData, icon: Icon(Icons.save)),
                      // auth.loggedInStatus == Status.Authenticating
                      //   ? loading
                      // : longButtons("Guardar cambios", modifyProfileData),
                    ],
                  ),
                )
            ),
          ),
        ),
      );
    } else {
      return  Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          Text(" Guardando los cambios... Por favor espere")
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _profileData,
      builder: populateForm,
    );
  }
}
