import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:notes/src/bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../utilities/dialogs/logout_dialog.dart';
import '../view/note/note_list.dart';
import '../view/settings/settings_information_screen.dart';

class Navigation {
  /// Appbar configuration.
  List<AppBar> appbars(BuildContext context) => [
        AppBar(
          leading: IconButton(
            onPressed: () async {
              final shouldLogout = await showLogoutDialog(context);
              if (shouldLogout) {
                if (context.mounted) {
                  context.read<AuthBloc>().add(
                        const AuthEventLogOut(),
                      );
                }
              }
            },
            icon: Icon(MdiIcons.logout),
          ),
          title: const Text(
            'Notes',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        // AppBar(
        //   leading: IconButton(
        //     onPressed: () async {
        //       final shouldLogout = await showLogoutDialog(context);
        //       if (shouldLogout) {
        //         if (context.mounted) {
        //           context.read<AuthBloc>().add(
        //                 const AuthEventLogOut(),
        //               );
        //         }
        //       }
        //     },
        //     icon: Icon(MdiIcons.logout),
        //   ),
        //   title: const Text(
        //     'Todos',
        //     style: TextStyle(
        //       fontWeight: FontWeight.w600,
        //     ),
        //   ),
        // ),
        AppBar(
          leading: IconButton(
            onPressed: () async {
              final shouldLogout = await showLogoutDialog(context);
              if (shouldLogout) {
                if (context.mounted) {
                  context.read<AuthBloc>().add(
                        const AuthEventLogOut(),
                      );
                }
              }
            },
            icon: Icon(MdiIcons.logout),
          ),
          title: const Text(
            'Settings & Information',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ];

  /// Bottom navigation configuration.
  List<Widget> bottomNavigationScreens(BuildContext context) => [
        const NoteListScreen(),
        //  BlocProvider.value(
        //   value: BlocProvider.of<TodoCubit>(context),
        //   child: const TodoScreen(),
        // ),
        const SettingsAndInformationScreen(),
      ];

  List<NavigationDestination> bottomNavigationItems(BuildContext context) => [
        NavigationDestination(
          icon: Icon(
            MdiIcons.bookOpenPageVariant,
            size: 24,
          ),
          label: 'Notes',
        ),
        // NavigationDestination(
        //   icon: Icon(
        //     MdiIcons.checkboxMarkedOutline,
        //     size: 24,
        //   ),
        //   label: 'Todos',
        // ),
        NavigationDestination(
          icon: Icon(
            MdiIcons.cog,
            size: 24,
          ),
          label: 'Settings & Information',
        ),
      ];
}
