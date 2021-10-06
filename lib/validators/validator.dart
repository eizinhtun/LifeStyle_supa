class Validator {
  static String phone(String value) {
    // String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    // RegExp regExp =  RegExp(patttern);

    RegExp phoneExp = RegExp(r'^09\d{6,9}$');
    RegExp phoneExp1 = RegExp(r'^08\d{6,9}$');
    RegExp phoneExp2 = RegExp(r'^06\d{6,9}$');

    if (value.length == 0) {
      return 'Please enter mobile number';
    } else if (!phoneExp.hasMatch(value) &&
        !phoneExp1.hasMatch(value) &&
        !phoneExp2.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    // return null;
    return "";
  }
}
