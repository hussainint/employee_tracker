import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String message, {bool isError = false, Function()? undo}) {
  final snackBar = SnackBar(
    content: Text(message, style: TextStyle(color: Colors.white)),
    backgroundColor: isError ? Colors.red : Colors.grey[900],
    action: SnackBarAction(
      label: 'Undo',
      onPressed: undo ?? () {},
      textColor: Colors.blue,
    ),
    duration: Duration(seconds: 2),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
