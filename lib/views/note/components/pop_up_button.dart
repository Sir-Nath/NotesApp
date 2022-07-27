import 'package:flutter/material.dart';
import 'package:notes/views/note/components/show_logout_dialog.dart';
import '../../../constants/route.dart';
import '../../../enums/menu_action.dart';
import '../../../services/auth/auth_service.dart';

class PopUpButton extends StatelessWidget {
  const PopUpButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuAction>(
      onSelected: (value) async {
        switch (value) {
          case MenuAction.logout:
            final shouldLogout = await showLogoutDialog(context);
            if (shouldLogout) {
              AuthService.firebase().logout();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            }
            break;
        }
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem<MenuAction>(
            value: MenuAction.logout,
            child: Text('Log Out'),
          ),
        ];
      },
    );
  }
}