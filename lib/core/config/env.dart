import 'package:envied/envied.dart';

part 'env.g.dart';

/// Compile-time secrets loaded from the git-ignored `.env` file.
///
/// Values are obfuscated into the binary by envied_generator — run
/// `dart run build_runner build --delete-conflicting-outputs`
/// after any `.env` change. See `.env.example` for the required keys.
@Envied(path: '.env', obfuscate: true)
abstract final class Env {
  @EnviedField(varName: 'SUPABASE_URL')
  static final String url = _Env.url;

  @EnviedField(varName: 'SUPABASE_ANON_KEY')
  static final String anonKey = _Env.anonKey;
}
