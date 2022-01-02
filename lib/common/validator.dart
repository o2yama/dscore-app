import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

void showValidMessage(BuildContext context, String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.pinkAccent,
      textColor: Colors.white,
      fontSize: 16);
}
