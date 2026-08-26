import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get commonRetry;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get commonRemove;

  /// No description provided for @commonAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get commonAdd;

  /// No description provided for @commonErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong.'**
  String get commonErrorGeneric;

  /// No description provided for @loadingPortfolio.
  ///
  /// In en, this message translates to:
  /// **'Loading portfolio…'**
  String get loadingPortfolio;

  /// No description provided for @errorLoadingPortfolio.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while loading the portfolio.'**
  String get errorLoadingPortfolio;

  /// No description provided for @navAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get navAbout;

  /// No description provided for @navExperience.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get navExperience;

  /// No description provided for @navEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get navEducation;

  /// No description provided for @navProjects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get navProjects;

  /// No description provided for @navContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get navContact;

  /// No description provided for @navMenuTooltip.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get navMenuTooltip;

  /// No description provided for @heroGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hi there, I’m'**
  String get heroGreeting;

  /// No description provided for @heroNameFallback.
  ///
  /// In en, this message translates to:
  /// **'Flutter Developer'**
  String get heroNameFallback;

  /// No description provided for @heroTitleFallback.
  ///
  /// In en, this message translates to:
  /// **'Building beautiful apps, one widget at a time'**
  String get heroTitleFallback;

  /// No description provided for @heroViewWork.
  ///
  /// In en, this message translates to:
  /// **'View My Work'**
  String get heroViewWork;

  /// No description provided for @heroDownloadCv.
  ///
  /// In en, this message translates to:
  /// **'Download CV'**
  String get heroDownloadCv;

  /// No description provided for @heroContactMe.
  ///
  /// In en, this message translates to:
  /// **'Contact Me'**
  String get heroContactMe;

  /// No description provided for @heroAvailableForWork.
  ///
  /// In en, this message translates to:
  /// **'Available for work'**
  String get heroAvailableForWork;

  /// No description provided for @aboutSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'About Me'**
  String get aboutSectionTitle;

  /// No description provided for @aboutBioFallback.
  ///
  /// In en, this message translates to:
  /// **'This bio lives in Firestore and updates without redeploying — add your story to see it here.'**
  String get aboutBioFallback;

  /// No description provided for @aboutTechHeading.
  ///
  /// In en, this message translates to:
  /// **'Tech I work with'**
  String get aboutTechHeading;

  /// No description provided for @statYearsLabel.
  ///
  /// In en, this message translates to:
  /// **'Years of experience'**
  String get statYearsLabel;

  /// No description provided for @statProjectsLabel.
  ///
  /// In en, this message translates to:
  /// **'Shipped projects'**
  String get statProjectsLabel;

  /// No description provided for @statTechnologiesLabel.
  ///
  /// In en, this message translates to:
  /// **'Technologies'**
  String get statTechnologiesLabel;

  /// No description provided for @experienceSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Work Experience'**
  String get experienceSectionTitle;

  /// No description provided for @educationSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get educationSectionTitle;

  /// No description provided for @timelinePresent.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get timelinePresent;

  /// No description provided for @experienceEmptyPublic.
  ///
  /// In en, this message translates to:
  /// **'No work experience added yet — check back soon!'**
  String get experienceEmptyPublic;

  /// No description provided for @educationEmptyPublic.
  ///
  /// In en, this message translates to:
  /// **'No education history added yet — check back soon!'**
  String get educationEmptyPublic;

  /// No description provided for @projectsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get projectsSectionTitle;

  /// No description provided for @projectsEmptyPublic.
  ///
  /// In en, this message translates to:
  /// **'No projects here yet — check back soon!'**
  String get projectsEmptyPublic;

  /// No description provided for @projectsFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get projectsFilterAll;

  /// No description provided for @projectCardViewDetails.
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get projectCardViewDetails;

  /// No description provided for @projectCardFeaturedBadge.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get projectCardFeaturedBadge;

  /// No description provided for @projectDetailsBarrierLabel.
  ///
  /// In en, this message translates to:
  /// **'Project details'**
  String get projectDetailsBarrierLabel;

  /// No description provided for @projectDetailsRole.
  ///
  /// In en, this message translates to:
  /// **'My role — {role}'**
  String projectDetailsRole(String role);

  /// No description provided for @projectDetailsLiveDemo.
  ///
  /// In en, this message translates to:
  /// **'Live demo'**
  String get projectDetailsLiveDemo;

  /// No description provided for @projectDetailsSourceCode.
  ///
  /// In en, this message translates to:
  /// **'Source code'**
  String get projectDetailsSourceCode;

  /// No description provided for @footerCopyright.
  ///
  /// In en, this message translates to:
  /// **'© {year} {name}. Built with Flutter.'**
  String footerCopyright(int year, String name);

  /// No description provided for @contactSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contactSectionTitle;

  /// No description provided for @contactHeading.
  ///
  /// In en, this message translates to:
  /// **'Let’s build something together.'**
  String get contactHeading;

  /// No description provided for @contactSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Have a project in mind or just want to say hi? My inbox is always open.'**
  String get contactSubtitle;

  /// No description provided for @contactFormName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get contactFormName;

  /// No description provided for @contactFormEmail.
  ///
  /// In en, this message translates to:
  /// **'Your email'**
  String get contactFormEmail;

  /// No description provided for @contactFormPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone number (optional)'**
  String get contactFormPhone;

  /// No description provided for @contactFormPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number.'**
  String get contactFormPhoneInvalid;

  /// No description provided for @contactFormMessage.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get contactFormMessage;

  /// No description provided for @contactFormNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name.'**
  String get contactFormNameRequired;

  /// No description provided for @contactFormEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email.'**
  String get contactFormEmailInvalid;

  /// No description provided for @contactFormMessageShort.
  ///
  /// In en, this message translates to:
  /// **'Tell me a bit more (min. 10 characters).'**
  String get contactFormMessageShort;

  /// No description provided for @contactSendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send message'**
  String get contactSendMessage;

  /// No description provided for @contactSending.
  ///
  /// In en, this message translates to:
  /// **'Sending…'**
  String get contactSending;

  /// No description provided for @contactSentSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Message sent — I\'ll get back to you soon!'**
  String get contactSentSnackbar;

  /// No description provided for @adminSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Admin sign-in'**
  String get adminSignInTitle;

  /// No description provided for @adminSignInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Restricted area — owner access only.'**
  String get adminSignInSubtitle;

  /// No description provided for @fieldEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get fieldEmail;

  /// No description provided for @fieldPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get fieldPassword;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email.'**
  String get emailInvalid;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'At least 6 characters.'**
  String get passwordTooShort;

  /// No description provided for @signInFailed.
  ///
  /// In en, this message translates to:
  /// **'Sign-in failed. Please try again.'**
  String get signInFailed;

  /// No description provided for @shellDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get shellDashboard;

  /// No description provided for @shellProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get shellProfile;

  /// No description provided for @shellProjects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get shellProjects;

  /// No description provided for @shellMessages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get shellMessages;

  /// No description provided for @shellExperience.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get shellExperience;

  /// No description provided for @shellEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get shellEducation;

  /// No description provided for @shellConsoleTitle.
  ///
  /// In en, this message translates to:
  /// **'Admin console'**
  String get shellConsoleTitle;

  /// No description provided for @shellSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get shellSignOut;

  /// No description provided for @dashboardOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get dashboardOverview;

  /// No description provided for @dashboardTotalProjects.
  ///
  /// In en, this message translates to:
  /// **'Total projects'**
  String get dashboardTotalProjects;

  /// No description provided for @dashboardFeaturedCount.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get dashboardFeaturedCount;

  /// No description provided for @dashboardRecentlyUpdated.
  ///
  /// In en, this message translates to:
  /// **'Recently updated'**
  String get dashboardRecentlyUpdated;

  /// No description provided for @dashboardNewProject.
  ///
  /// In en, this message translates to:
  /// **'New project'**
  String get dashboardNewProject;

  /// No description provided for @dashboardEmptyProjects.
  ///
  /// In en, this message translates to:
  /// **'No projects yet. Add your first one!'**
  String get dashboardEmptyProjects;

  /// No description provided for @dashboardFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load.'**
  String get dashboardFailedToLoad;

  /// No description provided for @updatedToday.
  ///
  /// In en, this message translates to:
  /// **'today'**
  String get updatedToday;

  /// No description provided for @updatedYesterday.
  ///
  /// In en, this message translates to:
  /// **'yesterday'**
  String get updatedYesterday;

  /// No description provided for @profileEditorTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get profileEditorTitle;

  /// No description provided for @profileSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get profileSaveChanges;

  /// No description provided for @profileSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get profileSaving;

  /// No description provided for @profileFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load profile.'**
  String get profileFailedToLoad;

  /// No description provided for @profileBasicsHeading.
  ///
  /// In en, this message translates to:
  /// **'Basics'**
  String get profileBasicsHeading;

  /// No description provided for @fieldName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get fieldName;

  /// No description provided for @fieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get fieldTitle;

  /// No description provided for @fieldTagline.
  ///
  /// In en, this message translates to:
  /// **'Tagline'**
  String get fieldTagline;

  /// No description provided for @fieldYearsOfExperience.
  ///
  /// In en, this message translates to:
  /// **'Years of experience'**
  String get fieldYearsOfExperience;

  /// No description provided for @fieldAboutMe.
  ///
  /// In en, this message translates to:
  /// **'About me'**
  String get fieldAboutMe;

  /// No description provided for @availableSwitchTitle.
  ///
  /// In en, this message translates to:
  /// **'Available for work'**
  String get availableSwitchTitle;

  /// No description provided for @availableSwitchSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Shows the green badge in the hero section'**
  String get availableSwitchSubtitle;

  /// No description provided for @skillsHeading.
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get skillsHeading;

  /// No description provided for @skillsAdd.
  ///
  /// In en, this message translates to:
  /// **'Add skill'**
  String get skillsAdd;

  /// No description provided for @skillsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No skills yet — add the technologies you work with.'**
  String get skillsEmpty;

  /// No description provided for @skillLabel.
  ///
  /// In en, this message translates to:
  /// **'Skill {index}'**
  String skillLabel(int index);

  /// No description provided for @livePreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Live preview'**
  String get livePreviewTitle;

  /// No description provided for @livePreviewHint.
  ///
  /// In en, this message translates to:
  /// **'updates as you type'**
  String get livePreviewHint;

  /// No description provided for @livePreviewNameFallback.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get livePreviewNameFallback;

  /// No description provided for @livePreviewTitleFallback.
  ///
  /// In en, this message translates to:
  /// **'Your title'**
  String get livePreviewTitleFallback;

  /// No description provided for @livePreviewEmptySkills.
  ///
  /// In en, this message translates to:
  /// **'No skills yet — add some below.'**
  String get livePreviewEmptySkills;

  /// No description provided for @projectsAdminCount.
  ///
  /// In en, this message translates to:
  /// **'Projects ({count})'**
  String projectsAdminCount(int count);

  /// No description provided for @projectsAdminNew.
  ///
  /// In en, this message translates to:
  /// **'New project'**
  String get projectsAdminNew;

  /// No description provided for @projectsAdminReorderHint.
  ///
  /// In en, this message translates to:
  /// **'Drag rows to reorder — applies to the public site instantly.'**
  String get projectsAdminReorderHint;

  /// No description provided for @projectsAdminEmpty.
  ///
  /// In en, this message translates to:
  /// **'No projects yet. Create your first one!'**
  String get projectsAdminEmpty;

  /// No description provided for @projectsAdminFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load projects.'**
  String get projectsAdminFailedToLoad;

  /// No description provided for @tooltipFeature.
  ///
  /// In en, this message translates to:
  /// **'Feature'**
  String get tooltipFeature;

  /// No description provided for @tooltipUnfeature.
  ///
  /// In en, this message translates to:
  /// **'Unfeature'**
  String get tooltipUnfeature;

  /// No description provided for @deleteProjectTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{title}\"?'**
  String deleteProjectTitle(String title);

  /// No description provided for @deleteProjectBody.
  ///
  /// In en, this message translates to:
  /// **'This permanently removes the project from the public site. This action cannot be undone.'**
  String get deleteProjectBody;

  /// No description provided for @formRoleField.
  ///
  /// In en, this message translates to:
  /// **'Your role'**
  String get formRoleField;

  /// No description provided for @formShortDescription.
  ///
  /// In en, this message translates to:
  /// **'Short description *'**
  String get formShortDescription;

  /// No description provided for @formShortDescriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Short description is required.'**
  String get formShortDescriptionRequired;

  /// No description provided for @formShortDescriptionHelper.
  ///
  /// In en, this message translates to:
  /// **'Shown on the project card'**
  String get formShortDescriptionHelper;

  /// No description provided for @formFullDescription.
  ///
  /// In en, this message translates to:
  /// **'Full description'**
  String get formFullDescription;

  /// No description provided for @formFeaturedSwitchTitle.
  ///
  /// In en, this message translates to:
  /// **'Featured project'**
  String get formFeaturedSwitchTitle;

  /// No description provided for @formFeaturedSwitchSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Highlights it on cards and the dashboard'**
  String get formFeaturedSwitchSubtitle;

  /// No description provided for @formTechStack.
  ///
  /// In en, this message translates to:
  /// **'Tech stack'**
  String get formTechStack;

  /// No description provided for @formTechStackHelper.
  ///
  /// In en, this message translates to:
  /// **'Type a technology and press Add'**
  String get formTechStackHelper;

  /// No description provided for @formTechStackEmpty.
  ///
  /// In en, this message translates to:
  /// **'No technologies added yet.'**
  String get formTechStackEmpty;

  /// No description provided for @formScreenshotsCount.
  ///
  /// In en, this message translates to:
  /// **'Screenshots ({count})'**
  String formScreenshotsCount(int count);

  /// No description provided for @formAddImages.
  ///
  /// In en, this message translates to:
  /// **'Add images'**
  String get formAddImages;

  /// No description provided for @formUploadingImages.
  ///
  /// In en, this message translates to:
  /// **'Uploading…'**
  String get formUploadingImages;

  /// No description provided for @formCoverHint.
  ///
  /// In en, this message translates to:
  /// **'The first image is used as the card cover.'**
  String get formCoverHint;

  /// No description provided for @formNoScreenshots.
  ///
  /// In en, this message translates to:
  /// **'No screenshots yet.'**
  String get formNoScreenshots;

  /// No description provided for @formCoverBadge.
  ///
  /// In en, this message translates to:
  /// **'Cover'**
  String get formCoverBadge;

  /// No description provided for @formLinksHeading.
  ///
  /// In en, this message translates to:
  /// **'Links'**
  String get formLinksHeading;

  /// No description provided for @formLiveUrlField.
  ///
  /// In en, this message translates to:
  /// **'Live demo URL'**
  String get formLiveUrlField;

  /// No description provided for @formGithubUrlField.
  ///
  /// In en, this message translates to:
  /// **'GitHub repository URL'**
  String get formGithubUrlField;

  /// No description provided for @categoryMobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get categoryMobile;

  /// No description provided for @categoryWeb.
  ///
  /// In en, this message translates to:
  /// **'Web'**
  String get categoryWeb;

  /// No description provided for @categoryFullstack.
  ///
  /// In en, this message translates to:
  /// **'Full-stack'**
  String get categoryFullstack;

  /// No description provided for @signInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signInButton;

  /// No description provided for @signingIn.
  ///
  /// In en, this message translates to:
  /// **'Signing in…'**
  String get signingIn;

  /// No description provided for @updatedDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String updatedDaysAgo(int count);

  /// No description provided for @projectUpdatedLine.
  ///
  /// In en, this message translates to:
  /// **'{category} · updated {when}'**
  String projectUpdatedLine(String category, String when);

  /// No description provided for @formTitleField.
  ///
  /// In en, this message translates to:
  /// **'Title *'**
  String get formTitleField;

  /// No description provided for @formTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Title is required.'**
  String get formTitleRequired;

  /// No description provided for @formCategoryField.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get formCategoryField;

  /// No description provided for @messagesAdminCount.
  ///
  /// In en, this message translates to:
  /// **'Messages ({count})'**
  String messagesAdminCount(int count);

  /// No description provided for @messagesAdminUnreadCount.
  ///
  /// In en, this message translates to:
  /// **'{count} unread'**
  String messagesAdminUnreadCount(int count);

  /// No description provided for @messagesAdminMarkAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get messagesAdminMarkAllRead;

  /// No description provided for @messagesAdminEmpty.
  ///
  /// In en, this message translates to:
  /// **'No messages yet — new contact form submissions land here.'**
  String get messagesAdminEmpty;

  /// No description provided for @messagesAdminFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load messages.'**
  String get messagesAdminFailedToLoad;

  /// No description provided for @messagesAdminReply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get messagesAdminReply;

  /// No description provided for @experiencesAdminCount.
  ///
  /// In en, this message translates to:
  /// **'Work experience ({count})'**
  String experiencesAdminCount(int count);

  /// No description provided for @experiencesAdminNew.
  ///
  /// In en, this message translates to:
  /// **'New entry'**
  String get experiencesAdminNew;

  /// No description provided for @experiencesAdminEmpty.
  ///
  /// In en, this message translates to:
  /// **'No work experience yet. Add your first role!'**
  String get experiencesAdminEmpty;

  /// No description provided for @experiencesAdminFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load work experience.'**
  String get experiencesAdminFailedToLoad;

  /// No description provided for @educationsAdminCount.
  ///
  /// In en, this message translates to:
  /// **'Education ({count})'**
  String educationsAdminCount(int count);

  /// No description provided for @educationsAdminNew.
  ///
  /// In en, this message translates to:
  /// **'New entry'**
  String get educationsAdminNew;

  /// No description provided for @educationsAdminEmpty.
  ///
  /// In en, this message translates to:
  /// **'No education history yet. Add your studies!'**
  String get educationsAdminEmpty;

  /// No description provided for @educationsAdminFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load education.'**
  String get educationsAdminFailedToLoad;

  /// No description provided for @timelineReorderHint.
  ///
  /// In en, this message translates to:
  /// **'Drag rows to reorder — applies to the public site instantly.'**
  String get timelineReorderHint;

  /// No description provided for @experienceFormNewHeading.
  ///
  /// In en, this message translates to:
  /// **'New work experience'**
  String get experienceFormNewHeading;

  /// No description provided for @experienceFormEditHeading.
  ///
  /// In en, this message translates to:
  /// **'Edit work experience'**
  String get experienceFormEditHeading;

  /// No description provided for @educationFormNewHeading.
  ///
  /// In en, this message translates to:
  /// **'New education entry'**
  String get educationFormNewHeading;

  /// No description provided for @educationFormEditHeading.
  ///
  /// In en, this message translates to:
  /// **'Edit education entry'**
  String get educationFormEditHeading;

  /// No description provided for @experienceSavedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Experience entry saved ✓'**
  String get experienceSavedSnackbar;

  /// No description provided for @educationSavedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Education entry saved ✓'**
  String get educationSavedSnackbar;

  /// No description provided for @deleteTimelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{title}\"?'**
  String deleteTimelineTitle(String title);

  /// No description provided for @deleteTimelineBody.
  ///
  /// In en, this message translates to:
  /// **'This permanently removes the entry from the public site. This action cannot be undone.'**
  String get deleteTimelineBody;

  /// No description provided for @formRequiredField.
  ///
  /// In en, this message translates to:
  /// **'This field is required.'**
  String get formRequiredField;

  /// No description provided for @formCompanyField.
  ///
  /// In en, this message translates to:
  /// **'Company *'**
  String get formCompanyField;

  /// No description provided for @formPositionField.
  ///
  /// In en, this message translates to:
  /// **'Position *'**
  String get formPositionField;

  /// No description provided for @formLocationField.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get formLocationField;

  /// No description provided for @formEntryDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get formEntryDescription;

  /// No description provided for @formStartDateField.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get formStartDateField;

  /// No description provided for @formEndDateField.
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get formEndDateField;

  /// No description provided for @formCurrentWorkSwitchTitle.
  ///
  /// In en, this message translates to:
  /// **'I currently work here'**
  String get formCurrentWorkSwitchTitle;

  /// No description provided for @formCurrentStudySwitchTitle.
  ///
  /// In en, this message translates to:
  /// **'I currently study here'**
  String get formCurrentStudySwitchTitle;

  /// No description provided for @formInstitutionField.
  ///
  /// In en, this message translates to:
  /// **'Institution *'**
  String get formInstitutionField;

  /// No description provided for @formDegreeField.
  ///
  /// In en, this message translates to:
  /// **'Degree *'**
  String get formDegreeField;

  /// No description provided for @formFieldOfStudyField.
  ///
  /// In en, this message translates to:
  /// **'Field of study'**
  String get formFieldOfStudyField;

  /// No description provided for @formGradeField.
  ///
  /// In en, this message translates to:
  /// **'Grade / GPA'**
  String get formGradeField;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
