abstract final class FirestoreCollections {
  static const String profile = 'profile';
  static const String projects = 'projects';
}

abstract final class FirestoreDocs {
  static const String mainProfile = 'main';
}

abstract final class StoragePaths {
  static const String profileImages = 'profile/images';
  static const String projectImages = 'projects/images';
  static const String resumeFiles = 'profile/resume';
}

abstract final class AppRoutes {
  static const String home = '/';
  static const String adminLogin = '/admin/login';
  static const String adminDashboard = '/admin';
}
