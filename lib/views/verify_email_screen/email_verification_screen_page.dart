import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/parser.dart';
import 'package:flutter_svg/svg.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../widgets/custom_button.dart';

class EmailVerificationScreenPage extends StatelessWidget {
  const EmailVerificationScreenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: height * 0.1,
            ),
            const Text(
              'Email verification',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: width * 0.03,
            ),
            const Text(
              "We have sent a verification mail to the \nemail address you provided",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            SizedBox(
              height: height * 0.03,
            ),
            SizedBox(
              width: width,
              height: height * 0.4,
              child:
              Image.asset('assets/images/New Messages.png',
              width: width,
                height: width,
              )
            ),
            CustomButton(
              buttonText: 'Resend',
              press: () async {
                context.read<AuthBloc>().add(const AuthEventSendEmailVerification());
              },
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Center(
              child: GestureDetector(
                onTap: () async{
                  context.read<AuthBloc>().add(const AuthEventLogOut());
                },
                child: const Text(
                  'Back to Login',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
