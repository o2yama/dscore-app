class Validator {
  bool validEmail(String email) {
    if (RegExp(
      r'^[0-9a-zA-Z.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+[a-zA-Z0-9-]',
    ).hasMatch(email)) {
      return true;
    } else {
      return false;
    }
  }

  bool validPassword(String password) {
    if (RegExp('[0-9a-zA-Z]').hasMatch(password) && password.length >= 6) {
      return true;
    } else {
      return false;
    }
  }
}
