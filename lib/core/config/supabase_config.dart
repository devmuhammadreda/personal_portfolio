/// Supabase project credentials.
///
/// Both values are public by design (the anon key only grants access
/// that Row Level Security allows anyway). Paste them from
/// Supabase Dashboard › Project Settings › API.
abstract final class SupabaseConfig {
  static const String url = 'https://qfcinqppranpnqkoznoe.supabase.co';
  static const String anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFmY2lucXBwcmFucG5xa296bm9lIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODc2NTI0NDgsImV4cCI6MjEwMzIyODQ0OH0.9fLN_hv_BsacoPxvpEj4qEEnBdO1EaOcbWODW8yBoUw';

  /// Storage bucket holding profile photos, resumes and screenshots.
  static const String mediaBucket = 'portfolio-media';

  static bool get isConfigured =>
      !url.startsWith('https://qfcinqppranpnqkoznoe.supabase.co') &&
      anonKey !=
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFmY2lucXBwcmFucG5xa296bm9lIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODc2NTI0NDgsImV4cCI6MjEwMzIyODQ0OH0.9fLN_hv_BsacoPxvpEj4qEEnBdO1EaOcbWODW8yBoUw' &&
      url.isNotEmpty &&
      anonKey.isNotEmpty;
}
// database password = qfXF#+3/=M287X2
