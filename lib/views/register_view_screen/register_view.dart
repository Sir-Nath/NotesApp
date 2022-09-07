// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../bloc/auth/auth_event.dart';
// import '../../bloc/auth/auth_state.dart';
// import '../../constants/exception/auth/auth_exception.dart';
// import '../../bloc/auth/auth_bloc.dart';
// import '../../utilities/dialogs/error_dialog.dart';
//
// class RegisterView extends StatefulWidget {
//   const RegisterView({Key? key}) : super(key: key);
//
//   @override
//   State<RegisterView> createState() => _RegisterViewState();
// }
//
// class _RegisterViewState extends State<RegisterView> {
//   late final TextEditingController _email;
//   late final TextEditingController _password;
//
//   @override
//   void initState() {
//     _email = TextEditingController();
//     _password = TextEditingController();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _email.dispose();
//     _password.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<AuthBloc, AuthState>(
//       listener: (context, state) async {
//         if (state is AuthStateRegistering) {
//           if (state.exception is WeakPasswordAuthException) {
//             await showErrorDialog(context, 'weak password');
//           } else if (state.exception is EmailAlreadyInUseAuthException) {
//             await showErrorDialog(context, 'Email in use');
//           } else if (state.exception is GenericAuthException) {
//             await showErrorDialog(context, 'failed to register');
//           } else if (state.exception is InvalidEmailAuthException) {
//             await showErrorDialog(context, 'invalid email');
//           }
//         }
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           title: Text(
//             'Register',
//             style:
//                 TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 18),
//           ),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//           child: Column(
//             children: [
//               const SizedBox(
//                 height: 30,
//               ),
//               const Text(
//                 'Register Here',
//                 style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
//               ),
//               Text(
//                 'Register with email and password',
//                 style: TextStyle(
//                     color: Colors.black.withOpacity(0.6), fontSize: 14),
//               ),
//               const SizedBox(
//                 height: 30,
//               ),
//               TextField(
//                 controller: _email,
//                 autocorrect: false,
//                 enableSuggestions: false,
//                 keyboardType: TextInputType.emailAddress,
//                 decoration: InputDecoration(
//                   labelText: 'Email',
//                   floatingLabelBehavior: FloatingLabelBehavior.always,
//                   suffixIcon: const Icon(Icons.person),
//                   hintText: 'input your email here',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(29),
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 30,
//               ),
//               TextField(
//                 obscureText: true,
//                 autocorrect: false,
//                 enableSuggestions: false,
//                 controller: _password,
//                 decoration: InputDecoration(
//                   labelText: 'Password',
//                   floatingLabelBehavior: FloatingLabelBehavior.always,
//                   suffixIcon: const Icon(Icons.visibility_off),
//                   hintText: 'input your password here',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(29),
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 30,
//               ),
//               GestureDetector(
//                 onTap: () async {
//                   final email = _email.text;
//                   final password = _password.text;
//                   context.read<AuthBloc>().add(AuthEventRegister(
//                         email,
//                         password,
//                       ));
//                 },
//                 child: Container(
//                   width: 350,
//                   padding: const EdgeInsets.symmetric(vertical: 18),
//                   decoration: BoxDecoration(
//                       color: Colors.blue,
//                       borderRadius: BorderRadius.circular(29)),
//                   child: const Center(
//                     child: Text(
//                       'Register',
//                       style: TextStyle(
//                         fontSize: 20,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 30,
//               ),
//               GestureDetector(
//                 onTap: () {
//                   context.read<AuthBloc>().add(const AuthEventLogOut());
//                 },
//                 child: RichText(
//                   text: TextSpan(children: [
//                     TextSpan(
//                         text: ' Registered?',
//                         style: TextStyle(
//                             color: Colors.black.withOpacity(0.6),
//                             fontSize: 12)),
//                     const TextSpan(
//                         text: ' Login',
//                         style: TextStyle(color: Colors.blue, fontSize: 13))
//                   ]),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
