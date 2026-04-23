import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';

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
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('pt'),
    Locale('ru'),
  ];

  /// App name as shown on device launchers
  ///
  /// In en, this message translates to:
  /// **'MenuAssistant'**
  String get appTitle;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @commonSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get commonSkip;

  /// No description provided for @commonAllow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get commonAllow;

  /// No description provided for @commonLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get commonLater;

  /// No description provided for @commonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get commonSignOut;

  /// No description provided for @commonYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get commonYes;

  /// No description provided for @commonNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get commonNo;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get commonLoading;

  /// No description provided for @commonSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get commonSearch;

  /// Plain prefix of slide 1 title; the accent word is rendered italic in primary colour
  ///
  /// In en, this message translates to:
  /// **'Any menu —'**
  String get onboardingSlide1TitlePlain;

  /// No description provided for @onboardingSlide1TitleAccent.
  ///
  /// In en, this message translates to:
  /// **'your way'**
  String get onboardingSlide1TitleAccent;

  /// No description provided for @onboardingSlide1Body.
  ///
  /// In en, this message translates to:
  /// **'Snap a menu at any café — get a beautiful catalogue with photos, translation and ingredients.'**
  String get onboardingSlide1Body;

  /// No description provided for @onboardingSlide2TitlePlain.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get onboardingSlide2TitlePlain;

  /// No description provided for @onboardingSlide2TitleAccent.
  ///
  /// In en, this message translates to:
  /// **'helps'**
  String get onboardingSlide2TitleAccent;

  /// No description provided for @onboardingSlide2Body.
  ///
  /// In en, this message translates to:
  /// **'We use it only to recognise the right restaurant when two places have similar names.'**
  String get onboardingSlide2Body;

  /// No description provided for @onboardingSlide3TitlePlain.
  ///
  /// In en, this message translates to:
  /// **'Ready to'**
  String get onboardingSlide3TitlePlain;

  /// No description provided for @onboardingSlide3TitleAccent.
  ///
  /// In en, this message translates to:
  /// **'start'**
  String get onboardingSlide3TitleAccent;

  /// No description provided for @onboardingSlide3Body.
  ///
  /// In en, this message translates to:
  /// **'Capture your first menu and we\'ll take care of the rest.'**
  String get onboardingSlide3Body;

  /// No description provided for @onboardingStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get onboardingStart;

  /// No description provided for @authEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get authEyebrow;

  /// No description provided for @authTitlePlain.
  ///
  /// In en, this message translates to:
  /// **'Enter the world of'**
  String get authTitlePlain;

  /// Italic accent-coloured word at the end of the auth screen title
  ///
  /// In en, this message translates to:
  /// **'flavor'**
  String get authTitleAccent;

  /// No description provided for @authBody.
  ///
  /// In en, this message translates to:
  /// **'Sign in or create an account to save restaurants and favourite dishes.'**
  String get authBody;

  /// No description provided for @authEmailPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmailPlaceholder;

  /// No description provided for @authPasswordPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPasswordPlaceholder;

  /// No description provided for @authSubmit.
  ///
  /// In en, this message translates to:
  /// **'Sign in or create'**
  String get authSubmit;

  /// No description provided for @authGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authGoogle;

  /// No description provided for @authDividerOr.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get authDividerOr;

  /// No description provided for @authTos.
  ///
  /// In en, this message translates to:
  /// **'By continuing you agree to the Terms and Privacy policy.'**
  String get authTos;

  /// The substring of authTos that is rendered as a tappable link opening the Terms screen
  ///
  /// In en, this message translates to:
  /// **'Terms and Privacy policy'**
  String get authTosLink;

  /// No description provided for @authPinPrompt.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code we sent to your email'**
  String get authPinPrompt;

  /// No description provided for @profileSetupEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Almost there'**
  String get profileSetupEyebrow;

  /// No description provided for @profileSetupTitlePlain.
  ///
  /// In en, this message translates to:
  /// **'How should we'**
  String get profileSetupTitlePlain;

  /// No description provided for @profileSetupTitleAccent.
  ///
  /// In en, this message translates to:
  /// **'call you'**
  String get profileSetupTitleAccent;

  /// No description provided for @profileSetupBody.
  ///
  /// In en, this message translates to:
  /// **'Tell us your name — we\'ll use it across the app. Birth date is optional but helps with regional dish suggestions.'**
  String get profileSetupBody;

  /// No description provided for @profileSetupNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get profileSetupNamePlaceholder;

  /// No description provided for @profileSetupBirthDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Birth date (optional)'**
  String get profileSetupBirthDateLabel;

  /// No description provided for @profileSetupSubmit.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get profileSetupSubmit;

  /// No description provided for @profileSetupNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name.'**
  String get profileSetupNameRequired;

  /// No description provided for @tosTitlePlain.
  ///
  /// In en, this message translates to:
  /// **'Terms &'**
  String get tosTitlePlain;

  /// Italic accent word at the end of the Terms screen title
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get tosTitleAccent;

  /// No description provided for @tosUpdated.
  ///
  /// In en, this message translates to:
  /// **'UPDATED · APRIL 2026'**
  String get tosUpdated;

  /// No description provided for @tosIntroP1.
  ///
  /// In en, this message translates to:
  /// **'MenuAssistant turns photos of restaurant menus into a searchable personal catalogue. This document explains what we do with the data you share when you use the app, in plain language.'**
  String get tosIntroP1;

  /// No description provided for @tosIntroP2.
  ///
  /// In en, this message translates to:
  /// **'The service is provided as-is, without warranties. We may update these terms as the product evolves — material changes will be announced in-app before they take effect.'**
  String get tosIntroP2;

  /// No description provided for @tosDataHeading.
  ///
  /// In en, this message translates to:
  /// **'Data we collect'**
  String get tosDataHeading;

  /// No description provided for @tosDataBody.
  ///
  /// In en, this message translates to:
  /// **'We store the photos you upload, the dishes and restaurants recognised from them, your favourites, and basic account data (email, language, currency). Location is only used to disambiguate restaurants when you choose to grant it, and it is never shared with third parties.'**
  String get tosDataBody;

  /// No description provided for @tosRightsHeading.
  ///
  /// In en, this message translates to:
  /// **'Your rights'**
  String get tosRightsHeading;

  /// No description provided for @tosRightsBody.
  ///
  /// In en, this message translates to:
  /// **'You can export your catalogue, sign out, and delete your account at any time from Profile → Account. Deletion is irreversible and removes all associated menus, dishes, and favourites within 30 days.'**
  String get tosRightsBody;

  /// No description provided for @tosContactHeading.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get tosContactHeading;

  /// No description provided for @tosContactBody.
  ///
  /// In en, this message translates to:
  /// **'Questions, requests, or feedback: hello@menuassistant.app. For privacy-specific requests please use the same address with \"Privacy\" in the subject.'**
  String get tosContactBody;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hi, {name}'**
  String homeGreeting(String name);

  /// No description provided for @homeTitlePlain.
  ///
  /// In en, this message translates to:
  /// **'Where today?'**
  String get homeTitlePlain;

  /// No description provided for @homeTitleAccent.
  ///
  /// In en, this message translates to:
  /// **'Your menus'**
  String get homeTitleAccent;

  /// No description provided for @homeSearchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Places, dishes, cuisines…'**
  String get homeSearchPlaceholder;

  /// No description provided for @homeChipRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get homeChipRecent;

  /// No description provided for @homeChipLiked.
  ///
  /// In en, this message translates to:
  /// **'Liked'**
  String get homeChipLiked;

  /// No description provided for @homeChipGlutenFree.
  ///
  /// In en, this message translates to:
  /// **'Gluten-free'**
  String get homeChipGlutenFree;

  /// No description provided for @homeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Still empty'**
  String get homeEmpty;

  /// No description provided for @homeEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Capture your first menu to start your collection.'**
  String get homeEmptyBody;

  /// No description provided for @homeCaptureFirst.
  ///
  /// In en, this message translates to:
  /// **'Capture first menu'**
  String get homeCaptureFirst;

  /// No description provided for @restaurantSearchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'“something with cod, up to €25”'**
  String get restaurantSearchPlaceholder;

  /// No description provided for @restaurantLanguagePair.
  ///
  /// In en, this message translates to:
  /// **'RU↔EN'**
  String get restaurantLanguagePair;

  /// No description provided for @restaurantChipCurrency.
  ///
  /// In en, this message translates to:
  /// **'€'**
  String get restaurantChipCurrency;

  /// No description provided for @restaurantChipVeg.
  ///
  /// In en, this message translates to:
  /// **'🌱 vegetarian'**
  String get restaurantChipVeg;

  /// No description provided for @restaurantChipGlutenFree.
  ///
  /// In en, this message translates to:
  /// **'gf'**
  String get restaurantChipGlutenFree;

  /// No description provided for @dishComposition.
  ///
  /// In en, this message translates to:
  /// **'Composition'**
  String get dishComposition;

  /// No description provided for @dishPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get dishPrice;

  /// No description provided for @addMenuEyebrow.
  ///
  /// In en, this message translates to:
  /// **'New menu'**
  String get addMenuEyebrow;

  /// No description provided for @addMenuTitlePlain.
  ///
  /// In en, this message translates to:
  /// **'Pick your'**
  String get addMenuTitlePlain;

  /// No description provided for @addMenuTitleAccent.
  ///
  /// In en, this message translates to:
  /// **'source'**
  String get addMenuTitleAccent;

  /// No description provided for @addMenuProcessingHint.
  ///
  /// In en, this message translates to:
  /// **'~20 seconds to process'**
  String get addMenuProcessingHint;

  /// No description provided for @addMenuPrimary.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get addMenuPrimary;

  /// No description provided for @addMenuGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get addMenuGallery;

  /// No description provided for @addMenuPdf.
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get addMenuPdf;

  /// No description provided for @addMenuLink.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get addMenuLink;

  /// No description provided for @addMenuPageN.
  ///
  /// In en, this message translates to:
  /// **'Page {n} / {total}'**
  String addMenuPageN(int n, int total);

  /// No description provided for @addMenuAddPage.
  ///
  /// In en, this message translates to:
  /// **'Add page'**
  String get addMenuAddPage;

  /// No description provided for @addMenuParse.
  ///
  /// In en, this message translates to:
  /// **'Done → Parse'**
  String get addMenuParse;

  /// No description provided for @addMenuProcessing.
  ///
  /// In en, this message translates to:
  /// **'Recognising menu…'**
  String get addMenuProcessing;

  /// No description provided for @matchConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Is this the same place?'**
  String get matchConfirmTitle;

  /// No description provided for @matchConfirmSimilarity.
  ///
  /// In en, this message translates to:
  /// **'similarity {percent}%'**
  String matchConfirmSimilarity(int percent);

  /// No description provided for @matchConfirmDistance.
  ///
  /// In en, this message translates to:
  /// **'{meters}m away'**
  String matchConfirmDistance(int meters);

  /// No description provided for @matchConfirmYes.
  ///
  /// In en, this message translates to:
  /// **'Yes, it\'s the same'**
  String get matchConfirmYes;

  /// No description provided for @matchConfirmNo.
  ///
  /// In en, this message translates to:
  /// **'No, different'**
  String get matchConfirmNo;

  /// No description provided for @profileStatsPlaces.
  ///
  /// In en, this message translates to:
  /// **'Places'**
  String get profileStatsPlaces;

  /// No description provided for @profileStatsDishes.
  ///
  /// In en, this message translates to:
  /// **'Dishes'**
  String get profileStatsDishes;

  /// No description provided for @profileStatsCities.
  ///
  /// In en, this message translates to:
  /// **'Cities'**
  String get profileStatsCities;

  /// No description provided for @profileSettingsLikedPlaces.
  ///
  /// In en, this message translates to:
  /// **'Liked places'**
  String get profileSettingsLikedPlaces;

  /// No description provided for @profileSettingsLikedDishes.
  ///
  /// In en, this message translates to:
  /// **'Liked dishes'**
  String get profileSettingsLikedDishes;

  /// No description provided for @profileSettingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileSettingsLanguage;

  /// No description provided for @profileSettingsCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get profileSettingsCurrency;

  /// No description provided for @profileSettingsDiet.
  ///
  /// In en, this message translates to:
  /// **'Diet'**
  String get profileSettingsDiet;

  /// No description provided for @profileSettingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get profileSettingsTheme;

  /// Profile row that opens the Terms of Service / Privacy Policy screen
  ///
  /// In en, this message translates to:
  /// **'Terms & Privacy'**
  String get profileSettingsTerms;

  /// No description provided for @themeWarm.
  ///
  /// In en, this message translates to:
  /// **'Warm'**
  String get themeWarm;

  /// No description provided for @themeSage.
  ///
  /// In en, this message translates to:
  /// **'Sage'**
  String get themeSage;

  /// No description provided for @themeMidnight.
  ///
  /// In en, this message translates to:
  /// **'Midnight'**
  String get themeMidnight;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @geoPermissionRationale.
  ///
  /// In en, this message translates to:
  /// **'Granting location helps us match the right restaurant when names collide.'**
  String get geoPermissionRationale;

  /// No description provided for @geoPermissionDeniedToast.
  ///
  /// In en, this message translates to:
  /// **'Location denied — we\'ll use EXIF or IP instead.'**
  String get geoPermissionDeniedToast;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'No connection. Check your network.'**
  String get errorNetwork;

  /// No description provided for @errorUpload.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t upload the menu.'**
  String get errorUpload;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'it',
    'pt',
    'ru',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
