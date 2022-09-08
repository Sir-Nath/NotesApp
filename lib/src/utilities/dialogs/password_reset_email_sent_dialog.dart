import 'package:flutter/material.dart';
import 'package:notes/src/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Password reset',
    content: 'password reset link sent, check email',
    optionBuilder: () {
      return {'OK': null};
    },
  );
}
