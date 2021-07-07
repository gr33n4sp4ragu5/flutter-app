import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:collective_intelligence_metre/providers/auth.dart';
import 'package:collective_intelligence_metre/util/validators.dart';
import 'package:collective_intelligence_metre/util/widgets.dart';
import 'package:provider/provider.dart';
import 'package:collective_intelligence_metre/util/constants.dart';

class Gender {
  static final Set<String> allowedGenders = Set.unmodifiable({"male", "female", "other"});
  String gender;
  Gender(String gender){
    if(allowedGenders.contains(gender.toLowerCase())) {
      this.gender = gender.toLowerCase();
    } else {
      throw new Exception("Not allowed gender: " + gender);
    }
  }
}

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = new GlobalKey<FormState>();

  String _email, _password, _name, _surnames;
  DateTime _birthdate;
  Gender _gender;
  int _genderSelectedValue = 0;
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _birthdate,
        firstDate: DateTime(1920),
        lastDate: DateTime(2101));
    if (picked != null && picked != _birthdate)
      setState(() {
        _birthdate = picked;
      });
  }

  @override
  initState() {
    super.initState();
    _birthdate = DateTime(1990);
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    final emailField = TextFormField(
      autofocus: false,
      validator: validateEmail,
      onSaved: (value) => _email = value,
      decoration: buildInputDecoration(ENTER_EMAIL, Icons.email),
    );

    final passwordField = TextFormField(
      autofocus: false,
      obscureText: true,
      controller: _pass,
      validator: (value) => value.isEmpty ? PLEASE_ENTER_PASSWORD : null,
      onSaved: (value) => _password = value,
      decoration: buildInputDecoration(ENTER_PASSWORD, Icons.lock),
    );

    final confirmPassword = TextFormField(
      autofocus: false,
      controller: _confirmPass,
      validator: (value) {
        if(value.isEmpty)
          return PLEASE_ENTER_PASSWORD;
        if(value != _pass.text)
          return 'Las contraseñas deben ser iguales';
        return null;
    },
      obscureText: true,
      decoration: buildInputDecoration(CONFIRM_PASSWORD, Icons.lock),
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
    );

    final birthdateField = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("${_birthdate.toLocal()}".split(' ')[0]),
          SizedBox(height: 20.0,),
          ElevatedButton(
            onPressed: () => _selectDate(context),
            child: Text('Seleccionar fecha'),
          ),
        ],
      ),
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
        Text(" Registrándose... Por favor espere")
      ],
    );

    var doRegister = () {
      final form = formKey.currentState;
      if (form.validate() && _genderSelectedValue > 0) {
        form.save();
        auth.register(_email, _password, _name, _surnames, _birthdate, _gender).then((response) {
          if (response['status']) {
            final snackBar = SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.account_circle_rounded,
                    color: Colors.green),
                    SizedBox(width: 20),
                    Expanded(
                      child: Text('Registrado con éxito')
                    )
                  ],

                )

            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            Navigator.pushReplacementNamed(context, '/login');
          } else {
            Flushbar(
              title: "El registro fracasó",
              message: response.toString(),
              duration: Duration(seconds: 10),
            ).show(context);
          }
        });
      } else {
        Flushbar(
          title: "Formulario inválido",
          message: "Por favor complete el formulario correctamente",
          duration: Duration(seconds: 10),
        ).show(context);
      }

    };

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
                  label("Contraseña"),
                  SizedBox(height: 10.0),
                  passwordField,
                  SizedBox(height: 15.0),
                  label("Confirmar contraseña"),
                  SizedBox(height: 10.0),
                  confirmPassword,
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
                  auth.loggedInStatus == Status.Authenticating
                      ? loading
                      : longButtons("Registrarse", doRegister),
                ],
              ),
            )

          ),
        ),
      ),
    );
  }
}
