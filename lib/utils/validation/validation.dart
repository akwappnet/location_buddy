String? nameValidator(String? value) {
  String pattern = r'^[a-z A-Z]+$';
  //RegExp(r'^[a-z A-Z]+$');
  RegExp regex = RegExp(pattern);

  if (value!.isEmpty) {
    return 'This field must be filled';
  } else if (value.length < 3) {
    return 'Please enter proper name';
  } else if (!regex.hasMatch(value)) {
    return 'Please enter on alphabets only';
  }
  return null;
}

String? emailValidator(String? value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern);

  if (value!.isEmpty) {
    return 'This field must be filled';
  } else if (!regex.hasMatch(value)) {
    return 'Please enter valid email';
  }
  return null;
}

String? emptyFieldValidator(String? value) {
  if (value!.isEmpty) {
    return 'This field  must be filled';
  }
  return null;
}

String? passwordValidator(String? value) {
  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp regex = RegExp(pattern);

  if (value!.isEmpty) {
    return 'This field  must be filled';
  } else if (!regex.hasMatch(value)) {
    return 'Use 8 or more characters with a mix of capital & small letters, \nnumbers & symbols';
  }
  return null;
}
