import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/constants/exception/auth/auth_exception.dart';
import 'package:notes/bloc/auth/auth_bloc.dart';
import 'package:notes/utilities/dialogs/loading_dialog.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late bool isVisible = false;
  CloseDialog? _closeDialogHandle;

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          final closeDialog = _closeDialogHandle;
          if (!state.isLoading && closeDialog != null) {
            closeDialog();
            _closeDialogHandle = null;
          }else if (state.isLoading && closeDialog == null) {
            _closeDialogHandle = showLoadingDialog(
              context: context,
              text: 'Loading...',
            );
          }
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(context, 'user not found');
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(context, 'Wrong credentials');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Authentication error');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Login',
            style:
                TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 18),
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
                style: TextStyle(
                    color: Colors.black.withOpacity(0.6), fontSize: 14),
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
                obscureText: isVisible,
                autocorrect: false,
                enableSuggestions: false,
                controller: _password,
                decoration: InputDecoration(
                  labelText: 'Password',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: IconButton(
                    onPressed: () {
                      if (isVisible == true) {
                        setState(() {
                          isVisible = false;
                        });
                      } else {
                        setState(() {
                          isVisible = true;
                        });
                      }
                    },
                    icon: isVisible
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off),
                  ),
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
                  context.read<AuthBloc>().add(
                        AuthEventLogIn(
                          email,
                          password,
                        ),
                      );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: 350,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(29)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(29),
                    child: const Center(
                      child: Text(
                        'Login',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  context.read<AuthBloc>().add(const AuthEventShouldRegister());
                },
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: ' Don\'t have an account?',
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontSize: 12)),
                    const TextSpan(
                        text: ' Register here',
                        style: TextStyle(color: Colors.blue, fontSize: 13))
                  ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
