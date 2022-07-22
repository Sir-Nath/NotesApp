///AuthProvider is like a contract that any FirebaseAuthProvider...
///...must conform to the functionality stated here

import 'auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;

  Future<AuthUser> login({
    required String email,
    required String password,
  });
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });
  Future<void> logout();

  Future<void> sendEmailVerification();
}
