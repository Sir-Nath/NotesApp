import 'package:notes/constants/exception/auth/auth_exception.dart';
import 'package:notes/data/provider/auth/auth_provider.dart';
import 'package:notes/data/model/auth/auth_user.dart';
import "package:test/test.dart";

//study dependency injection

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();
    test('should not be initialized to begin with', () {
      expect(provider.isInitialized, false);
    });

    test('can not log out without initialized', () {
      expect(provider.logout(),
          throwsA(const TypeMatcher<NotInitializedException>()));
    });

    test('should initialize', () async {
      await provider.initialise();
      expect(provider.isInitialized, true);
    });

    test('user should  be null after initialization', () {
      expect(provider.currentUser, null);
    });

    test('should be able to initialize in less than 2 seconds', () async {
      await provider.initialise();
      expect(provider.isInitialized, true);
    }, timeout: const Timeout(Duration(seconds: 2)));

    test('Create user should delegate to login function', () async {
      final badEmailUser = provider.createUser(
        email: 'peter@gmail.com',
        password: 'anytesting',
      );
      expect(
        badEmailUser,
        throwsA(
          const TypeMatcher<UserNotFoundAuthException>(),
        ),
      );

      final badPasswordUser = provider.createUser(
        email: 'lucky@gmail.com',
        password: '1234567',
      );
      expect(
        badPasswordUser,
        throwsA(
          const TypeMatcher<WrongPasswordAuthException>(),
        ),
      );
      final user = await provider.createUser(email: 'any', password: 'user');
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test(
      'logged in user should be able to get verified',
      (){
        provider.sendEmailVerification();
        final user = provider.currentUser;
        expect(user, isNotNull);
        expect(user!.isEmailVerified, true);
      }
    );

    test('should be able to logout and in', ()async{
      await provider.logout();
      await provider.login(email: 'email', password: 'password');
      final user = provider.currentUser;
      expect(user, isNotNull );
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(Duration(seconds: 1));
    return login(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialise() async {
    await Future.delayed(Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) {
    if (!isInitialized) throw NotInitializedException();
    if (email == 'peter@gmail.com') throw UserNotFoundAuthException();
    if (password == '1234567') throw WrongPasswordAuthException();
    final user = AuthUser(isEmailVerified: false, email: '', id: 'my_id');
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logout() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    var email;
    var newUser = AuthUser(isEmailVerified: true, email: '', id: 'my Id');
    _user = newUser;
  }
}
