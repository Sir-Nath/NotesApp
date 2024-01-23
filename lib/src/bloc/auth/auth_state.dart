import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../model/auth/auth_user.dart';

@immutable
abstract class AuthState {
  //all state should have a loading parameter with loading text
  final bool isLoading;
  final String? loadingText;
  const AuthState({
    required this.isLoading,
    //default loading text is please wait a moment
    this.loadingText = 'please wait a moment',
  });
}

//to log in, i need auth user
class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn({
    required this.user,
    required super.isLoading,
  });
}

class AuthStateNeedVerification extends AuthState {
  const AuthStateNeedVerification({
    required super.isLoading,
  });
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  //user can be logged out with no exception and no loading: just logged out
  //user can be logged out with no exception and loading: trying to logout and processing
  //user can be logged out with exception: trying to login with error
  final Exception? exception;

  const AuthStateLoggedOut({
    required this.exception,
    required super.isLoading,
    super.loadingText = null,
  });

  @override
  List<Object?> get props => [exception, isLoading];
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized({
    required super.isLoading,
  });
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;
  const AuthStateRegistering({
    required this.exception,
    required isLoading,
  }) : super(isLoading: isLoading);
}

class AuthStateForgotPassword extends AuthState {
  final Exception? exception;
  final bool hasSentEmail;
  const AuthStateForgotPassword({
    required this.exception,
    required this.hasSentEmail,
    required super.isLoading,
  });
}

class AuthStateNotePage extends AuthState {
  const AuthStateNotePage({required super.isLoading});
}
