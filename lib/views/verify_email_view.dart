import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/constants/route.dart';
import 'package:notes/services/auth/auth_service.dart';
import 'package:notes/services/auth/bloc/auth_event.dart';

import '../services/auth/bloc/auth_bloc.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Verify Email',
          style: TextStyle(
              color: Colors.black.withOpacity(0.6),
              fontSize: 18
          ),
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30,),
            Text('we have already sent a verification email \n please check you email and verify',
              style: TextStyle(
                  color: Colors.black.withOpacity(0.6),
                  fontSize: 16
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30,),
            SizedBox(
              width: 350,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(29),
                child: TextButton(
                    onPressed: () async {
                 context.read<AuthBloc>().add(const AuthEventSendEmailVerification());
                    },
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                  ),
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
                    child: const Text(
                  'Resend Mail',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                ),
              ),
            ),
            const SizedBox(height: 30,),
            SizedBox(
              width: 350,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(29),
                child: TextButton(
                    onPressed: () async {
                    context.read<AuthBloc>().add(const AuthEventLogOut());
                    },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                    ),
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                  ),
                    child: const Text(
                      'Go back to Login',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
              ),
            ),
        ),
        ]
      ),
      )
    );
  }
}