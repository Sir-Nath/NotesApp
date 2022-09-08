import 'package:flutter/material.dart';

//this file not in use but kept for lesson sake
typedef CloseDialog = void Function();

CloseDialog showLoadingDialog(
    {required BuildContext context, required String text}) {
  final dialog = AlertDialog(
    insetPadding: const EdgeInsets.symmetric(horizontal: 16),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 10),
        Text(text)
      ],
    ),
  );
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => dialog,
  );
  return () => Navigator.of(context).pop();
}
