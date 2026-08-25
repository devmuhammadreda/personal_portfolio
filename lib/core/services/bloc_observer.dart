import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Logs every cubit's lifecycle and state changes — ported from the
/// tamweely_voting codebase (`MyBlocObserver`). Debug builds only.
///
/// Wire up once before `runApp`: `Bloc.observer = AppBlocObserver();`
final class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    _log('created', bloc);
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    if (change.currentState == change.nextState) return;
    _log(
      '${change.runtimeType}: ${_brief(change.currentState)} → '
      '${_brief(change.nextState)}',
      bloc,
    );
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    _log('closed', bloc);
    super.onClose(bloc);
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    debugPrint('❌ [${bloc.runtimeType}] error: $error');
    super.onError(bloc, error, stackTrace);
  }

  /// Keeps long states (e.g. big project lists) readable in the console.
  String _brief(Object? state) {
    final String text = '$state';
    return text.length > 120 ? '${text.substring(0, 120)}…' : text;
  }

  void _log(String event, BlocBase<dynamic> bloc) {
    if (kDebugMode) debugPrint('🧱 [${bloc.runtimeType}] $event');
  }
}
