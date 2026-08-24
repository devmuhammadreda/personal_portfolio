import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../../firebase_options.dart';

/// Initialises Firebase and reports whether configuration is present so the
/// app can still boot (UI-only) before `flutterfire configure` has been run.
abstract final class FirebaseBootstrapper {
  static bool _configured = false;

  static bool get isConfigured => _configured;

  static Future<void> initialise() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _configured = true;
    } on UnsupportedError catch (error) {
      debugPrint('Firebase not configured: ${error.message}');
    } on FirebaseException catch (error) {
      debugPrint('Firebase failed to initialise: ${error.message}');
    }
  }
}
