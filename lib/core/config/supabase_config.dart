/// Supabase project credentials.
///
/// Both values are public by design (the anon key only grants access
/// that Row Level Security allows anyway). Paste them from
/// Supabase Dashboard › Project Settings › API.
abstract final class SupabaseConfig {
  static const String url = 'https://YOUR-PROJECT.supabase.co';
  static const String anonKey = 'YOUR-ANON-KEY';

  /// Storage bucket holding profile photos, resumes and screenshots.
  static const String mediaBucket = 'portfolio-media';

  static bool get isConfigured =>
      !url.startsWith('https://YOUR-PROJECT') &&
      anonKey != 'YOUR-ANON-KEY' &&
      url.isNotEmpty &&
      anonKey.isNotEmpty;
}
