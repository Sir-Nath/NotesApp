// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:notes/constants/route.dart';
// import 'package:notes/services/auth/auth_service.dart';
// import 'package:notes/services/auth/bloc/auth_bloc.dart';
// import 'package:notes/services/auth/firebase_auth_provider.dart';
// import 'package:notes/views/login_view.dart';
// import 'package:notes/views/note/create_update_note_view.dart';
// import 'package:notes/views/note/note_screen.dart';
// import 'package:notes/views/register_view.dart';
// import 'package:notes/views/verify_email_view.dart';
// import 'constants/text_theme.dart';
//
// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(
//     MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: themeData(),
//       home: BlocProvider<AuthBloc>(
//         create: (context) => AuthBloc(FirebaseAuthProvider()),
//         child: const HomePage(),
//       ),
//       routes: {
//         loginRoute: (context) => const LoginView(),
//         registerRoute: (context) => const RegisterView(),
//         noteRoute: (context) => const NotesView(),
//         verifyEmailRoute: (context) => const VerifyEmailView(),
//         createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView()
//       },
//     ),
//   );
// }
//
// class HomePage extends StatelessWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: AuthService.firebase().initialise(),
//       builder: (context, snapshot) {
//         switch (snapshot.connectionState) {
//           case ConnectionState.done:
//             final user = AuthService
//                 .firebase()
//                 .currentUser;
//             if (user != null) {
//               if (user.isEmailVerified) {
//                 return const NotesView();
//               } else {
//                 return const VerifyEmailView();
//               }
//             } else {
//               return const LoginView();
//             }
//           default:
//             return const Scaffold(
//               body: Center(
//                 child: CircularProgressIndicator(),
//               ),
//             );
//         }
//       },
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/constants/route.dart';
import 'package:notes/services/auth/bloc/auth_bloc.dart';
import 'package:notes/services/auth/bloc/auth_event.dart';
import 'package:notes/services/auth/bloc/auth_state.dart';
import 'package:notes/services/auth/firebase_auth_provider.dart';
import 'package:notes/views/login_view.dart';
import 'package:notes/views/note/create_update_note_view.dart';
import 'package:notes/views/note/note_screen.dart';
import 'package:notes/views/register_view.dart';
import 'package:notes/views/verify_email_view.dart';
import 'constants/text_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: themeData(),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView()
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthStateLoggedIn) {
            return const NotesView();
          } else if (state is AuthStateNeedVerification) {
            return const VerifyEmailView();
          } else if (state is AuthStateLoggedOut) {
            return const LoginView();
          } else if(state is AuthStateRegistering){
            return const RegisterView();
          }else {
            return const Scaffold(
              body: CircularProgressIndicator(),
            );
          }
        });
  }
}

