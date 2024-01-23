import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:notes/src/bloc/auth/auth_bloc.dart';
import 'package:notes/src/bloc/auth/auth_event.dart';
import 'package:notes/src/bloc/auth/auth_state.dart';
import 'package:notes/src/utilities/dialogs/error_dialog.dart';
import '../../utilities/dialogs/password_reset_email_sent_dialog.dart';
import '../../utilities/functions/shortcuts.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _controller.clear();
            await showPasswordResetSentDialog(context);
          }
          if (state.exception != null) {
            if (context.mounted) {
              await showErrorDialog(
                context,
                'we could not process your request, make sure you are register',
              );
            }
          }
        }
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            leading: Icon(
              MdiIcons.key,
            ),
            title: const Text(
              'Forgot Password',
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
                'Forgot Password',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
              ),
              Text(
                'if you forgot your password, simply enter your email and we will send you a password reset link.',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.6),
                  fontSize: 16,
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(
                height: 45,
              ),
              TextField(
                controller: _controller,
                autocorrect: false,
                autofocus: true,
                enableSuggestions: false,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
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
                    final email = _controller.text;
                    context
                        .read<AuthBloc>()
                        .add(AuthEventForgotPassword(email: email));
                  },
                  child: Text(
                    'Reset',
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
                        text: 'Go back to',
                        style: TextStyle(
                          color: getAppColorScheme(context).secondary,
                          fontSize: 16,
                          fontFamily: 'Nunito',
                        ),
                      ),
                      TextSpan(
                        text: ' Login',
                        style: TextStyle(
                          color: getAppColorScheme(context).primary,
                          fontSize: 16,
                          fontFamily: 'Nunito',
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            context.read<AuthBloc>().add(
                                  const AuthEventLogOut(),
                                );
                          },
                      )
                    ],
                  ),
                ),
              ),
              // GestureDetector(
              //   onTap: () async {
              //     final email = _controller.text;
              //     context
              //         .read<AuthBloc>()
              //         .add(AuthEventForgotPassword(email: email));
              //   },
              //   child: Container(
              //     padding: const EdgeInsets.symmetric(vertical: 18),
              //     margin: const EdgeInsets.symmetric(vertical: 10),
              //     width: 350,
              //     decoration: BoxDecoration(
              //         color: Colors.blue,
              //         borderRadius: BorderRadius.circular(29)),
              //     child: ClipRRect(
              //       borderRadius: BorderRadius.circular(29),
              //       child: const Center(
              //         child: Text(
              //           'Send me password reset link',
              //           style: TextStyle(fontSize: 20, color: Colors.white),
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
              //           text: ' Go back to',
              //           style: TextStyle(
              //               color: Colors.black.withOpacity(0.6), fontSize: 12)),
              //       const TextSpan(
              //         text: ' Login',
              //         style: TextStyle(color: Colors.blue, fontSize: 13),
              //       )
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
