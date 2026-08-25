import 'env.dart';

/// Facade over [Env] consumed by the bootstrapper and repositories.
///
/// The URL + anon key are public by design (the anon key only grants
/// what Row Level Security allows) — but they live in the git-ignored
/// `.env` so project values never hardcode into source control.
/// NEVER put the database password or service-role key in `.env` code
/// paths; both grant full admin access.
abstract final class SupabaseConfig {
  static String get url => Env.url;

  static String get anonKey => Env.anonKey;

  /// Storage bucket holding profile photos, resumes and screenshots.
  static const String mediaBucket = 'portfolio-media';

  static bool get isConfigured =>
      url.startsWith('https://') &&
      !url.contains('YOUR-PROJECT') &&
      anonKey != 'YOUR-ANON-KEY' &&
      url.isNotEmpty &&
      anonKey.isNotEmpty;
}
