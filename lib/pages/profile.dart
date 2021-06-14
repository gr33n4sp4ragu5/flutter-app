import 'dart:async';
import 'dart:convert';

import 'package:collective_intelligence_metre/util/app_url.dart';
import 'package:collective_intelligence_metre/util/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:collective_intelligence_metre/providers/auth.dart';
import 'package:collective_intelligence_metre/util/validators.dart';
import 'package:collective_intelligence_metre/util/widgets.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:collective_intelligence_metre/util/constants.dart';
import 'package:collective_intelligence_metre/pages/register.dart';

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

  Future<Map<String, dynamic>> getProfileData() async {

    String token = await UserPreferences.getToken();
    print("The token is:");
    print(token);

    return await get(AppUrl.getProfileData,
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer ' + token })
        .then(assignValues)
        .catchError(onError);
  }

  assignValues(Response response) {
    print("assigning values yea");
    var result;
    print(response.body);
    print(response.statusCode);
    final Map<String, dynamic> responseData = json.decode(response.body)["profile_data"];
    print(responseData);
    setState(() => this._email = responseData["email"]);
    setState(() => _name = responseData["name"]);
    setState(() => _surnames = responseData["surnames"]);
    setState(() => _birthdate = DateTime.parse(responseData["birthdate"]));
    setState(() =>  _gender = Gender(responseData["gender"]));
    print(_email);
    print(_name);
    print(_surnames);
    print(_birthdate);
    print(_gender);

    if (response.statusCode == 200) {
      print("200 code yay");

      result = {
        'status': true,
        'message': 'Profile successfully updated'
      };
    } else {
      print("no success bad");
      result = {
        'status': false,
        'message': 'Failed to update profile',
        'data': responseData
      };
    }

    return result;
  }

  Map<String, dynamic> getChanges() {
    return {"name": "Alberto"};
  }

  Future<Map<String, dynamic>> modifyProfileData() async {

    final Map<String, dynamic> survey_data = getChanges();

    String token = await UserPreferences.getToken();

    return await put(AppUrl.modifyProfileData,
        body: json.encode(survey_data),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer ' + token })
        .then(onValue)
        .catchError(onError);
  }

  static Future<FutureOr> onValue(Response response) async {
    var result;
    final Map<String, dynamic> responseData = json.decode(response.body);

    print(response.statusCode);
    if (response.statusCode == 200) {

      result = {
        'status': true,
        'message': 'Profile successfully updated'
      };
    } else {
      result = {
        'status': false,
        'message': 'Failed to update profile',
        'data': responseData
      };
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
    getProfileData();
    selectedDate = DateTime(1990);
    _email = "pruebilla@gmail.com";
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    final emailField = TextFormField(
      autofocus: false,
      validator: validateEmail,
      onSaved: (value) => _email = value,
      decoration: buildInputDecoration(ENTER_EMAIL, Icons.email),
      initialValue: _email,
    );

    final nameField = TextFormField(
      autofocus: false,
      validator: validateName,
      onSaved: (value) => _name = value,
    );

    final surnamesField = TextFormField(
      autofocus: false,
      validator: validateName,
      onSaved: (value) => _surnames = value,
      initialValue: _surnames,
    );

    final birthdateField = InputDatePickerFormField(
      firstDate: DateTime(1900),
      lastDate: DateTime(2005),
      initialDate: selectedDate,
      onDateSubmitted: (date) {
        setState(() {
          selectedDate = date;
        });
      },
    );

    final male = Radio(
        value: 1,
        groupValue: _genderSelectedValue,
        onChanged: (T) {
          _gender = new Gender('male');
          setState(() {
            print(T);
            _genderSelectedValue = T;
          });
        }
    );
    final female = Radio(
        value: 2,
        groupValue: _genderSelectedValue,
        onChanged: (T) {
          _gender = new Gender('female');
          setState(() {
            print(T);
            _genderSelectedValue = T;
          });
        }
    );

    final other = Radio(
        value: 3,
        groupValue: _genderSelectedValue,
        onChanged: (T) {
          _gender = new Gender('other');
          setState(() {
            print(T);
            _genderSelectedValue = T;
          });
        }
    );

    final maleRadioButton = ListTile(
        title: const Text('Hombre'),
        leading: male
    );

    final femaleRadioButton = ListTile(
        title: const Text('Mujer'),
        leading: female
    );

    final otherRadioButton = ListTile(
        title: const Text('Prefiero no contestar'),
        leading: other
    );


    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Guardando los cambios... Por favor espere")
      ],
    );

    

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
                    label("Seleccione su sexo:"),
                    SizedBox(height: 10.0),
                    maleRadioButton,
                    SizedBox(height: 10.0),
                    femaleRadioButton,
                    SizedBox(height: 20.0),
                    otherRadioButton,
                    longButtons("Guardar cambios", modifyProfileData),
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
  }
}

