import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notes/src/bloc/auth/auth_state.dart';
import 'package:notes/src/view/widget/custom_button.dart';
import '../../src/bloc/auth/auth_bloc.dart';
import '../../src/bloc/auth/auth_event.dart';
import '../../src/constants/exception/auth/auth_exception.dart';
import '../../src/utilities/dialogs/error_dialog.dart';

class LoginScreenPage extends StatefulWidget {
  const LoginScreenPage({super.key});

  @override
  State<LoginScreenPage> createState() => _LoginScreenPageState();
}

class _LoginScreenPageState extends State<LoginScreenPage> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late bool isVisible = false;

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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
      child: Scaffold(
        body: Container(
          height: height,
          width: width,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'assets/images/authbackground.png',
                  ),
                  opacity: 0.2,
                  fit: BoxFit.fill)),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.05, vertical: width * 0.1),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: height * 0.08,
                  ),
                  // SvgPicture.asset('assets/svgs/mdi_feather.svg',
                  // color: const Color(0xff3454CC),
                  // ),
                  SizedBox(
                    height: height * 0.04,
                  ),
                  const Text(
                    'Log In',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
                  ),
                  const Text(
                    'Welcome back!',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: height * 0.06),
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
                    height: height * 0.02,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          // height: 30,
                          // width: 50,
                          child: SvgPicture.asset('assets/svgs/Password.svg')),
                      const SizedBox(
                        width: 20,
                      ),
                      SizedBox(
                        width: width * 0.78,
                        child: TextField(
                          obscureText: isVisible,
                          autocorrect: false,
                          enableSuggestions: false,
                          controller: _password,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            suffix: isVisible
                                ? GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isVisible = false;
                                      });
                                    },
                                    child: SvgPicture.asset(
                                        'assets/svgs/visibility.svg'),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isVisible = true;
                                      });
                                    },
                                    child: SvgPicture.asset(
                                        'assets/svgs/visibility off.svg'),
                                  ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          context
                              .read<AuthBloc>()
                              .add(const AuthEventForgotPassword());
                        },
                        child: const Text(
                          'forgot password',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.15,
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
                      child: const CustomButton(
                        buttonText: 'Log In',
                      )),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        context
                            .read<AuthBloc>()
                            .add(const AuthEventShouldRegister());
                      },
                      child: const Text(
                        'Create account',
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
          ),
        ),
      ),
    );
  }
}
