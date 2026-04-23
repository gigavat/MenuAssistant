// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'MenuAssistant';

  @override
  String get commonContinue => 'Далее';

  @override
  String get commonSkip => 'Пропустить';

  @override
  String get commonAllow => 'Разрешить';

  @override
  String get commonLater => 'Позже';

  @override
  String get commonDone => 'Готово';

  @override
  String get commonCancel => 'Отмена';

  @override
  String get commonRetry => 'Повторить';

  @override
  String get commonSignOut => 'Выйти';

  @override
  String get commonYes => 'Да';

  @override
  String get commonNo => 'Нет';

  @override
  String get commonLoading => 'Загрузка…';

  @override
  String get commonSearch => 'Поиск';

  @override
  String get onboardingSlide1TitlePlain => 'Любое меню —';

  @override
  String get onboardingSlide1TitleAccent => 'по-вашему';

  @override
  String get onboardingSlide1Body =>
      'Сфотографируйте меню в кафе — получите красивый каталог с фото, переводом и ингредиентами.';

  @override
  String get onboardingSlide2TitlePlain => 'Геолокация';

  @override
  String get onboardingSlide2TitleAccent => 'помогает';

  @override
  String get onboardingSlide2Body =>
      'Мы используем её только чтобы точнее определить нужный ресторан, когда два места называются похоже.';

  @override
  String get onboardingSlide3TitlePlain => 'Всё';

  @override
  String get onboardingSlide3TitleAccent => 'готово';

  @override
  String get onboardingSlide3Body =>
      'Снимите первое меню — остальное мы сделаем сами.';

  @override
  String get onboardingStart => 'Начать';

  @override
  String get authEyebrow => 'Добро пожаловать';

  @override
  String get authTitlePlain => 'Войдите в мир';

  @override
  String get authTitleAccent => 'вкуса';

  @override
  String get authBody =>
      'Войдите или зарегистрируйтесь, чтобы сохранять рестораны и любимые блюда.';

  @override
  String get authEmailPlaceholder => 'Эл. почта';

  @override
  String get authPasswordPlaceholder => 'Пароль';

  @override
  String get authSubmit => 'Войти или создать';

  @override
  String get authGoogle => 'Продолжить с Google';

  @override
  String get authDividerOr => 'или';

  @override
  String get authTos =>
      'Продолжая, вы соглашаетесь с Условиями и Политикой конфиденциальности.';

  @override
  String get authTosLink => 'Условиями и Политикой конфиденциальности';

  @override
  String get authPinPrompt => 'Введите 6-значный код из письма';

  @override
  String get profileSetupEyebrow => 'Почти готово';

  @override
  String get profileSetupTitlePlain => 'Как к вам';

  @override
  String get profileSetupTitleAccent => 'обращаться';

  @override
  String get profileSetupBody =>
      'Укажите имя — будем использовать его в приложении. Дата рождения необязательна, но помогает подбирать блюда по региону.';

  @override
  String get profileSetupNamePlaceholder => 'Полное имя';

  @override
  String get profileSetupBirthDateLabel => 'Дата рождения (необязательно)';

  @override
  String get profileSetupSubmit => 'Продолжить';

  @override
  String get profileSetupNameRequired => 'Введите имя.';

  @override
  String get tosTitlePlain => 'Условия и';

  @override
  String get tosTitleAccent => 'приватность';

  @override
  String get tosUpdated => 'ОБНОВЛЕНО · АПРЕЛЬ 2026';

  @override
  String get tosIntroP1 =>
      'MenuAssistant превращает фото меню ресторанов в ваш личный каталог с поиском. В этом документе простым языком описано, что мы делаем с данными, которыми вы делитесь при использовании приложения.';

  @override
  String get tosIntroP2 =>
      'Сервис предоставляется «как есть», без гарантий. Мы можем обновлять эти условия по мере развития продукта — о существенных изменениях уведомим внутри приложения заранее.';

  @override
  String get tosDataHeading => 'Какие данные мы собираем';

  @override
  String get tosDataBody =>
      'Мы храним загруженные вами фото, распознанные по ним блюда и рестораны, ваши избранные и базовые данные аккаунта (email, язык, валюту). Геолокация используется только чтобы различить рестораны с похожими названиями, если вы явно её разрешили, и не передаётся третьим лицам.';

  @override
  String get tosRightsHeading => 'Ваши права';

  @override
  String get tosRightsBody =>
      'Вы в любой момент можете экспортировать каталог, выйти и удалить аккаунт в разделе Профиль → Аккаунт. Удаление необратимо и в течение 30 дней снимает все связанные меню, блюда и избранные.';

  @override
  String get tosContactHeading => 'Контакты';

  @override
  String get tosContactBody =>
      'Вопросы, запросы и отзывы: hello@menuassistant.app. По вопросам приватности используйте тот же адрес со словом «Privacy» в теме.';

  @override
  String homeGreeting(String name) {
    return 'Привет, $name';
  }

  @override
  String get homeTitlePlain => 'Где сегодня?';

  @override
  String get homeTitleAccent => 'Ваши меню';

  @override
  String get homeSearchPlaceholder => 'Места, блюда, кухни…';

  @override
  String get homeChipRecent => 'Недавние';

  @override
  String get homeChipLiked => 'Избранные';

  @override
  String get homeChipGlutenFree => 'Без глютена';

  @override
  String get homeEmpty => 'Пока пусто';

  @override
  String get homeEmptyBody =>
      'Снимите первое меню — с него начнётся ваша коллекция.';

  @override
  String get homeCaptureFirst => 'Снять первое меню';

  @override
  String get restaurantSearchPlaceholder => '«что-то с треской, до 25€»';

  @override
  String get restaurantLanguagePair => 'RU↔PT';

  @override
  String get restaurantChipCurrency => '€';

  @override
  String get restaurantChipVeg => '🌱 вегетарианское';

  @override
  String get restaurantChipGlutenFree => 'без глютена';

  @override
  String get dishComposition => 'Состав';

  @override
  String get dishPrice => 'Цена';

  @override
  String get addMenuEyebrow => 'Новое меню';

  @override
  String get addMenuTitlePlain => 'Выберите';

  @override
  String get addMenuTitleAccent => 'источник';

  @override
  String get addMenuProcessingHint => '~20 секунд на обработку';

  @override
  String get addMenuPrimary => 'Сфотографировать';

  @override
  String get addMenuGallery => 'Галерея';

  @override
  String get addMenuPdf => 'PDF';

  @override
  String get addMenuLink => 'Ссылка';

  @override
  String addMenuPageN(int n, int total) {
    return 'Страница $n / $total';
  }

  @override
  String get addMenuAddPage => 'Добавить страницу';

  @override
  String get addMenuParse => 'Готово → Распознать';

  @override
  String get addMenuProcessing => 'Распознаём меню…';

  @override
  String get matchConfirmTitle => 'Это тот же ресторан?';

  @override
  String matchConfirmSimilarity(int percent) {
    return 'сходство $percent%';
  }

  @override
  String matchConfirmDistance(int meters) {
    return 'в $meters м';
  }

  @override
  String get matchConfirmYes => 'Да, это он';

  @override
  String get matchConfirmNo => 'Нет, другой';

  @override
  String get profileStatsPlaces => 'Мест';

  @override
  String get profileStatsDishes => 'Блюд';

  @override
  String get profileStatsCities => 'Городов';

  @override
  String get profileSettingsLikedPlaces => 'Избранные места';

  @override
  String get profileSettingsLikedDishes => 'Избранные блюда';

  @override
  String get profileSettingsLanguage => 'Язык';

  @override
  String get profileSettingsCurrency => 'Валюта';

  @override
  String get profileSettingsDiet => 'Диета';

  @override
  String get profileSettingsTheme => 'Тема';

  @override
  String get profileSettingsTerms => 'Условия и приватность';

  @override
  String get themeWarm => 'Тёплая';

  @override
  String get themeSage => 'Шалфей';

  @override
  String get themeMidnight => 'Тёмная';

  @override
  String get themeSystem => 'Системная';

  @override
  String get geoPermissionRationale =>
      'Доступ к геолокации помогает точнее определить ресторан, когда названия совпадают.';

  @override
  String get geoPermissionDeniedToast =>
      'Геолокация отключена — используем EXIF или IP.';

  @override
  String get errorGeneric => 'Что-то пошло не так. Попробуйте снова.';

  @override
  String get errorNetwork => 'Нет подключения. Проверьте сеть.';

  @override
  String get errorUpload => 'Не удалось загрузить меню.';
}
