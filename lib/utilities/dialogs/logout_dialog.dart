import 'package:flutter/material.dart';
import 'package:notes/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogoutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Log out',
    content: 'Are you sure want to logout?',
    optionBuilder: () => {
      'Cancel': false,
      'LogOut': true,
    },
  ) .then((value) => value??false);
}
