///Checking through Firebase console we realize there are more than one authentication provider namely; email & password, google, facebook e.t.c
///so we need to create a firebaseAuthProvider which will be from another class called AuthProvider,
///where we state the functionality we expect all AuthProvider to render to be namely; current user, login, logout, send verification.
import 'package:firebase_core/firebase_core.dart';
import '../../firebase_options.dart';
import 'auth_user.dart';
import 'auth_provider.dart';
import 'auth_exception.dart';
import 'package:firebase_auth/firebase_auth.dart'

    show FirebaseAuth, FirebaseAuthException;

class FirebaseAuthProvider implements AuthProvider {


  //method createUser and login return a type AuthUser same as getter currentUser
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if(user != null){
        return user;
      }else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
       throw WeakPasswordAuthException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == 'invalid-email') {
      throw InvalidEmailAuthException();
      } else {
      throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
      //this return statement will return an instance of the AuthUser with a bool parameter which depends on the input user
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  })async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email, password: password,);
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundAuthException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  //the method logout and sendEmailVerification are returning nothing and their operation depends on an instance of Firebase.instance.currentUser

  @override
  Future<void> logout() async{
  final user = FirebaseAuth.instance.currentUser;
  if (user != null){
    await FirebaseAuth.instance.signOut();
  }else{
    throw UserNotLoggedInAuthException();
  }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> initialise() async{
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
