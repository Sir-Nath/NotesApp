part of 'app_cubit.dart';

class AppState extends Equatable {
  final int pageIndex;
  final ThemeModel theme;

  const AppState({
    required this.pageIndex,
    required this.theme,
  });

  factory AppState.initial() => AppState(
        pageIndex: 0,
        theme: ThemeModel.initial(),
      );

  AppState copyWith({
    int? pageIndex,
    ThemeModel? theme,
  }) {
    return AppState(
      pageIndex: pageIndex ?? this.pageIndex,
      theme: theme ?? this.theme,
    );
  }

  @override
  List<Object?> get props => [pageIndex, theme];
}
