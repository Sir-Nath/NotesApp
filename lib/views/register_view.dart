import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:notes/constants/route.dart';


class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {

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
    //       'Register',
    //     ),
    //   ),
    //   body: FutureBuilder<Object>(
    //       future: Firebase.initializeApp(
    //         options: DefaultFirebaseOptions.currentPlatform,
    //       ),
    //       builder: (context, snapshot) {
    //         switch (snapshot.connectionState) {
    //           case ConnectionState.done:
    //             return
    //           default:
    //             return const Text('Loading');
    //         }
    //       }),
    // );
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Register'),
      ),
      body: Column(
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
                    .createUserWithEmailAndPassword(
                    email: email, password: password);
                log(userCredential.toString());
              } on FirebaseAuthException catch (e){
                if (e.code == 'weak-password'){
                  log('Weak Password');
                } else if(e.code == 'email-already-in-use'){
                  log('Email in use');
                } else if(e.code == 'invalid-email'){
                  log('Email doesn\'t exist');
                }
              }
            },
            child: const Text(
              'Register',
              style: TextStyle(fontSize: 20),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            child: Text('Registered? Login'),
          )
        ],
      ),
    );
  }
}