import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes/views/login_view.dart';
import 'package:notes/views/register_view.dart';
import 'package:notes/views/verify_email_view.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        '/login/': (context) => LoginView(),
        '/register/': (context) => RegisterView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                if (user.emailVerified) {
                  print('Email is verified');
                } else {
                  return VerifyEmailView();
                }
              } else {
                return const LoginView();
              }
              return Text('done');
            // final emailVerified = user?.emailVerified ?? false;
            // log(user.toString());
            // if(emailVerified){
            //   log('you email is verified');
            //   return Text('Done');
            // }else{
            //   log('you need to verify your email');
            //
            // }
            //return LoginView();
            default:
              return Scaffold(
                body: Center(
                  child: const CircularProgressIndicator(),
                ),
              );
          }
        });
  }
}
