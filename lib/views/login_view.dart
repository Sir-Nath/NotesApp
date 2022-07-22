import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'dart:developer';
import 'package:notes/constants/route.dart';
import '../utilities/show_error_dialog.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            TextField(
              controller: _email,
              autocorrect: false,
              enableSuggestions: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                suffixIcon: Icon(Icons.person),
                hintText: 'input your email here',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15)
                )

              ),
            ),
            SizedBox( height: 30,),
            TextField(
              obscureText: true,
              autocorrect: false,
              enableSuggestions: false,
              controller: _password,
              decoration:
                  InputDecoration(hintText: 'input your password here',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)
                      )
                  ),
            ),
            TextButton(
              //this is an application of future, async and await
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: email, password: password);
                  final user = FirebaseAuth.instance.currentUser;
                  if(user?.emailVerified ?? false){
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(noteRoute, (route) => false);
                  }else{
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(verifyEmailRoute, (route) => false);
                  }
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found'){
                    await showErrorDialog(context, 'User not found');
                    log('User not found');
                  } else if (e.code == 'wrong-password') {
                    await showErrorDialog(context, 'Wrong password');
                    log('Wrong password');
                  } else {
                    log('something else happened');
                    await showErrorDialog(context, 'Error: ${e.code}');
                  }
                } catch(e){
                  await showErrorDialog(context, e.toString());
                }
              },
              child: const Text(
                'Login',
                style: TextStyle(fontSize: 20),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: const Text('Not Registered yet? Register here'),
            )
          ],
        ),
      ),
    );
  }
}


