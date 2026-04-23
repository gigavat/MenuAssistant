// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'MenuAssistant';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonSkip => 'Skip';

  @override
  String get commonAllow => 'Allow';

  @override
  String get commonLater => 'Later';

  @override
  String get commonDone => 'Done';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonSignOut => 'Sign out';

  @override
  String get commonYes => 'Yes';

  @override
  String get commonNo => 'No';

  @override
  String get commonLoading => 'Loading…';

  @override
  String get commonSearch => 'Search';

  @override
  String get onboardingSlide1TitlePlain => 'Any menu —';

  @override
  String get onboardingSlide1TitleAccent => 'your way';

  @override
  String get onboardingSlide1Body =>
      'Snap a menu at any café — get a beautiful catalogue with photos, translation and ingredients.';

  @override
  String get onboardingSlide2TitlePlain => 'Location';

  @override
  String get onboardingSlide2TitleAccent => 'helps';

  @override
  String get onboardingSlide2Body =>
      'We use it only to recognise the right restaurant when two places have similar names.';

  @override
  String get onboardingSlide3TitlePlain => 'Ready to';

  @override
  String get onboardingSlide3TitleAccent => 'start';

  @override
  String get onboardingSlide3Body =>
      'Capture your first menu and we\'ll take care of the rest.';

  @override
  String get onboardingStart => 'Start';

  @override
  String get authEyebrow => 'Welcome';

  @override
  String get authTitlePlain => 'Enter the world of';

  @override
  String get authTitleAccent => 'flavor';

  @override
  String get authBody =>
      'Sign in or create an account to save restaurants and favourite dishes.';

  @override
  String get authEmailPlaceholder => 'Email';

  @override
  String get authPasswordPlaceholder => 'Password';

  @override
  String get authSubmit => 'Sign in or create';

  @override
  String get authGoogle => 'Continue with Google';

  @override
  String get authDividerOr => 'or';

  @override
  String get authTos =>
      'By continuing you agree to the Terms and Privacy policy.';

  @override
  String get authTosLink => 'Terms and Privacy policy';

  @override
  String get authPinPrompt => 'Enter the 6-digit code we sent to your email';

  @override
  String get profileSetupEyebrow => 'Almost there';

  @override
  String get profileSetupTitlePlain => 'How should we';

  @override
  String get profileSetupTitleAccent => 'call you';

  @override
  String get profileSetupBody =>
      'Tell us your name — we\'ll use it across the app. Birth date is optional but helps with regional dish suggestions.';

  @override
  String get profileSetupNamePlaceholder => 'Full name';

  @override
  String get profileSetupBirthDateLabel => 'Birth date (optional)';

  @override
  String get profileSetupSubmit => 'Continue';

  @override
  String get profileSetupNameRequired => 'Please enter your name.';

  @override
  String get tosTitlePlain => 'Terms &';

  @override
  String get tosTitleAccent => 'Privacy';

  @override
  String get tosUpdated => 'UPDATED · APRIL 2026';

  @override
  String get tosIntroP1 =>
      'MenuAssistant turns photos of restaurant menus into a searchable personal catalogue. This document explains what we do with the data you share when you use the app, in plain language.';

  @override
  String get tosIntroP2 =>
      'The service is provided as-is, without warranties. We may update these terms as the product evolves — material changes will be announced in-app before they take effect.';

  @override
  String get tosDataHeading => 'Data we collect';

  @override
  String get tosDataBody =>
      'We store the photos you upload, the dishes and restaurants recognised from them, your favourites, and basic account data (email, language, currency). Location is only used to disambiguate restaurants when you choose to grant it, and it is never shared with third parties.';

  @override
  String get tosRightsHeading => 'Your rights';

  @override
  String get tosRightsBody =>
      'You can export your catalogue, sign out, and delete your account at any time from Profile → Account. Deletion is irreversible and removes all associated menus, dishes, and favourites within 30 days.';

  @override
  String get tosContactHeading => 'Contact';

  @override
  String get tosContactBody =>
      'Questions, requests, or feedback: hello@menuassistant.app. For privacy-specific requests please use the same address with \"Privacy\" in the subject.';

  @override
  String homeGreeting(String name) {
    return 'Hi, $name';
  }

  @override
  String get homeTitlePlain => 'Where today?';

  @override
  String get homeTitleAccent => 'Your menus';

  @override
  String get homeSearchPlaceholder => 'Places, dishes, cuisines…';

  @override
  String get homeChipRecent => 'Recent';

  @override
  String get homeChipLiked => 'Liked';

  @override
  String get homeChipGlutenFree => 'Gluten-free';

  @override
  String get homeEmpty => 'Still empty';

  @override
  String get homeEmptyBody =>
      'Capture your first menu to start your collection.';

  @override
  String get homeCaptureFirst => 'Capture first menu';

  @override
  String get restaurantSearchPlaceholder => '“something with cod, up to €25”';

  @override
  String get restaurantLanguagePair => 'RU↔EN';

  @override
  String get restaurantChipCurrency => '€';

  @override
  String get restaurantChipVeg => '🌱 vegetarian';

  @override
  String get restaurantChipGlutenFree => 'gf';

  @override
  String get dishComposition => 'Composition';

  @override
  String get dishPrice => 'Price';

  @override
  String get addMenuEyebrow => 'New menu';

  @override
  String get addMenuTitlePlain => 'Pick your';

  @override
  String get addMenuTitleAccent => 'source';

  @override
  String get addMenuProcessingHint => '~20 seconds to process';

  @override
  String get addMenuPrimary => 'Take photo';

  @override
  String get addMenuGallery => 'Gallery';

  @override
  String get addMenuPdf => 'PDF';

  @override
  String get addMenuLink => 'Link';

  @override
  String addMenuPageN(int n, int total) {
    return 'Page $n / $total';
  }

  @override
  String get addMenuAddPage => 'Add page';

  @override
  String get addMenuParse => 'Done → Parse';

  @override
  String get addMenuProcessing => 'Recognising menu…';

  @override
  String get matchConfirmTitle => 'Is this the same place?';

  @override
  String matchConfirmSimilarity(int percent) {
    return 'similarity $percent%';
  }

  @override
  String matchConfirmDistance(int meters) {
    return '${meters}m away';
  }

  @override
  String get matchConfirmYes => 'Yes, it\'s the same';

  @override
  String get matchConfirmNo => 'No, different';

  @override
  String get profileStatsPlaces => 'Places';

  @override
  String get profileStatsDishes => 'Dishes';

  @override
  String get profileStatsCities => 'Cities';

  @override
  String get profileSettingsLikedPlaces => 'Liked places';

  @override
  String get profileSettingsLikedDishes => 'Liked dishes';

  @override
  String get profileSettingsLanguage => 'Language';

  @override
  String get profileSettingsCurrency => 'Currency';

  @override
  String get profileSettingsDiet => 'Diet';

  @override
  String get profileSettingsTheme => 'Theme';

  @override
  String get profileSettingsTerms => 'Terms & Privacy';

  @override
  String get themeWarm => 'Warm';

  @override
  String get themeSage => 'Sage';

  @override
  String get themeMidnight => 'Midnight';

  @override
  String get themeSystem => 'System';

  @override
  String get geoPermissionRationale =>
      'Granting location helps us match the right restaurant when names collide.';

  @override
  String get geoPermissionDeniedToast =>
      'Location denied — we\'ll use EXIF or IP instead.';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get errorNetwork => 'No connection. Check your network.';

  @override
  String get errorUpload => 'Couldn\'t upload the menu.';
}
