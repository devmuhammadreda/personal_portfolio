import 'package:flutter/foundation.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

import 'main.dart' as app;

/// Entry point for the **portfolio** flavor (the public website).
///
/// Config only — the shared bootstrap in `main.dart` owns every init
/// step. Ships zero admin surface: no auth, no admin routes, no admin
/// dependency graph. The banner label is shown in debug mode only.
Future<void> main() {
  FlavorConfig(
    name: kDebugMode ? 'PORTFOLIO' : '',
    variables: {'flavor': 'portfolio'},
  );
  return app.main();
}
