///AuthProvider is like a contract that any FirebaseAuthProvider...
///...must conform to the functionality stated here

import 'auth_user.dart';

abstract class AuthProvider {
  //this is a getter that allow us to get the current user from firebase
  //this abstract class of AuthProvider must be able to allow us to get the currentUser
  AuthUser? get currentUser;


  //a login
  Future<AuthUser> login({
    required String email,

    required String password,
  });

  //a register
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });

  ///logout
  Future<void> logout();

  //send email verification
  Future<void> sendEmailVerification();

  Future<void> initialise();
}

