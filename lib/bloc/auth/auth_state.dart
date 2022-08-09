import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../data/model/auth/auth_user.dart';

@immutable
abstract class AuthState{
  const AuthState();
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn(this.user);
}

class AuthStateNeedVerification extends AuthState {
  const AuthStateNeedVerification();
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  //user can be logged out with no exception and no loading: just logged out
  //user can be logged out with no exception and loading: trying to logout and processing
  //user can be logged out with exception: trying to login with error
  final Exception? exception;
  final bool isLoading;
  const AuthStateLoggedOut({required this.exception, required this.isLoading});

  @override
  List<Object?> get props => [exception, isLoading];
}

class AuthStateUninitialized extends AuthState{
  const AuthStateUninitialized();
}

class AuthStateRegistering extends AuthState{
  final Exception? exception;
  const AuthStateRegistering(this.exception);
}