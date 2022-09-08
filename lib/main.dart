import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:notes/src/constants/routes/route.dart';
import 'package:notes/src/bloc/auth/auth_bloc.dart';
import 'package:notes/src/data/provider/auth/firebase_auth_provider.dart';
import 'package:notes/src/theme/theme_model.dart';
import 'package:notes/src/utilities/locator.dart';
import 'package:notes/src/utilities/observer.dart';
import 'package:notes/src/view/auth/forgot_password_view.dart';
import 'package:notes/src/view/auth/login_view.dart';
import 'package:notes/src/view/note/note_editor.dart';
import 'package:notes/bin/bin/note_screen.dart';
import 'package:notes/src/view/auth/register_view.dart';
import 'package:notes/bin/verify_email_screen/email_verification_screen_page.dart';
import 'package:notes/src/view/app_navigator.dart';
import 'package:path_provider/path_provider.dart';
import 'src/bloc/app/app_cubit.dart';
import 'src/bloc/auth/auth_event.dart';
import 'src/bloc/auth/auth_state.dart';
import 'src/bloc/todo/todo_cubit.dart';
import 'src/constants/helpers/loading/loading_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ThemeModel.create();
  setupLocator();

  Bloc.observer = Observer();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AppCubit>(
          create: (context) => AppCubit()..createThemeModel(),
          lazy: false,
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            FirebaseAuthProvider(),
          ),
        ),
        BlocProvider<TodoCubit>(
          create: (context) => TodoCubit(),
        ),
      ],
      child: BlocBuilder<AppCubit, AppState>(
        buildWhen: (previous, current) {
          return previous.theme != current.theme;
        },
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: state.theme.light,
            darkTheme: state.theme.dark,
            themeMode: state.theme.mode,
            home: BlocProvider<AuthBloc>.value(
              value: BlocProvider.of<AuthBloc>(context),
              child: const HomePage(),
            ),
            builder: EasyLoading.init(),
            routes: {
              createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView()
            },
          );
        },
      ),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
              context: context,
              text: state.loadingText ?? 'Please wait a moment');
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const AppNavigator();
        } else if (state is AuthStateNeedVerification) {
          return const EmailVerificationScreenPage();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        } else if (state is AuthStateNotePage) {
          return const NotesView();
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
      listenWhen: (previou, current) {
        return current != previou;
      },
      buildWhen: (previous, current) {
        return previous != current;
      },
    );
  }
}
