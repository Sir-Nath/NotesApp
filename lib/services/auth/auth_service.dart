import 'package:notes/services/auth/firebase_auth_provider.dart';

import 'auth_provider.dart';
import 'auth_user.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;

  AuthService(this.provider);

  //this is the factory constructor that makes it possible to implement the methods of FirebaseAuthProvider
  factory AuthService.firebase() =>
      AuthService(
        FirebaseAuthProvider(),
      );

  @override
  //the variable provider is of type AuthProvider
  // which means it can access the whole property of AuthProvider

  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) =>
      provider.createUser(
        email: email,
        password: password,
      );

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) =>
      provider.login(email: email, password: password);

  @override
  Future<void> logout() => provider.logout();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> initialise() => provider.initialise();
}