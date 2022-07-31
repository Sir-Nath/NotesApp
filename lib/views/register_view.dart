import 'package:flutter/material.dart';
import 'package:notes/constants/route.dart';
import 'package:notes/services/auth/auth_service.dart';
import '../services/auth/auth_exception.dart';
import '../utilities/dialogs/error_dialog.dart';

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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Register',
          style: TextStyle(
            color: Colors.black.withOpacity(0.6),
            fontSize: 18
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            const Text('Register Here',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w400
              ),
            ),
            Text('Register with email and password',
              style: TextStyle(
                  color: Colors.black.withOpacity(0.6),
                  fontSize: 14
              ),),
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
                  borderRadius: BorderRadius.circular(29),
                ),
              ),
            ),
            const SizedBox(height: 30,),
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
            const SizedBox(height: 30,),
            GestureDetector(
              onTap: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  AuthService.firebase().createUser(
                    email: email,
                    password: password,
                  );
                  await AuthService.firebase().sendEmailVerification();
                  Navigator.of(context).pushNamed(verifyEmailRoute);
                } on WeakPasswordAuthException {
                  await showErrorDialog(context, 'Weak  Password');
                } on EmailAlreadyInUseAuthException {
                  await showErrorDialog(context, 'Email in use');
                } on InvalidEmailAuthException {
                  await showErrorDialog(context, 'Email doesn\'t exist');
                } on GenericAuthException {
                  await showErrorDialog(context, 'Failed to Register');
                }
              },
              child: Container(
                width: 350,
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: const Center(
                  child: Text(
                  'Register',
                  style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  ),
                ),
                ),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(29)
                ),
              ),
            ),
            const SizedBox(height: 30,),
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: RichText(
                text: TextSpan(
                    children: [
                      TextSpan(
                          text: ' Registered?',
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontSize: 12
                          )
                      ),
                      const TextSpan(
                          text: ' Login',
                          style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 13
                          )
                      )
                    ]
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
