// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get commonRetry => 'حاول مجددًا';

  @override
  String get commonCancel => 'إلغاء';

  @override
  String get commonDelete => 'حذف';

  @override
  String get commonEdit => 'تعديل';

  @override
  String get commonClose => 'إغلاق';

  @override
  String get commonRemove => 'إزالة';

  @override
  String get commonAdd => 'إضافة';

  @override
  String get commonErrorGeneric => 'حدث خطأ ما.';

  @override
  String get loadingPortfolio => 'جارٍ تحميل الموقع…';

  @override
  String get errorLoadingPortfolio => 'حدث خطأ ما أثناء تحميل الموقع.';

  @override
  String get navAbout => 'نبذة عني';

  @override
  String get navExperience => 'خبرتي';

  @override
  String get navEducation => 'التعليم';

  @override
  String get navProjects => 'المشاريع';

  @override
  String get navContact => 'تواصل معي';

  @override
  String get navMenuTooltip => 'القائمة';

  @override
  String get heroGreeting => 'أهلًا، أنا';

  @override
  String get heroNameFallback => 'مطوّر فلاتر';

  @override
  String get heroTitleFallback => 'أبني تطبيقات جميلة، ويدجت واحدة في كل مرة';

  @override
  String get heroViewWork => 'شاهد أعمالي';

  @override
  String get heroDownloadCv => 'حمّل السيرة الذاتية';

  @override
  String get heroContactMe => 'راسلني';

  @override
  String get heroAvailableForWork => 'متاح للعمل';

  @override
  String get aboutSectionTitle => 'نبذة عني';

  @override
  String get aboutBioFallback =>
      'هذه النبذة مخزّنة في Firestore وتُحدَّث دون إعادة نشر — أضف قصتك لتظهر هنا.';

  @override
  String get aboutTechHeading => 'التقنيات التي أعمل بها';

  @override
  String get statYearsLabel => 'سنوات الخبرة';

  @override
  String get statProjectsLabel => 'مشاريع منجزة';

  @override
  String get statTechnologiesLabel => 'تقنيات';

  @override
  String get experienceSectionTitle => 'الخبرة العملية';

  @override
  String get educationSectionTitle => 'التعليم';

  @override
  String get timelinePresent => 'حتى الآن';

  @override
  String get experienceEmptyPublic => 'لم تُضف خبرات عملية بعد — عود قريبًا!';

  @override
  String get educationEmptyPublic => 'لم يُضف سجل تعليمي بعد — عود قريبًا!';

  @override
  String get projectsSectionTitle => 'المشاريع';

  @override
  String get projectsEmptyPublic => 'لا توجد مشاريع بعد — عود قريبًا!';

  @override
  String get projectsFilterAll => 'الكل';

  @override
  String get projectCardViewDetails => 'عرض التفاصيل';

  @override
  String get projectCardFeaturedBadge => 'مميّز';

  @override
  String get projectDetailsBarrierLabel => 'تفاصيل المشروع';

  @override
  String projectDetailsRole(String role) {
    return 'دوري في المشروع — $role';
  }

  @override
  String get projectDetailsGooglePlay => 'جوجل بلاي';

  @override
  String get projectDetailsAppStore => 'آب ستور';

  @override
  String footerCopyright(int year, String name) {
    return '© $year $name. تم البناء باستخدام Flutter.';
  }

  @override
  String get contactSectionTitle => 'تواصل معي';

  @override
  String get contactHeading => 'لنبنِ شيئًا رائعًا معًا.';

  @override
  String get contactSubtitle =>
      'لديك مشروع في ذهنك أو تريد فقط إلقاء التحية؟ بريدي مفتوح دائمًا.';

  @override
  String get contactFormName => 'اسمك';

  @override
  String get contactFormEmail => 'بريدك الإلكتروني';

  @override
  String get contactFormPhone => 'رقم الهاتف (اختياري)';

  @override
  String get contactFormPhoneInvalid => 'أدخل رقم هاتف صحيحًا.';

  @override
  String get contactFormMessage => 'الرسالة';

  @override
  String get contactFormNameRequired => 'من فضلك أدخل اسمك.';

  @override
  String get contactFormEmailInvalid =>
      'من فضلك أدخل بريدًا إلكترونيًا صحيحًا.';

  @override
  String get contactFormMessageShort => 'أخبرني المزيد (١٠ أحرف على الأقل).';

  @override
  String get contactSendMessage => 'أرسل الرسالة';

  @override
  String get contactSending => 'جارٍ الإرسال…';

  @override
  String get contactSentSnackbar => 'تم إرسال رسالتك — سأرد عليك قريبًا!';

  @override
  String get adminSignInTitle => 'تسجيل دخول المشرف';

  @override
  String get adminSignInSubtitle => 'منطقة مقيّدة — للمالك فقط.';

  @override
  String get fieldEmail => 'البريد الإلكتروني';

  @override
  String get fieldPassword => 'كلمة المرور';

  @override
  String get emailInvalid => 'أدخل بريدًا إلكترونيًا صحيحًا.';

  @override
  String get passwordTooShort => '٦ أحرف على الأقل.';

  @override
  String get signInFailed => 'فشل تسجيل الدخول. حاول مجددًا.';

  @override
  String get shellDashboard => 'لوحة التحكم';

  @override
  String get shellProfile => 'الملف الشخصي';

  @override
  String get shellProjects => 'المشاريع';

  @override
  String get shellMessages => 'الرسائل';

  @override
  String get shellExperience => 'خبرتي';

  @override
  String get shellEducation => 'التعليم';

  @override
  String get shellConsoleTitle => 'لوحة المشرف';

  @override
  String get shellSignOut => 'تسجيل الخروج';

  @override
  String get dashboardOverview => 'نظرة عامة';

  @override
  String get dashboardTotalProjects => 'إجمالي المشاريع';

  @override
  String get dashboardFeaturedCount => 'المميزة';

  @override
  String get dashboardRecentlyUpdated => 'آخر التحديثات';

  @override
  String get dashboardNewProject => 'مشروع جديد';

  @override
  String get dashboardEmptyProjects => 'لا توجد مشاريع بعد. أضف أول مشروع!';

  @override
  String get dashboardFailedToLoad => 'فشل التحميل.';

  @override
  String get updatedToday => 'اليوم';

  @override
  String get updatedYesterday => 'أمس';

  @override
  String get profileEditorTitle => 'تعديل الملف الشخصي';

  @override
  String get profileSaveChanges => 'حفظ التغييرات';

  @override
  String get profileSaving => 'جارٍ الحفظ…';

  @override
  String get profileFailedToLoad => 'فشل تحميل الملف الشخصي.';

  @override
  String get profileBasicsHeading => 'البيانات الأساسية';

  @override
  String get fieldName => 'الاسم';

  @override
  String get fieldTitle => 'المسمّى الوظيفي';

  @override
  String get fieldTagline => 'الشعار النصي';

  @override
  String get fieldYearsOfExperience => 'سنوات الخبرة';

  @override
  String get fieldAboutMe => 'نبذة عني';

  @override
  String get availableSwitchTitle => 'متاح للعمل';

  @override
  String get availableSwitchSubtitle => 'يُظهر الشارة الخضراء في القسم الرئيسي';

  @override
  String get skillsHeading => 'المهارات';

  @override
  String get skillGroupsAdd => 'إضافة تصنيف';

  @override
  String skillGroupLabel(int index) {
    return 'التصنيف $index';
  }

  @override
  String get skillGroupHint => 'مثال: موبايل، باك إند، أدوات';

  @override
  String get skillsAdd => 'أضف مهارة';

  @override
  String get skillsEmpty => 'لا توجد مهارات بعد — أضف التقنيات التي تعمل بها.';

  @override
  String skillLabel(int index) {
    return 'مهارة $index';
  }

  @override
  String get livePreviewTitle => 'معاينة مباشرة';

  @override
  String get livePreviewHint => 'تتحدّث أثناء الكتابة';

  @override
  String get livePreviewNameFallback => 'اسمك';

  @override
  String get livePreviewTitleFallback => 'مسمّاك الوظيفي';

  @override
  String get livePreviewEmptySkills =>
      'لا توجد مهارات بعد — أضف بعضها بالأسفل.';

  @override
  String projectsAdminCount(int count) {
    return 'المشاريع ($count)';
  }

  @override
  String get projectsAdminNew => 'مشروع جديد';

  @override
  String get projectsAdminReorderHint =>
      'اسحب الصفوف لإعادة الترتيب — ينعكس على الموقع العام فورًا.';

  @override
  String get projectsAdminEmpty => 'لا توجد مشاريع بعد. أنشئ أول مشروع!';

  @override
  String get projectsAdminFailedToLoad => 'فشل تحميل المشاريع.';

  @override
  String get tooltipFeature => 'تمييز';

  @override
  String get tooltipUnfeature => 'إلغاء التمييز';

  @override
  String deleteProjectTitle(String title) {
    return 'حذف \"$title\"؟';
  }

  @override
  String get deleteProjectBody =>
      'سيؤدي هذا إلى حذف المشروع نهائيًا من الموقع العام. لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get formRoleField => 'دورك في المشروع';

  @override
  String get formShortDescription => 'وصف مختصر *';

  @override
  String get formShortDescriptionRequired => 'الوصف المختصر مطلوب.';

  @override
  String get formShortDescriptionHelper => 'يظهر على بطاقة المشروع';

  @override
  String get formFullDescription => 'الوصف الكامل';

  @override
  String get formFeaturedSwitchTitle => 'مشروع مميّز';

  @override
  String get formFeaturedSwitchSubtitle =>
      'يُبرزه على البطاقات وفي لوحة التحكم';

  @override
  String get formTechStack => 'التقنيات';

  @override
  String get formTechStackHelper => 'اكتب تقنية ثم اضغط إضافة';

  @override
  String get formTechStackEmpty => 'لم تُضف تقنيات بعد.';

  @override
  String formScreenshotsCount(int count) {
    return 'لقطات الشاشة ($count)';
  }

  @override
  String get formAddImages => 'أضف صورًا';

  @override
  String get formUploadingImages => 'جارٍ الرفع…';

  @override
  String get formCoverHint => 'الصورة الأولى تُستخدم كغلاف للبطاقة.';

  @override
  String get formNoScreenshots => 'لا توجد لقطات شاشة بعد.';

  @override
  String get formCoverBadge => 'الغلاف';

  @override
  String get formLinksHeading => 'الروابط';

  @override
  String get formGooglePlayUrlField => 'رابط Google Play';

  @override
  String get formAppStoreUrlField => 'رابط App Store';

  @override
  String get categoryMobile => 'موبايل';

  @override
  String get categoryWeb => 'ويب';

  @override
  String get categoryFullstack => 'فول-ستاك';

  @override
  String get signInButton => 'تسجيل الدخول';

  @override
  String get signingIn => 'جارٍ تسجيل الدخول…';

  @override
  String updatedDaysAgo(int count) {
    return 'قبل $count يوم';
  }

  @override
  String projectUpdatedLine(String category, String when) {
    return '$category · آخر تحديث $when';
  }

  @override
  String get formTitleField => 'العنوان *';

  @override
  String get formTitleRequired => 'العنوان مطلوب.';

  @override
  String get formCategoryField => 'التصنيف';

  @override
  String messagesAdminCount(int count) {
    return 'الرسائل ($count)';
  }

  @override
  String messagesAdminUnreadCount(int count) {
    return '$count غير مقروءة';
  }

  @override
  String get messagesAdminMarkAllRead => 'تعليم الكل كمقروء';

  @override
  String get messagesAdminEmpty =>
      'لا توجد رسائل بعد — ستظهر هنا رسائل نموذج التواصل.';

  @override
  String get messagesAdminFailedToLoad => 'فشل تحميل الرسائل.';

  @override
  String get messagesAdminReply => 'رد';

  @override
  String experiencesAdminCount(int count) {
    return 'الخبرة العملية ($count)';
  }

  @override
  String get experiencesAdminNew => 'عنصر جديد';

  @override
  String get experiencesAdminEmpty => 'لا توجد خبرات عملية بعد. أضف أول وظيفة!';

  @override
  String get experiencesAdminFailedToLoad => 'فشل تحميل الخبرة العملية.';

  @override
  String educationsAdminCount(int count) {
    return 'التعليم ($count)';
  }

  @override
  String get educationsAdminNew => 'عنصر جديد';

  @override
  String get educationsAdminEmpty => 'لا يوجد سجل تعليمي بعد. أضف دراستك!';

  @override
  String get educationsAdminFailedToLoad => 'فشل تحميل التعليم.';

  @override
  String get timelineReorderHint =>
      'اسحب الصفوف لإعادة الترتيب — ينعكس على الموقع العام فورًا.';

  @override
  String get experienceFormNewHeading => 'إضافة خبرة عملية';

  @override
  String get experienceFormEditHeading => 'تعديل الخبرة العملية';

  @override
  String get educationFormNewHeading => 'إضافة تعليم';

  @override
  String get educationFormEditHeading => 'تعديل التعليم';

  @override
  String get experienceSavedSnackbar => 'تم حفظ الخبرة ✓';

  @override
  String get educationSavedSnackbar => 'تم حفظ التعليم ✓';

  @override
  String deleteTimelineTitle(String title) {
    return 'حذف \"$title\"؟';
  }

  @override
  String get deleteTimelineBody =>
      'سيؤدي هذا إلى حذف العنصر نهائيًا من الموقع العام. لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get formRequiredField => 'هذا الحقل مطلوب.';

  @override
  String get formCompanyField => 'الشركة *';

  @override
  String get formPositionField => 'المسمّى الوظيفي *';

  @override
  String get formLocationField => 'الموقع';

  @override
  String get formEntryDescription => 'الوصف';

  @override
  String get formStartDateField => 'تاريخ البدء';

  @override
  String get formEndDateField => 'تاريخ الانتهاء';

  @override
  String get formCurrentWorkSwitchTitle => 'أعمل هنا حاليًا';

  @override
  String get formCurrentStudySwitchTitle => 'أدرس هنا حاليًا';

  @override
  String get formInstitutionField => 'المؤسسة التعليمية *';

  @override
  String get formDegreeField => 'الدرجة العلمية *';

  @override
  String get formFieldOfStudyField => 'التخصص';

  @override
  String get formGradeField => 'التقدير / المعدل';
}
