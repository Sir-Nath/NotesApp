import "package:flutter/material.dart";
import 'package:notes/constants/route.dart';
import 'package:notes/services/auth/auth_exception.dart';
import 'package:notes/services/auth/auth_service.dart';
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
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Login',
          style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Welcome Back',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
            ),
            Text(
              'Sign in with email and password',
              style:
                  TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 14),
            ),
            const SizedBox(
              height: 30,
            ),
            TextField(
              controller: _email,
              autocorrect: false,
              enableSuggestions: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  labelText: 'Email',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: const Icon(Icons.person),
                  hintText: 'input your email here',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(29))),
            ),
            const SizedBox(
              height: 30,
            ),
            TextField(
              obscureText: true,
              autocorrect: false,
              enableSuggestions: false,
              controller: _password,
              decoration: InputDecoration(
                labelText: 'Password',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                suffixIcon: const Icon(Icons.visibility_off),
                hintText: 'input your password here',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(29),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  await AuthService.firebase()
                      .login(email: email, password: password);
                  //AuthService.firebase() return an instance of AuthService(FirebaseAuthProvider)
                  //the currentUser getter returns a AuthUser? type
                  final user = await AuthService.firebase().currentUser;
                  if (user?.isEmailVerified ?? false) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        noteRoute, (route) => false);
                  } else {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        verifyEmailRoute, (route) => false);
                  }
                } on UserNotFoundAuthException {
                  await showErrorDialog(context, 'User not found');
                } on WrongPasswordAuthException {
                  await showErrorDialog(context, 'wrong password');
                } on GenericAuthException {
                  await showErrorDialog(context, 'Authentication error');
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 18),
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: 350,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(29),
                  child: Center(
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(29)
                ),
              ),
            ),
            SizedBox( height: 30,),
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: ' Don\'t have an account?',
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.6), fontSize: 12)),
                  const TextSpan(
                      text: ' Register here',
                      style: const TextStyle(color: Colors.blue, fontSize: 13))
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
