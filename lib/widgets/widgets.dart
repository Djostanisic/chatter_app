import 'package:chatter_app/shared/strings.dart';
import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
    labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFF5B402), width: 2),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFF5B402), width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFF5B402), width: 2),
    ));

void nextScreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenReplace(context, page) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => page),
    (route) => false,
  );
}

void popBackStack(BuildContext context) {
   Navigator.of(context).pop();
}

void showSnackBar(context, color, message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      style: const TextStyle(fontSize: 14),
    ),
    backgroundColor: color,
    duration: const Duration(seconds: 3),
    action: SnackBarAction(
      label: Strings.labelOk,
      onPressed: () {},
      textColor: Colors.white,
    ),
  ));
}
