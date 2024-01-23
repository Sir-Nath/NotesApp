
import '../../../model/auth/auth_user.dart';

///AuthProvider is like a contract that any FirebaseAuthProvider...
///...must conform to the functionality stated here


abstract class AuthProvider {
  //this is a getter that allow us to get the current user from firebase
  //this abstract class of AuthProvider must be able to allow us to get the currentUser
  AuthUser? get currentUser;

  //a register
  Future<AuthUser> createUser({
    required String email,
    required String password,
    required String name
  });

  //a login
  Future<AuthUser> login({
    required String email,
    required String password,
  });

  ///logout
  Future<void> logout();

  //send email verification
  Future<void> sendEmailVerification();

  Future<void> initialise();

  Future<void> sendPasswordReset({required String toEmail});
}

