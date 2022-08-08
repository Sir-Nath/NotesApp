
import 'package:bloc/bloc.dart';
import 'package:notes/services/auth/auth_provider.dart';
import 'package:notes/services/auth/bloc/auth_event.dart';
import 'package:notes/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(
          const AuthStateLoading(),
        ) {
    //Initialize
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialise();
      final user = provider.currentUser;
      if (user == null) {
        emit(
          const AuthStateLoggedOut(),
        );
      } else if (!user.isEmailVerified) {
        emit(
          const AuthStateNeedVerification(),
        );
      } else {
        emit(
          AuthStateLoggedIn(user),
        );
      }
    });

    //Log in
    on<AuthEventLogIn>((event, emit) async {
      emit(const AuthStateLoading());
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.login(
          email: email,
          password: password,
        );
        emit(
          AuthStateLoggedIn(user),
        );
      } on Exception catch (e) {
        emit(AuthStateLoggedInFailure(e));
      }
    });

    //log out
    on<AuthEventLogOut>((event, emit) async {
      emit(const AuthStateLoading());
      try {
        await provider.logout();
        emit(const AuthStateLoggedOut());
      } on Exception catch (e) {
        emit(AuthStateLoggedOutFailure(e));
      }
    });
  }
}
