import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;

@immutable  //immutable means none of the property of this class or that which will extend it can't be change

class AuthUser{ // AuthUser is actually we creating an instance of a user from firebase but it has been customized to provider it verification status
  final bool isEmailVerified;
  const AuthUser(this.isEmailVerified);


  factory AuthUser.fromFirebase(User user) => AuthUser(user.emailVerified);
  //this factory constructor takes in the user from firebase and return an instance of the class AuthUser with the state of the user verification;
}

