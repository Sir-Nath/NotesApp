import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import "package:flutter/material.dart";
import 'dart:developer';
import '../firebase_options.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     centerTitle: true,
    //     title: const Text(
    //       'LOGIN',
    //     ),
    //   ),
    //   body: FutureBuilder<Object>(
    //       future: Firebase.initializeApp(
    //         options: DefaultFirebaseOptions.currentPlatform,
    //       ),
    //       builder: (context, snapshot) {
    //         switch (snapshot.connectionState) {
    //           case ConnectionState.done:
    //
    //           default:
    //             return const Text('Loading');
    //         }
    //       }),
    // );
    return Column(
      children: [
        TextField(
          controller: _email,
          autocorrect: false,
          enableSuggestions: false,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: 'input your email here',
          ),
        ),
        TextField(
          obscureText: true,
          autocorrect: false,
          enableSuggestions: false,
          controller: _password,
          decoration: const InputDecoration(
              hintText: 'input your password here'),
        ),
        TextButton(
          //this is an application of future, async and await
          onPressed: () async {
            final email = _email.text;
            final password = _password.text;
            try{
              final userCredential = await FirebaseAuth.instance
                  .signInWithEmailAndPassword(
                  email: email, password: password);
              log(userCredential.toString());
            }on FirebaseAuthException catch(e){
              if(e.code == 'user-not-found'){
                log('User not found');
              }
              else if(e.code == 'wrong-password'){
                log('Wrong password');
              }
              else{
                log('something else happened');
              }
            }
          },
          child: const Text(
            'Login',
            style: TextStyle(fontSize: 20),
          ),
        )
      ],
    );
  }
}
