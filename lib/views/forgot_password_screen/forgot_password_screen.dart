import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/bloc/auth/auth_bloc.dart';
import 'package:notes/bloc/auth/auth_event.dart';
import 'package:notes/bloc/auth/auth_state.dart';
import 'package:notes/utilities/dialogs/error_dialog.dart';

import '../../utilities/dialogs/password_reset_email_sent_dialog.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

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
            await showErrorDialog(
              context,
              'we could not process your request, make sure you are register',
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Forgot Password',
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
                'Forgot Password',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
              ),
              Text(
                'if you forgot your password, simply enter your email and we will send you a password reset link,',
                style: TextStyle(
                    color: Colors.black.withOpacity(0.6), fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: _controller,
                autocorrect: false,
                autofocus: true,
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
              GestureDetector(
                onTap: () async {
                  final email = _controller.text;
                  context
                      .read<AuthBloc>()
                      .add(AuthEventForgotPassword(email: email));
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
                        'Send me password reset link',
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
                  context.read<AuthBloc>().add(const AuthEventLogOut());
                },
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: ' Go back to',
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontSize: 12)),
                    const TextSpan(
                      text: ' Login',
                      style: TextStyle(color: Colors.blue, fontSize: 13),
                    )
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
