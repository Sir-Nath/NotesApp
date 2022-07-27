import 'package:flutter/material.dart';
import 'package:notes/services/auth/auth_service.dart';
import '../constants/route.dart';
import '../enums/menu_action.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Note',
          style: TextStyle(
              color: Colors.black.withOpacity(0.6),
              fontSize: 18
          ),
        ),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async{
              switch(value){
                case MenuAction.logout:
                  final shouldLogout = await showLogoutDialog(context);
                  if(shouldLogout){
                    AuthService.firebase().logout();
                    Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
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
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            const Text('Notes',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w400
              ),
            ),
            Text('Main page',
              style: TextStyle(
                  color: Colors.black.withOpacity(0.6),
                  fontSize: 14
              ),),
          ],
        ),
      ),
    );
  }
}

Future<bool> showLogoutDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('LogOut'),
          content: const Text('Do you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Logout'),
            ),
          ],
        );
      }).then((value) => value ?? false);
}
