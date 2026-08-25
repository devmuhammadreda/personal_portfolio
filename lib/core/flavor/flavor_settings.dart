import 'package:flutter_flavor/flutter_flavor.dart';

/// Typed, null-safe access to per-flavor configuration declared in the
/// entry points via `FlavorConfig(variables: {...})` — the same pattern
/// the tamweely_voting app uses for its question-asset paths.
///
/// Entry points own the values; features read them only through here,
/// so variable keys exist in exactly two places (entry point + getter).
abstract final class FlavorSettings {
  static const String _flavorKey = 'flavor';
  static const String _collectionPrefixKey = 'tablePrefix';

  /// Identifier of the running flavor (`'portfolio'` / `'admin'`).
  static String get flavorId {
    final Object? value = FlavorConfig.instance.variables[_flavorKey];
    return value is String && value.isNotEmpty ? value : 'portfolio';
  }

  /// Optional prefix prepended to every Supabase table name.
  ///
  /// Lets a staging deployment of either flavor target isolated tables
  /// (`staging_profile`, `staging_projects`) without any code change —
  /// set `variables: {'tablePrefix': 'staging_'}` in the entry point.
  /// Empty by default → production tables.
  static String get tablePrefix {
    final Object? value = FlavorConfig.instance.variables[_collectionPrefixKey];
    return value is String ? value : '';
  }

  static String get profileTable => '${tablePrefix}profile';

  static String get projectsTable => '${tablePrefix}projects';

  static String get contactMessagesTable => '${tablePrefix}contact_messages';
}
