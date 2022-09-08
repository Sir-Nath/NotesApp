import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/constants/routes/route.dart';
import 'package:notes/bloc/auth/auth_bloc.dart';
import 'package:notes/data/provider/auth/firebase_auth_provider.dart';
import 'package:notes/views/forgot_password_screen/forgot_password_screen_page.dart';
import 'package:notes/views/login_screen/login_screen_page.dart';
import 'package:notes/views/note_screen/create_update_note_view.dart';
import 'package:notes/views/note_screen/note_screen.dart';
import 'package:notes/views/note_screen/note_todo_create.dart';
import 'package:notes/views/register_view_screen/register_screen_page.dart';
import 'package:notes/views/verify_email_screen/email_verification_screen_page.dart';
import 'bloc/auth/auth_event.dart';
import 'bloc/auth/auth_state.dart';
import 'constants/helpers/loading/loading_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Poppins'
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(
          FirebaseAuthProvider(),
        ),
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
    return BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state){
          if(state.isLoading){
            LoadingScreen().show(
              context: context, text: state.loadingText ?? 'Please wait a moment'
            );
          }else{
            LoadingScreen().hide();
          }
        },
        builder: (context, state) {
      if (state is AuthStateLoggedIn) {
        return MainNoteScreen();
      } else if (state is AuthStateNeedVerification) {
        return const EmailVerificationScreenPage();
      } else if (state is AuthStateLoggedOut) {
        return const LoginScreenPage();
      } else if (state is AuthStateRegistering) {
        return const RegisterScreenPage();
      } else if(state is AuthStateForgotPassword){
    return const ForgotPasswordScreenPage();
    }else if(state is AuthStateNotePage){
        return const NotesView();
      }else {
        return const Scaffold(
          body: CircularProgressIndicator(),
        );
      }
    });
  }
}
