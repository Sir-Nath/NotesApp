import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/constants/routes/route.dart';
import 'package:notes/bloc/auth/auth_bloc.dart';
import 'package:notes/data/provider/auth/firebase_auth_provider.dart';
import 'package:notes/views/login_screen/login_view.dart';
import 'package:notes/views/note_screen/create_update_note_view.dart';
import 'package:notes/views/note_screen/note_screen.dart';
import 'package:notes/views/register_view_screen/register_view.dart';
import 'package:notes/views/verify_email_screen/verify_email_view.dart';
import 'bloc/auth/auth_event.dart';
import 'bloc/auth/auth_state.dart';
import 'constants/theme/text_theme.dart';

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

