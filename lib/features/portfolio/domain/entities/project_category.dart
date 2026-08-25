enum ProjectCategory {
  mobile('mobile'),
  web('web'),
  fullstack('fullstack');

  const ProjectCategory(this.value);

  final String value;

  static ProjectCategory fromValue(String value) =>
      ProjectCategory.values.firstWhere(
        (category) => category.value == value,
        orElse: () => ProjectCategory.mobile,
      );
}
