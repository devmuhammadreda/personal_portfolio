import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/supabase_config.dart';

/// Initialises Supabase and reports whether configuration is present so
/// the app can still boot (UI-only) before credentials are pasted into
/// [SupabaseConfig].
abstract final class SupabaseBootstrapper {
  static bool _configured = false;

  static bool get isConfigured => _configured;

  static Future<void> initialise() async {
    if (!SupabaseConfig.isConfigured) {
      debugPrint(
        'Supabase not configured — paste your project URL and anon key '
        'into lib/core/config/supabase_config.dart',
      );
      return;
    }
    try {
      await Supabase.initialize(
        url: SupabaseConfig.url,
        publishableKey: SupabaseConfig.anonKey,
      );
      _configured = true;
    } catch (error) {
      debugPrint('Supabase failed to initialise: $error');
    }
  }
}
