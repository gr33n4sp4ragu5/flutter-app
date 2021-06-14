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
      print(profile_data.runtimeType);
      emailController.text = profile_data["email"];
      nameController.text = profile_data["name"];
      surnamesController.text = profile_data["surnames"];

      return profile_data;

    });
  }

  deserializeProfileData(Response response) {
    final Map<String, dynamic> responseData = json.decode(response.body)["profile_data"];
    return responseData;
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
    _profileData = getProfileData();
    selectedDate = DateTime(1990);
    _email = "pruebilla@gmail.com";
  }
  Widget populateForm(BuildContext context, AsyncSnapshot snapshot) {
    final emailField = TextFormField(
      autofocus: false,
      validator: validateEmail,
      onSaved: (value) => _email = value,
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

  @override
  Widget build(BuildContext context) {
    //AuthProvider auth = Provider.of<AuthProvider>(context);
/*
    final emailField = TextFormField(
      autofocus: false,
      validator: validateEmail,
      onSaved: (value) => _email = value,
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

/*
    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Guardando los cambios... Por favor espere")
      ],
    );

 */

 */

    return FutureBuilder(
      future: _profileData,
      builder: populateForm,
    );

/*
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

    */
  }
}

