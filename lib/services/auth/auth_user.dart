import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;

@immutable //immutable means none of the property of this class or that which will extend it can't be change

class AuthUser {
  // AuthUser is actually creating an instance of a user from firebase but it has been customized to provider it verification status
  final bool isEmailVerified;
  final String? email;
  const AuthUser({
    required this.isEmailVerified,
    required this.email,
  });

  //this factory constructor requires a parameter user of type User and in turn return an instance of class AuthUser with the bool parameter needed
  factory AuthUser.fromFirebase(User user) => AuthUser(
        isEmailVerified: user.emailVerified,
        email: user.email,
      );
  //this factory constructor takes in the user from firebase and return an instance of the class AuthUser with the state of the user verification;
}
