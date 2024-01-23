import 'package:flutter/gestures.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:notes/src/constants/exception/auth/auth_exception.dart';
import 'package:notes/src/bloc/auth/auth_bloc.dart';
// ignore: unused_import
import 'package:notes/src/utilities/dialogs/loading_dialog.dart';
import 'package:notes/src/utilities/functions/shortcuts.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late bool isVisible = true;

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
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(
                context, 'cannot find user with the given credentials');
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(context, 'Wrong credentials');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Authentication error');
          }
        }
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {},
              icon: Icon(MdiIcons.login),
            ),
            title: const Text(
              'Login',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Sign in with email and password',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.6),
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 45,
              ),
              SizedBox(
                child: TextField(
                  controller: _email,
                  autocorrect: false,
                  enableSuggestions: false,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(
                      left: 16,
                      top: 16,
                      bottom: 16,
                      right: 16,
                    ),
                    labelText: 'Email',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon: Icon(MdiIcons.email),
                    hintText: 'input your email here',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(
                        width: 1,
                        color: getAppColorScheme(context).secondary,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                child: TextField(
                  obscureText: isVisible,
                  autocorrect: false,
                  enableSuggestions: false,
                  controller: _password,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    contentPadding: const EdgeInsets.only(
                      left: 16,
                      top: 16,
                      bottom: 16,
                      right: 16,
                    ),
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
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(
                          width: 1,
                          color: getAppColorScheme(context).secondary),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      context
                          .read<AuthBloc>()
                          .add(const AuthEventForgotPassword());
                    },
                    child: const Text('Forgot Password?'),
                  )),
              const SizedBox(
                height: 75,
              ),
              SizedBox(
                height: 54,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: getAppColorScheme(context).primary,
                    foregroundColor: getAppColorScheme(context).secondary,
                  ),
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;
                    context.read<AuthBloc>().add(
                          AuthEventLogIn(
                            email,
                            password,
                          ),
                        );
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: getAppColorScheme(context).onPrimary,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.center,
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: 'Don\'t have an account?',
                      style: TextStyle(
                        color: getAppColorScheme(context).secondary,
                        fontSize: 16,
                        fontFamily: 'Nunito',
                      ),
                    ),
                    TextSpan(
                      text: ' Register here',
                      style: TextStyle(
                        color: getAppColorScheme(context).primary,
                        fontSize: 16,
                        fontFamily: 'Nunito',
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          context
                              .read<AuthBloc>()
                              .add(const AuthEventShouldRegister());
                        },
                    )
                  ]),
                ),
              ),
              // GestureDetector(
              //   onTap: () async {
              //     final email = _email.text;
              //     final password = _password.text;
              //     context.read<AuthBloc>().add(
              //           AuthEventLogIn(
              //             email,
              //             password,
              //           ),
              //         );
              //   },
              //   child: Container(
              //     padding: const EdgeInsets.symmetric(vertical: 18),
              //     margin: const EdgeInsets.symmetric(vertical: 10),
              //     width: 350,
              //     decoration: BoxDecoration(
              //         color: Colors.blue,
              //         borderRadius: BorderRadius.circular(24)),
              //     child: ClipRRect(
              //       borderRadius: BorderRadius.circular(24),
              //       child: const Center(
              //         child: Text(
              //           'Login',
              //           style: TextStyle(
              //             fontSize: 20,
              //             color: Colors.white,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // const SizedBox(
              //   height: 30,
              // ),
              // GestureDetector(
              //   onTap: () {
              //     context.read<AuthBloc>().add(const AuthEventShouldRegister());
              //   },
              //   child: RichText(
              //     text: TextSpan(children: [
              //       TextSpan(
              //           text: ' Don\'t have an account?',
              //           style: TextStyle(
              //               color: Colors.black.withOpacity(0.6),
              //               fontSize: 12)),
              //       const TextSpan(
              //           text: ' Register here',
              //           style: TextStyle(color: Colors.blue, fontSize: 13))
              //     ]),
              //   ),
              // ),
              // const SizedBox(
              //   height: 20,
              // ),
              // GestureDetector(
              //   onTap: () {
              //     context.read<AuthBloc>().add(const AuthEventForgotPassword());
              //   },
              //   child: RichText(
              //     text: TextSpan(children: [
              //       TextSpan(
              //           text: 'Forgot Password?',
              //           style: TextStyle(
              //               color: Colors.black.withOpacity(0.6),
              //               fontSize: 12)),
              //       const TextSpan(
              //           text: ' Reset here',
              //           style: TextStyle(color: Colors.blue, fontSize: 13))
              //     ]),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
