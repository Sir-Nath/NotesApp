import 'package:flutter/material.dart';

@immutable
class AuthEvent{
  const AuthEvent();
}

//on app loading
class AuthEventInitialize extends AuthEvent{
  const AuthEventInitialize();
}

//login button
class AuthEventLogIn extends AuthEvent{
  final String email;
  final String password;
  const AuthEventLogIn(this.email, this.password);
}

//logout button
class AuthEventLogOut extends AuthEvent{
  const AuthEventLogOut();
}

//send verification and on signing up
class AuthEventSendEmailVerification extends AuthEvent{
const  AuthEventSendEmailVerification();
}

class AuthEventGoToNotes extends AuthEvent{
  const AuthEventGoToNotes();
}

//register button
class AuthEventRegister extends AuthEvent{
  final String email;
  final String password;
  final String name;
  const AuthEventRegister(this.email, this.password, this.name);
}

class AuthEventShouldRegister extends AuthEvent{
  const AuthEventShouldRegister();
}

//forgot password button
class AuthEventForgotPassword extends AuthEvent{
  final String? email;
  const AuthEventForgotPassword({this.email});
}
