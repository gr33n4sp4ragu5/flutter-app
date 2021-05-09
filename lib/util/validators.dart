String validateEmail(String value) {
  String _msg;
  RegExp regex = new RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  if (value.isEmpty) {
    _msg = "Email requerido";
  } else if (!regex.hasMatch(value)) {
    _msg = "Por favor introduzca un email válido";
  }
  return _msg;
}

String validateName(String value) {
  String _msg;
  RegExp regex = new RegExp(
      r'[a-z A-záéíóú-]*');
  if (value.isEmpty) {
    _msg = "Este campo es obligatorio";
  } else if (!regex.hasMatch(value)) {
    _msg = "Introduzca un nombre válido";
  }
  return _msg;
}
