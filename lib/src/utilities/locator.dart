import 'package:get_it/get_it.dart';
import 'package:notes/src/bloc/todo/todo_cubit.dart';
import 'package:notes/src/utilities/logging_helper.dart';

import '../bloc/app/app_cubit.dart';
import '../bloc/auth/auth_bloc.dart';
import '../data/provider/auth/firebase_auth_provider.dart';
import '../theme/theme_model.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupLocator() async {
  getIt.registerLazySingleton<ThemeModel>( ThemeModel.create);
  getIt.registerLazySingleton<AppCubit>(() => AppCubit());
  getIt.registerLazySingleton<TodoCubit>(() => TodoCubit());
  getIt.registerSingleton<AuthBloc>(AuthBloc(FirebaseAuthProvider()));
  getIt.registerSingleton<LoggingHelper>(LoggingHelper());
}
