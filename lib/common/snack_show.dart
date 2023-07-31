
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SnackShow {
  static showSuccess(BuildContext context,String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.greenAccent,
        duration: Duration(seconds: 1), content: Text(msg,style: TextStyle(color: Colors.white),)));

  }


  static showFailure(BuildContext context,String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.red,
        duration: Duration(seconds: 3), content: Text(msg,style: TextStyle(color: Colors.white))));

  }
}
