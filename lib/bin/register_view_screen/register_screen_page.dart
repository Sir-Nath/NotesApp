import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notes/src/bloc/auth/auth_bloc.dart';
import 'package:notes/src/bloc/auth/auth_state.dart';
import 'package:notes/src/view/widget/custom_button.dart';
import '../../src/bloc/auth/auth_event.dart';
import '../../src/constants/exception/auth/auth_exception.dart';
import '../../src/utilities/dialogs/error_dialog.dart';

class RegisterScreenPage extends StatefulWidget {
  const RegisterScreenPage({super.key});

  @override
  State<RegisterScreenPage> createState() => _RegisterScreenPageState();
}

class _RegisterScreenPageState extends State<RegisterScreenPage> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _name ;
  late bool isVisible = false;

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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
                  //   color: const Color(0xff3454CC),
                  // ),
                  SizedBox(
                    height: height * 0.04,
                  ),
                  const Text(
                    'Get Started',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
                  ),
                  const Text(
                    'Create your account',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: height * 0.06),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        // height: 30,
                        // width: 50,
                        child: SvgPicture.asset('assets/svgs/person.svg'),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      SizedBox(
                        width: width * 0.78,
                        child: TextField(
                          controller: _name,
                          autocorrect: false,
                          enableSuggestions: false,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
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
                          child: SvgPicture.asset('assets/svgs/Password.svg')),
                      const SizedBox(
                        width: 20,
                      ),
                      SizedBox(
                        width: width * 0.78,
                        child: TextField(
                          obscureText: true,
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
                  SizedBox(
                    height: height * 0.15,
                  ),
                  GestureDetector(
                    onTap: () async {
                      final email = _email.text;
                      final password = _password.text;
                      final name = _name.text;
                      context.read<AuthBloc>().add(AuthEventRegister(
                        email,
                        password,
                        name
                      ));
                    },
                    child: const CustomButton(
                      buttonText: 'Create Account',
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        context.read<AuthBloc>().add(const AuthEventLogOut());
                      },
                      child: const Text(
                        'Login',
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
