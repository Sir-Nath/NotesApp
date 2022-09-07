import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notes/views/widgets/custom_button.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';

class ForgotPasswordScreenPage extends StatefulWidget {
  const ForgotPasswordScreenPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreenPage> createState() => _ForgotPasswordScreenPageState();
}

class _ForgotPasswordScreenPageState extends State<ForgotPasswordScreenPage> {
  late final TextEditingController _email;

  @override
  void initState() {
    _email = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }
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
                'Forgot password',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500
                ),
              ),
              SizedBox(
                height: width * 0.03,
              ),
              Text(
                "Don't worry, it happens, please enter the \naddress associated with your account",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16
                ),
              ),
              SizedBox(
                height: height * 0.1,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(

                      child: SvgPicture.asset('assets/svgs/At.svg')),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    width: width * 0.78,
                    child: TextField(
                      controller: _email,
                      autocorrect: false,
                      enableSuggestions: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: height * 0.1,
              ),
              CustomButton(buttonText: 'Submit',
              press: ()async{
                final email = _email.text;
                context
                    .read<AuthBloc>()
                    .add(AuthEventForgotPassword(email: email));
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
      )
    );
  }
}
