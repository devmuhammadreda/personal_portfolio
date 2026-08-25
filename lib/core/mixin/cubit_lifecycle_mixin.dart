import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Lifecycle utilities for Cubits, ported from the tamweely_voting
/// codebase and adapted: the dio [CancelToken] helpers were dropped
/// because this project talks to Firestore/Firebase Storage, which offer
/// no cancellation tokens.
///
/// Mix it into every cubit that performs async work:
///
/// ```dart
/// final class PortfolioCubit extends Cubit<PortfolioState>
///     with CubitLifecycleMixin<PortfolioState> { ... }
/// ```
mixin CubitLifecycleMixin<S> on Cubit<S> {
  final Map<String, Timer> _debounceTimers = {};

  /// Emits only while the cubit is still open.
  ///
  /// Prevents "Cannot emit new states after calling close" when an async
  /// operation settles after the widget tree has disposed the cubit.
  /// Use this instead of [emit] everywhere, especially after `await`.
  void safeEmit(S state) {
    if (!isClosed) emit(state);
  }

  /// Runs [action], retrying up to [maxRetries] times on failure.
  ///
  /// Rethrows the last error once retries are exhausted; returns null
  /// only when the action itself completes without a value.
  Future<T?> withRetry<T>({
    required Future<T?> Function() action,
    int maxRetries = 2,
    Duration delayBetween = const Duration(seconds: 2),
  }) async {
    var attempts = 0;
    while (attempts <= maxRetries) {
      try {
        return await action();
      } catch (_) {
        if (attempts >= maxRetries) rethrow;
        attempts++;
        await Future<void>.delayed(delayBetween);
      }
    }
    return null;
  }

  /// Debounces an action behind [id]; a new call cancels the pending one.
  ///
  /// ```dart
  /// void search(String query) => debounce(
  ///   id: 'project-search',
  ///   duration: const Duration(milliseconds: 350),
  ///   action: () => _performSearch(query),
  /// );
  /// ```
  void debounce({
    required String id,
    required Duration duration,
    required VoidCallback action,
  }) {
    _debounceTimers[id]?.cancel();
    _debounceTimers[id] = Timer(duration, action);
  }

  @override
  Future<void> close() {
    for (final timer in _debounceTimers.values) {
      timer.cancel();
    }
    _debounceTimers.clear();
    return super.close();
  }
}
