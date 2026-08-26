// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get commonRetry => 'Try again';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonClose => 'Close';

  @override
  String get commonRemove => 'Remove';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonErrorGeneric => 'Something went wrong.';

  @override
  String get loadingPortfolio => 'Loading portfolio…';

  @override
  String get errorLoadingPortfolio =>
      'Something went wrong while loading the portfolio.';

  @override
  String get navAbout => 'About';

  @override
  String get navExperience => 'Experience';

  @override
  String get navEducation => 'Education';

  @override
  String get navProjects => 'Projects';

  @override
  String get navContact => 'Contact';

  @override
  String get navMenuTooltip => 'Menu';

  @override
  String get heroGreeting => 'Hi there, I’m';

  @override
  String get heroNameFallback => 'Flutter Developer';

  @override
  String get heroTitleFallback =>
      'Building beautiful apps, one widget at a time';

  @override
  String get heroViewWork => 'View My Work';

  @override
  String get heroDownloadCv => 'Download CV';

  @override
  String get heroContactMe => 'Contact Me';

  @override
  String get heroAvailableForWork => 'Available for work';

  @override
  String get aboutSectionTitle => 'About Me';

  @override
  String get aboutBioFallback =>
      'This bio lives in Firestore and updates without redeploying — add your story to see it here.';

  @override
  String get aboutTechHeading => 'Tech I work with';

  @override
  String get statYearsLabel => 'Years of experience';

  @override
  String get statProjectsLabel => 'Shipped projects';

  @override
  String get statTechnologiesLabel => 'Technologies';

  @override
  String get experienceSectionTitle => 'Work Experience';

  @override
  String get educationSectionTitle => 'Education';

  @override
  String get timelinePresent => 'Present';

  @override
  String get experienceEmptyPublic =>
      'No work experience added yet — check back soon!';

  @override
  String get educationEmptyPublic =>
      'No education history added yet — check back soon!';

  @override
  String get projectsSectionTitle => 'Projects';

  @override
  String get projectsEmptyPublic => 'No projects here yet — check back soon!';

  @override
  String get projectsFilterAll => 'All';

  @override
  String get projectCardViewDetails => 'View details';

  @override
  String get projectCardFeaturedBadge => 'Featured';

  @override
  String get projectDetailsBarrierLabel => 'Project details';

  @override
  String projectDetailsRole(String role) {
    return 'My role — $role';
  }

  @override
  String get projectDetailsGooglePlay => 'Google Play';

  @override
  String get projectDetailsAppStore => 'App Store';

  @override
  String footerCopyright(int year, String name) {
    return '© $year $name. Built with Flutter.';
  }

  @override
  String get contactSectionTitle => 'Contact';

  @override
  String get contactHeading => 'Let’s build something together.';

  @override
  String get contactSubtitle =>
      'Have a project in mind or just want to say hi? My inbox is always open.';

  @override
  String get contactFormName => 'Your name';

  @override
  String get contactFormEmail => 'Your email';

  @override
  String get contactFormPhone => 'Phone number (optional)';

  @override
  String get contactFormPhoneInvalid => 'Enter a valid phone number.';

  @override
  String get contactFormMessage => 'Message';

  @override
  String get contactFormNameRequired => 'Please enter your name.';

  @override
  String get contactFormEmailInvalid => 'Please enter a valid email.';

  @override
  String get contactFormMessageShort =>
      'Tell me a bit more (min. 10 characters).';

  @override
  String get contactSendMessage => 'Send message';

  @override
  String get contactSending => 'Sending…';

  @override
  String get contactSentSnackbar =>
      'Message sent — I\'ll get back to you soon!';

  @override
  String get adminSignInTitle => 'Admin sign-in';

  @override
  String get adminSignInSubtitle => 'Restricted area — owner access only.';

  @override
  String get fieldEmail => 'Email';

  @override
  String get fieldPassword => 'Password';

  @override
  String get emailInvalid => 'Enter a valid email.';

  @override
  String get passwordTooShort => 'At least 6 characters.';

  @override
  String get signInFailed => 'Sign-in failed. Please try again.';

  @override
  String get shellDashboard => 'Dashboard';

  @override
  String get shellProfile => 'Profile';

  @override
  String get shellProjects => 'Projects';

  @override
  String get shellMessages => 'Messages';

  @override
  String get shellExperience => 'Experience';

  @override
  String get shellEducation => 'Education';

  @override
  String get shellConsoleTitle => 'Admin console';

  @override
  String get shellSignOut => 'Sign out';

  @override
  String get dashboardOverview => 'Overview';

  @override
  String get dashboardTotalProjects => 'Total projects';

  @override
  String get dashboardFeaturedCount => 'Featured';

  @override
  String get dashboardRecentlyUpdated => 'Recently updated';

  @override
  String get dashboardNewProject => 'New project';

  @override
  String get dashboardEmptyProjects => 'No projects yet. Add your first one!';

  @override
  String get dashboardFailedToLoad => 'Failed to load.';

  @override
  String get updatedToday => 'today';

  @override
  String get updatedYesterday => 'yesterday';

  @override
  String get profileEditorTitle => 'Edit profile';

  @override
  String get profileSaveChanges => 'Save changes';

  @override
  String get profileSaving => 'Saving…';

  @override
  String get profileFailedToLoad => 'Failed to load profile.';

  @override
  String get profileBasicsHeading => 'Basics';

  @override
  String get fieldName => 'Name';

  @override
  String get fieldTitle => 'Title';

  @override
  String get fieldTagline => 'Tagline';

  @override
  String get fieldYearsOfExperience => 'Years of experience';

  @override
  String get fieldAboutMe => 'About me';

  @override
  String get availableSwitchTitle => 'Available for work';

  @override
  String get availableSwitchSubtitle =>
      'Shows the green badge in the hero section';

  @override
  String get skillsHeading => 'Skills';

  @override
  String get skillGroupsAdd => 'Add category';

  @override
  String skillGroupLabel(int index) {
    return 'Category $index';
  }

  @override
  String get skillGroupHint => 'e.g. Mobile, Backend, Tools';

  @override
  String get skillsAdd => 'Add skill';

  @override
  String get skillsEmpty =>
      'No skills yet — add the technologies you work with.';

  @override
  String skillLabel(int index) {
    return 'Skill $index';
  }

  @override
  String get livePreviewTitle => 'Live preview';

  @override
  String get livePreviewHint => 'updates as you type';

  @override
  String get livePreviewNameFallback => 'Your name';

  @override
  String get livePreviewTitleFallback => 'Your title';

  @override
  String get livePreviewEmptySkills => 'No skills yet — add some below.';

  @override
  String projectsAdminCount(int count) {
    return 'Projects ($count)';
  }

  @override
  String get projectsAdminNew => 'New project';

  @override
  String get projectsAdminReorderHint =>
      'Drag rows to reorder — applies to the public site instantly.';

  @override
  String get projectsAdminEmpty => 'No projects yet. Create your first one!';

  @override
  String get projectsAdminFailedToLoad => 'Failed to load projects.';

  @override
  String get tooltipFeature => 'Feature';

  @override
  String get tooltipUnfeature => 'Unfeature';

  @override
  String deleteProjectTitle(String title) {
    return 'Delete \"$title\"?';
  }

  @override
  String get deleteProjectBody =>
      'This permanently removes the project from the public site. This action cannot be undone.';

  @override
  String get formRoleField => 'Your role';

  @override
  String get formShortDescription => 'Short description *';

  @override
  String get formShortDescriptionRequired => 'Short description is required.';

  @override
  String get formShortDescriptionHelper => 'Shown on the project card';

  @override
  String get formFullDescription => 'Full description';

  @override
  String get formFeaturedSwitchTitle => 'Featured project';

  @override
  String get formFeaturedSwitchSubtitle =>
      'Highlights it on cards and the dashboard';

  @override
  String get formTechStack => 'Tech stack';

  @override
  String get formTechStackHelper => 'Type a technology and press Add';

  @override
  String get formTechStackEmpty => 'No technologies added yet.';

  @override
  String formScreenshotsCount(int count) {
    return 'Screenshots ($count)';
  }

  @override
  String get formAddImages => 'Add images';

  @override
  String get formUploadingImages => 'Uploading…';

  @override
  String get formCoverHint => 'The first image is used as the card cover.';

  @override
  String get formNoScreenshots => 'No screenshots yet.';

  @override
  String get formCoverBadge => 'Cover';

  @override
  String get formLinksHeading => 'Links';

  @override
  String get formGooglePlayUrlField => 'Google Play URL';

  @override
  String get formAppStoreUrlField => 'App Store URL';

  @override
  String get categoryMobile => 'Mobile';

  @override
  String get categoryWeb => 'Web';

  @override
  String get categoryFullstack => 'Full-stack';

  @override
  String get signInButton => 'Sign in';

  @override
  String get signingIn => 'Signing in…';

  @override
  String updatedDaysAgo(int count) {
    return '${count}d ago';
  }

  @override
  String projectUpdatedLine(String category, String when) {
    return '$category · updated $when';
  }

  @override
  String get formTitleField => 'Title *';

  @override
  String get formTitleRequired => 'Title is required.';

  @override
  String get formCategoryField => 'Category';

  @override
  String messagesAdminCount(int count) {
    return 'Messages ($count)';
  }

  @override
  String messagesAdminUnreadCount(int count) {
    return '$count unread';
  }

  @override
  String get messagesAdminMarkAllRead => 'Mark all as read';

  @override
  String get messagesAdminEmpty =>
      'No messages yet — new contact form submissions land here.';

  @override
  String get messagesAdminFailedToLoad => 'Failed to load messages.';

  @override
  String get messagesAdminReply => 'Reply';

  @override
  String experiencesAdminCount(int count) {
    return 'Work experience ($count)';
  }

  @override
  String get experiencesAdminNew => 'New entry';

  @override
  String get experiencesAdminEmpty =>
      'No work experience yet. Add your first role!';

  @override
  String get experiencesAdminFailedToLoad => 'Failed to load work experience.';

  @override
  String educationsAdminCount(int count) {
    return 'Education ($count)';
  }

  @override
  String get educationsAdminNew => 'New entry';

  @override
  String get educationsAdminEmpty =>
      'No education history yet. Add your studies!';

  @override
  String get educationsAdminFailedToLoad => 'Failed to load education.';

  @override
  String get timelineReorderHint =>
      'Drag rows to reorder — applies to the public site instantly.';

  @override
  String get experienceFormNewHeading => 'New work experience';

  @override
  String get experienceFormEditHeading => 'Edit work experience';

  @override
  String get educationFormNewHeading => 'New education entry';

  @override
  String get educationFormEditHeading => 'Edit education entry';

  @override
  String get experienceSavedSnackbar => 'Experience entry saved ✓';

  @override
  String get educationSavedSnackbar => 'Education entry saved ✓';

  @override
  String deleteTimelineTitle(String title) {
    return 'Delete \"$title\"?';
  }

  @override
  String get deleteTimelineBody =>
      'This permanently removes the entry from the public site. This action cannot be undone.';

  @override
  String get formRequiredField => 'This field is required.';

  @override
  String get formCompanyField => 'Company *';

  @override
  String get formPositionField => 'Position *';

  @override
  String get formLocationField => 'Location';

  @override
  String get formEntryDescription => 'Description';

  @override
  String get formStartDateField => 'Start date';

  @override
  String get formEndDateField => 'End date';

  @override
  String get formCurrentWorkSwitchTitle => 'I currently work here';

  @override
  String get formCurrentStudySwitchTitle => 'I currently study here';

  @override
  String get formInstitutionField => 'Institution *';

  @override
  String get formDegreeField => 'Degree *';

  @override
  String get formFieldOfStudyField => 'Field of study';

  @override
  String get formGradeField => 'Grade / GPA';
}
