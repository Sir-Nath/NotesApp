import 'package:flutter/material.dart';

Future<void> showErrorDialog(BuildContext context, String text) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('An error occured'),
          content: Text(text),
          actions: [
            TextButton(onPressed: (){
              Navigator.of(context).pop();
            } ,
              child: Text('OK'),)
          ],
        );
      });
}