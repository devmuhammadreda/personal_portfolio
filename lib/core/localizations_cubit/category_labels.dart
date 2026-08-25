import '../../../features/portfolio/domain/entities/project_category.dart';
import '../../l10n/app_localizations.dart';

/// Presentation-level glue: localized names for [ProjectCategory].
/// Lives outside the domain entity so the domain stays Flutter-free.
extension CategoryLabelsX on AppLocalizations {
  String categoryLabel(ProjectCategory category) => switch (category) {
    ProjectCategory.mobile => categoryMobile,
    ProjectCategory.web => categoryWeb,
    ProjectCategory.fullstack => categoryFullstack,
  };
}
