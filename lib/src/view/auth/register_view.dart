import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../constants/exception/auth/auth_exception.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../utilities/dialogs/error_dialog.dart';
import '../../utilities/functions/shortcuts.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _name;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _name = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, 'weak password');
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(context, 'Email in use');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'failed to register');
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, 'invalid email');
          }
        }
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {},
              icon: Icon(MdiIcons.signatureFreehand),
            ),
            title: const Text(
              'Sign Up',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // appBar: AppBar(
          //   centerTitle: true,
          //   backgroundColor: Colors.transparent,
          //   elevation: 0,
          //   title: Text(
          //     'Register',
          //     style:
          //         TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 18),
          //   ),
          // ),
          body: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Register Here',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
              ),
              Text(
                'Register with email and password',
                style: TextStyle(
                    color: Colors.black.withOpacity(0.6), fontSize: 16),
              ),
              const SizedBox(
                height: 45,
              ),
              TextField(
                controller: _name,
                autocorrect: false,
                enableSuggestions: false,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                    left: 16,
                    top: 16,
                    bottom: 16,
                    right: 16,
                  ),
                  labelText: 'Full Name',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: Icon(MdiIcons.head),
                  hintText: 'input your full name here',
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
              const SizedBox(
                height: 30,
              ),
              TextField(
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
              const SizedBox(
                height: 30,
              ),
              TextField(
                obscureText: true,
                autocorrect: false,
                enableSuggestions: false,
                controller: _password,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                    left: 16,
                    top: 16,
                    bottom: 16,
                    right: 16,
                  ),
                  labelText: 'Password',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: const Icon(Icons.visibility_off),
                  hintText: 'input your password here',
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
                    final name = _name.text;
                    context.read<AuthBloc>().add(
                          AuthEventRegister(
                            email,
                            password,
                            name,
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
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Already have an account?',
                        style: TextStyle(
                          color: getAppColorScheme(context).secondary,
                          fontSize: 16,
                          fontFamily: 'Nunito',
                        ),
                      ),
                      TextSpan(
                        text: ' Login here',
                        style: TextStyle(
                          color: getAppColorScheme(context).primary,
                          fontSize: 16,
                          fontFamily: 'Nunito',
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            context
                                .read<AuthBloc>()
                                .add(const AuthEventLogOut());
                          },
                      )
                    ],
                  ),
                ),
              ),
              // GestureDetector(
              //   onTap: () async {
              //     final email = _email.text;
              //     final password = _password.text;
              //     final name = _name.text;
              //     context.read<AuthBloc>().add(
              //           AuthEventRegister(
              //             email,
              //             password,
              //             name,
              //           ),
              //         );
              //   },
              //   child: Container(
              //     width: 350,
              //     padding: const EdgeInsets.symmetric(vertical: 18),
              //     decoration: BoxDecoration(
              //         color: Colors.blue,
              //         borderRadius: BorderRadius.circular(29)),
              //     child: const Center(
              //       child: Text(
              //         'Register',
              //         style: TextStyle(
              //           fontSize: 20,
              //           color: Colors.white,
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
              //     context.read<AuthBloc>().add(const AuthEventLogOut());
              //   },
              //   child: RichText(
              //     text: TextSpan(children: [
              //       TextSpan(
              //           text: ' Registered?',
              //           style: TextStyle(
              //               color: Colors.black.withOpacity(0.6),
              //               fontSize: 12)),
              //       const TextSpan(
              //           text: ' Login',
              //           style: TextStyle(color: Colors.blue, fontSize: 13))
              //     ]),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
