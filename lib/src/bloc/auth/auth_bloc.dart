import 'package:bloc/bloc.dart';
import 'package:notes/src/data/provider/auth/auth_provider.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(
          const AuthStateUninitialized(isLoading: true),
        ) {
    //send email verification
    on<AuthEventSendEmailVerification>((event, emit) async {
      await provider.sendEmailVerification();
      emit(state);
    });
    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;
      final name = event.name;
      try {
        await provider.createUser(email: email, password: password, name: name);
        await provider.sendEmailVerification();
        emit(
          const AuthStateNeedVerification(isLoading: false),
        );
      } on Exception catch (e) {
        emit(
          AuthStateRegistering(
            exception: e,
            isLoading: false,
          ),
        );
      }
    });
    //Initialize
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialise();
      final user = provider.currentUser;
      if (user == null) {
        emit(
          const AuthStateLoggedOut(exception: null, isLoading: false),
        );
      } else if (!user.isEmailVerified) {
        emit(
          const AuthStateNeedVerification(isLoading: false),
        );
      } else {
        emit(
          AuthStateLoggedIn(
            user: user,
            isLoading: false,
          ),
        );
      }
    });
    //Log in
    on<AuthEventLogIn>((event, emit) async {
      emit(const AuthStateLoggedOut(
        exception: null,
        isLoading: true,
        loadingText: 'Please wait while i log you in',
      ));
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.login(
          email: email,
          password: password,
        );
        if (!user.isEmailVerified) {
          emit(
            const AuthStateLoggedOut(
              exception: null,
              isLoading: false,
            ),
          );
          emit(
            const AuthStateNeedVerification(isLoading: false),
          );
        } else {
          emit(const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ));
          emit(
            AuthStateLoggedIn(
              user: user,
              isLoading: false,
            ),
          );
        }
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(exception: e, isLoading: false),
        );
      }
    });

    //log out
    on<AuthEventLogOut>((event, emit) async {
      try {
        await provider.logout();
        emit(
          const AuthStateLoggedOut(exception: null, isLoading: false),
        );
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(exception: e, isLoading: false),
        );
      }
    });

    on<AuthEventForgotPassword>((event, emit) async {
      emit(const AuthStateForgotPassword(
        exception: null,
        hasSentEmail: false,
        isLoading: false,
      ));
      final email = event.email;
      if (email == null) {
        return; //user just went to forgot password but did nothing
      }
      //user really forgot password and need to get it back
      emit(const AuthStateForgotPassword(
        exception: null,
        hasSentEmail: false,
        isLoading: true,
      ));
      bool didSendEmail;
      Exception? exception;
      try {
        await provider.sendPasswordReset(toEmail: email);
        didSendEmail = true;
        exception = null;
      } on Exception catch (e) {
        didSendEmail = false;
        exception = e;
      }
      emit(AuthStateForgotPassword(
        exception: exception,
        hasSentEmail: didSendEmail,
        isLoading: false,
      ));
    });
    on<AuthEventShouldRegister>((event, emit) {
      emit(const AuthStateRegistering(
        exception: null,
        isLoading: false,
      ));
    });
    on<AuthEventGoToNotes>((event, emit) {
      emit(const AuthStateNotePage(isLoading: false));
    });
  }
}
