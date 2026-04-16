# Curated Dish Dataset — дизайн и план реализации

Документ описывает план собственного food-датасета, который заменит
неудачный Sprint 4 (Unsplash Lite). Цель — high-precision dish-level
поиск картинок и метаданных без зависимости от сторонних API в hot path.

---

## ⚠️ Legal constraints (критично, читать перед любым импортом)

Commercial SaaS — самая строгая категория copyright. Всё что попадёт в
`curated_dish` и `curated_dish_image` должно быть **юридически чистым**,
иначе риск DMCA takedowns, исков (statutory damages up to $150K/image в US),
снятия приложения из App Store/Play Store, проблем с инвесторами.

### Что ЗАПРЕЩЕНО делать (даже если "все делают")

**❌ Скрапить TheMealDB, Wikipedia, recipe blogs**
- ToS violations + EU database rights (защита collections независимо от copyright на items)
- Database rights действуют ~15 лет, commercial use без permission = нарушение

**❌ Использовать img2img / Photoshop фильтры на чужих фото**
- Это **derivative work** по copyright law — не отмывает origin
- Метаданные fal.ai/SD могут быть запрошены court order и показать input photo
- Photoshop filters не делают работу "substantially transformed" — courts смотрят на recognition, не на pixel count
- Прецедент: [Andersen v. Stability AI](https://www.courtlistener.com/docket/66732129/andersen-v-stability-ai-ltd/) (2024-2025, US) и EU InfoSoc Directive Article 2

**❌ Копировать descriptions с переводом**
- Translations = derivative works, требуют permission от original author
- Берём только facts (ingredients, country, preparation method) — не защищены copyright

**❌ Копировать Wikipedia article text (даже перефразируя или переводя)**
- Wikipedia text лицензирован **CC BY-SA 4.0** — виральный ShareAlike clause
- Любой derivative (твой перевод, твоя modified description) попадает под ту же CC BY-SA
- Это **killer для closed-source SaaS**: твоя БД дескрипшенов становится public domain в том же смысле, конкуренты могут выкачать, UI нужна attribution + license notice
- **Альтернатива**: читать Wikipedia для research → писать свои descriptions с нуля; или генерировать через Claude на основе **facts** (не prose) из Wikidata
- Facts из Wikipedia infoboxes берём **через Wikidata SPARQL** (CC0, не CC BY-SA) — те же данные, чистая лицензия

**❌ Использовать research-only datasets**
- Recipe1M+ — scraped, non-commercial only
- Food-101 — academic, non-commercial only
- Yummly/EatSmart datasets — commercial лицензии требуются

### Что РАЗРЕШЕНО и формирует bootstrap стратегию

**✅ Wikidata SPARQL — CC0, fully commercial OK**
- Dish entities + multilingual labels + country/cuisine/ingredients
- **Не брать** P18 images — mixed licenses, делаем свои через fal.ai text-to-image
- Free, unlimited, no attribution required

**✅ TheMealDB API с $25 supporter key — explicit commercial rights**
- Key покупается за one-time donation на themealdb.com
- Берём только **facts**: name, region, category, ingredient list
- **НЕ** брать descriptions, instructions, `strMealThumb` images — это отдельный copyright

**✅ Claude generated text — per Anthropic Commercial Terms**
- Descriptions, translations, search queries — output принадлежит тебе
- Commercial use разрешён
- Cost ~$0.0001-0.0003 per short description

**✅ fal.ai Flux **text-to-image** (критично: не img2img!)**
- Prompt describes dish in words, **no input photo at all**
- Output 100% original per fal.ai ToS — commercial OK
- $0.008/img, Flux 2 даёт production quality

**✅ User-uploaded photos с explicit license grant**
- В Terms of Service приложения: "By uploading content, you grant MenuAssistant a worldwide, non-exclusive, royalty-free license to use, modify, and display the content..."
- Паттерн Yelp/Foursquare/Google Maps
- Требует явного согласия юзера (checkbox при upload, не implicit)

**✅ Wikimedia Commons images — но только CC0 / CC BY (не SA, не NC)**
- Commons содержит миллионы свободных изображений, включая много food photos
- У каждого файла **индивидуальная** лицензия — проверять через API, не по факту наличия в Commons
- **Разрешены**: `PD-*` (public domain), `CC0`, `CC BY 2.0/3.0/4.0`
- **Запрещены**: `CC BY-SA *` (виральный ShareAlike), `CC BY-NC *` (non-commercial), `GFDL` (сложный, избегать), `fair use` (не лицензированы для reuse)
- **Attribution**: для CC BY обязательна. UI должен показывать "Photo by {Artist} via Wikimedia Commons, {License}" с ссылкой на страницу файла
- **API**: `commons.wikimedia.org/w/api.php?action=query&prop=imageinfo&iiprop=url|extmetadata` возвращает `LicenseShortName`, `UsageTerms`, `Artist`, `Credit` — фильтруем программно

**✅ Stock photo лицензии (Adobe Stock, Shutterstock, iStock)**
- $5-30/фото, explicit commercial rights
- Дорого для 5K dishes, но 100% clean
- Альтернатива: commission food photographer ($50-200/фото)

### Decision matrix для new data sources

Прежде чем интегрировать любой новый источник, проверить:

| Критерий | Что проверить |
|---|---|
| **License** | Явное указание "commercial use OK" в ToS или file license |
| **Attribution** | Требуется ли? Если да — UI должен показывать attribution |
| **Share-alike** | Нет ли clause типа CC BY-SA которая заставляет твой dataset быть под той же лицензией (killer для closed-source SaaS) |
| **Database rights** | Если источник — curated collection в EU, нельзя copy даже free items |
| **Rate limits / ToS** | Запрещён ли automated access? Scraping = ToS violation даже для публичных данных |
| **Indemnification** | Защищает ли источник тебя от third-party claims (rarely, but stock agencies do) |

Если хоть один пункт unclear — **не использовать**, искать альтернативу.

---

## Зачем свой датасет

**Проблема со сторонними источниками** (выявлено в Sprint 4):
- **Unsplash Lite** — keywords scene-level (`food`, `vegetable`), не
  dish-level. 0% hit rate для конкретных блюд.
- **Unsplash API** — limit 50/час demo, требует production review для 5K/час.
- **Pexels** — 200/час, фото общего характера.
- **fal.ai** — генерация $0.008/img, не всегда нужного качества.

**Что даёт собственный датасет**:
- Dish-level matching с точным name + multilingual aliases
- Controlled vocabulary тегов → consistent search
- Multiple image styles per dish → variety в UI
- Нет rate limits, нет network roundtrips
- Полный контроль качества (нет случайных landscape фото)

---

## Схема данных

### Таблица `curated_dish`

```yaml
class: CuratedDish
table: curated_dish
fields:
  # ── Identity ──────────────────────────────────────────────
  # Lowercase, accent-stripped, no punctuation. Unique key.
  # Example: "spaghetti carbonara"
  canonicalName: String

  # Pretty display name. Example: "Spaghetti alla Carbonara"
  displayName: String

  # Wikidata Q-id for cross-reference and bulk enrichment.
  # Example: "Q83218" for Carbonara
  wikidataId: String?

  # ── Classification (controlled vocabulary, see TAXONOMY) ──
  cuisine: String?            # "italian", "japanese", "portuguese"
  countryCode: String?        # ISO 3166-1 alpha-2: "IT", "JP", "PT"
  courseType: String?         # "main", "appetizer", "dessert", "drink", "side"

  # ── Discovery & matching ─────────────────────────────────
  # Multilingual + spelling variants for name matching.
  # ["carbonara", "паста карбонара", "espaguete à carbonara"]
  aliases: List<String>?

  # Tags from controlled vocabulary (see TAXONOMY section).
  # ["pasta", "egg", "pork", "italian", "creamy"]
  tags: List<String>?

  # Primary ingredients (top 3-5). Used for search ranking and
  # diet-flag inference.
  # ["spaghetti", "egg", "guanciale", "pecorino"]
  primaryIngredients: List<String>?

  # Diet flags inferred from ingredients.
  # ["contains_pork", "contains_dairy", "contains_egg"]
  dietFlags: List<String>?

  # ── Content ──────────────────────────────────────────────
  # 1-3 sentences, factual, English.
  description: String?

  # Optional rich-text origin/history. Used for display, not search.
  origin: String?

  # ── Quality control ─────────────────────────────────────
  # "draft" | "approved" | "rejected"
  status: String

  # Reviewer who approved (admin email or system "auto").
  approvedBy: String?

  createdAt: DateTime
  updatedAt: DateTime

indexes:
  curated_dish_canonical_idx:
    fields: canonicalName
    unique: true
  curated_dish_wikidata_idx:
    fields: wikidataId
  curated_dish_cuisine_idx:
    fields: cuisine
  curated_dish_status_idx:
    fields: status
```

### Таблица `curated_dish_image`

```yaml
class: CuratedDishImage
table: curated_dish_image
fields:
  curatedDish: CuratedDish?, relation

  # Where the image is hosted. Self-hosted in our S3 (via ImageService)
  # for licensed photos, or hotlinked from open sources.
  imageUrl: String

  # "manual" | "tmdb" | "wikimedia" | "user_uploaded" | "fal_ai_generated"
  source: String

  # Original source URL for license tracking.
  sourceUrl: String?

  # License: "cc0" | "cc-by" | "cc-by-sa" | "unsplash" | "pexels" | "owned"
  license: String

  attribution: String?
  attributionUrl: String?

  # Quality grade (manual or AI-assigned): 1-5.
  # 5 = hero shot, professional, isolated dish
  # 4 = professional, may have context (table, hands)
  # 3 = good amateur, recognizable, well-lit
  # 2 = acceptable, low contrast or busy background
  # 1 = bottom barrel, only use as last resort
  qualityScore: int

  # Style tags for variety rotation (see TAXONOMY → image styles).
  # ["plate", "topdown", "studio", "bright"]
  styleTags: List<String>?

  # Mark one as primary per dish. Used as default in UI.
  isPrimary: bool

  width: int?
  height: int?
  createdAt: DateTime

indexes:
  curated_dish_image_dish_idx:
    fields: curatedDishId
  curated_dish_image_quality_idx:
    fields: qualityScore
```

### Связь с существующим Dish Catalog

Существующий `dish_catalog` остаётся как **runtime catalog** (что мы видели
в реальных меню пользователей). `curated_dish` — это **canonical knowledge
base**. Связка:

```yaml
# Добавить в dish_catalog.spy.yaml:
fields:
  curatedDish: CuratedDish?, relation  # nullable: не все dishes есть в curated
```

При processing меню `DishCatalogService.findOrCreate`:
1. Нормализуем имя
2. Ищем в `curated_dish` через canonical name + aliases — если match, используем его данные (description, image, tags) **и** линкуем `dish_catalog.curatedDishId`
3. Если не нашли — создаём `dish_catalog` запись с `curatedDishId = null` и идём по старому enrichment пути (Wikidata → Unsplash API → ...)

### Backfill workflow

Когда новое блюдо не найдено в curated, оно попадает в "candidates" pool.
Админ может позже:
1. Посмотреть список `dish_catalog` записей с `curatedDishId IS NULL`,
   отсортированных по частоте появления (популярные блюда первыми)
2. Создать соответствующий `curated_dish` через UI
3. Запустить retroactive linking — все `dish_catalog` с этим
   normalizedName линкуются обратно

---

## Источники данных для bootstrap

Приоритет: **бесплатные + commercial-OK** в первую очередь.

### 1. TheMealDB (рекомендую начать отсюда)

- **URL**: [themealdb.com/api.php](https://www.themealdb.com/api.php)
- **Размер**: ~300 dishes
- **Содержит**: dish name, region (cuisine), category, instructions, 20
  ingredients (с measurements), 1 image (~600x600), YouTube link, tags
- **Лицензия**: Free for educational/non-commercial. Personal API key
  ($25 one-time donation) даёт лицензию на коммерческое использование. Дёшево.
- **API key**: `1` — public test key (rate-limited, для разработки ок)
- **Endpoints**:
  - `GET /api/json/v1/1/list.php?c=list` — все категории
  - `GET /api/json/v1/1/filter.php?c=Seafood` — все блюда категории
  - `GET /api/json/v1/1/lookup.php?i=52772` — детали блюда
  - `GET /api/json/v1/1/search.php?s=carbonara` — поиск по имени

**Bootstrap flow**:
```
for each category:
  list dishes
  for each dish:
    fetch details
    map to CuratedDish:
      canonicalName = normalize(strMeal)
      displayName = strMeal
      cuisine = strArea.toLowerCase()
      courseType = inferFromCategory(strCategory)
      aliases = [normalize(strMeal)]
      primaryIngredients = collect non-empty strIngredient1..20
      tags = [strCategory, ingredient_tags]
      description = first 2 sentences of strInstructions
      origin = strArea + " cuisine"
    save CuratedDish (status='approved' if from TheMealDB, since curated source)
    save CuratedDishImage:
      imageUrl = strMealThumb
      source = 'tmdb'
      license = 'commercial' (with paid key) or 'cc0_via_donation'
      qualityScore = 4 (TheMealDB photos are uniformly good)
```

**Что это даёт**: ~300 high-quality canonical dishes с фото и базовыми
метаданными за один импорт. Coverage: глобальная классика (паста, бургер,
карри, суши, тако, и т.п.).

### 2. Wikidata SPARQL (для multilingual aliases и cross-reference)

- **URL**: [query.wikidata.org](https://query.wikidata.org/)
- **Размер**: ~10K+ dish entities
- **Содержит**: multilingual labels (50+ языков), country, cuisine, ingredients,
  Wikipedia links, Q-ids
- **Лицензия**: CC0 — fully commercial OK
- **API**: SPARQL endpoint, REST JSON

**Пример SPARQL query** для всех блюд с country and English label:

```sparql
SELECT ?dish ?dishLabel ?countryLabel ?cuisineLabel ?image
WHERE {
  ?dish wdt:P31/wdt:P279* wd:Q746549.  # instance of dish (or subclass)
  OPTIONAL { ?dish wdt:P495 ?country. }
  OPTIONAL { ?dish wdt:P2012 ?cuisine. }
  OPTIONAL { ?dish wdt:P18 ?image. }
  SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
}
LIMIT 5000
```

**Multilingual aliases** для одной dish entity:
```sparql
SELECT ?label
WHERE {
  wd:Q83218 rdfs:label|skos:altLabel ?label .
  FILTER(LANG(?label) IN ("en","ru","pt","es","fr","it","de","ja","zh"))
}
```

**Bootstrap flow**:
```
1. Run SPARQL query → 5000 dish Q-ids
2. For each, fetch labels in target languages → aliases
3. For each, fetch P18 (image) → curated_dish_image with license=wikimedia
4. Match against TheMealDB by canonicalName → enrich existing entries
5. Save new ones with status='draft' for admin review
```

**Что это даёт**: multilingual aliases для existing curated dishes,
Wikidata cross-reference (`wikidataId` field), open-licensed images
для тех блюд где есть Wikimedia Commons фото.

### 3. Wikimedia Commons — первичный источник images (для popular dishes)

- **URL**: [commons.wikimedia.org](https://commons.wikimedia.org)
- **Содержит**: миллионы изображений, включая **десятки тысяч food photos**
- **Лицензия**: mixed — каждый файл имеет **свою** лицензию. Мы берём **только**:
  - `PD-*` (Public Domain variants)
  - `CC0 1.0 Universal`
  - `CC BY 2.0 / 3.0 / 4.0`
- **Игнорируем**: `CC BY-SA *` (ShareAlike viral), `CC BY-NC *` (non-commercial), `GFDL`, `fair use`
- **Attribution**: для CC BY обязательна (имя автора + ссылка на Commons file page + license name)

#### API для программной проверки лицензии

```
GET https://commons.wikimedia.org/w/api.php
  ?action=query
  &prop=imageinfo
  &iiprop=url|size|extmetadata
  &iiurlwidth=1024
  &titles=File:{filename}
  &format=json
```

В ответе секция `extmetadata` содержит structured metadata:
- `LicenseShortName` — e.g. "CC BY 4.0"
- `LicenseUrl` — ссылка на license text
- `Artist` — автор (может содержать HTML, sanitize)
- `Credit` — credit line (то что показывать в UI attribution)
- `UsageTerms` — free text terms (иногда дополнения)

Фильтр-функция для нашего импортёра:
```dart
bool isCommerciallyUsable(String licenseShortName) {
  final normalized = licenseShortName.toLowerCase().trim();
  const allowed = {
    'public domain', 'pd', 'cc0', 'cc0 1.0',
    'cc by 2.0', 'cc by 3.0', 'cc by 4.0',
    'cc by-4.0', 'cc-by-4.0',  // вариации написания
  };
  return allowed.contains(normalized) ||
      normalized.startsWith('public domain') ||
      normalized.startsWith('pd-');
  // НЕ принимаем: cc by-sa *, cc by-nc *, gfdl, fair use
}
```

#### Поиск фото для dish

Есть два пути:

**Вариант A: через Wikipedia article → infobox image**
Если у dish есть `wikidataId`, через Wikidata property `P18` получаем главную фото из Wikipedia infobox:
```sparql
SELECT ?dish ?image WHERE {
  VALUES ?dish { wd:Q83218 }  # Carbonara
  OPTIONAL { ?dish wdt:P18 ?image. }
}
```
Результат — URL на Commons файл. Далее через imageinfo API проверить лицензию, взять если подходит.

**Вариант B: search в Commons по dish name**
```
GET https://commons.wikimedia.org/w/api.php
  ?action=query
  &generator=search
  &gsrnamespace=6
  &gsrsearch={dishName}
  &prop=imageinfo
  &iiprop=url|extmetadata
  &format=json
```
Возвращает до 10 файлов matching query. Фильтровать по лицензии, брать первые подходящие.

Для bootstrap — использовать оба метода: A для dishes с wikidataId (быстрее, более точно), B для остальных или для дополнения (top-3 images per dish).

#### Coverage estimate

Для популярных блюд (глобальная классика: pizza, carbonara, sushi, tacos) — **30-50%** покрытие Commons с commercial-friendly licenses. Для региональной экзотики — **5-10%**.

#### Как хранить в `curated_dish_image`

```yaml
imageUrl: <resolved hotlink URL from Commons>
source: 'wikimedia'
sourceUrl: <file page URL>
license: 'cc-by-4.0' | 'cc0' | 'pd'
attribution: 'Photo by {Artist} via Wikimedia Commons, {LicenseShortName}'
attributionUrl: <file page URL>
qualityScore: 3 (default, admin review может повысить до 4-5)
```

#### Bootstrap стратегия

1. После `import_wikidata_dishes.dart` — у каждого dish есть `wikidataId`
2. В `generate_images.dart` **первым делом** пробуем Wikimedia Commons:
   - Вариант A через P18 image
   - Если нет или лицензия unacceptable — Вариант B через search
   - Проверяем лицензию, минимум 400×400 resolution, ratio 0.5-2.0
3. Если Commons нашёл подходящее фото — сохраняем, `source='wikimedia'`
4. Если нет — **fallback** на fal.ai text-to-image, `source='fal_ai_generated'`

**Экономия**: для 5000 dishes с ~30% Commons coverage → ~1500 images бесплатно из Commons, ~3500 через fal.ai → **$56 вместо $80** на bootstrap images. Плюс Commons даёт "настоящие" фото популярных блюд, что качественнее fal.ai generations.

### 4. ⚠️ Spoonacular — **НЕ используем, см. termination risk**

- **URL**: [spoonacular.com/food-api](https://spoonacular.com/food-api)
- **Содержит**: ингредиенты, nutrition facts, allergens, recipes, images
- **Лицензия**: коммерческая subscription, $29-149/мес

**Почему НЕ**:

1. **Termination clause**: типичные commercial API subscription ToS обязуют
   удалить все кэшированные данные в течение N дней после отмены подписки.
   Это значит любой persistent dataset, построенный на Spoonacular, становится
   "аренда а не покупка" — как только перестаёшь платить, вынужден удалять.

2. **Images не их**: Spoonacular агрегирует recipes из Food.com, AllRecipes
   и других sites. Images часто принадлежат оригинальным публикаторам, не
   Spoonacular — они могут не иметь права сублицензировать.

3. **Cost/value не сходится**: $350/год за данные, которые почти все
   доступны из бесплатных источников:
   - Ingredients → Wikidata SPARQL + TheMealDB (facts, слабо защищены copyright)
   - Descriptions → Claude generation (owned)
   - Images → fal.ai + Wikimedia Commons (owned/CC licensed)
   - Nutrition facts → USDA FoodData Central (см. #5 ниже) — **бесплатно + public domain**

**Возможное исключение**: если понадобится очень точный recipe-to-dish
matching с gram-weighted ingredients (для calorie counter feature),
Spoonacular используется **only during bootstrap**, данные сразу
трансформируются в derived facts (nutrition per 100g, основной ingredient
list) и сохраняются как **наши** facts. После — subscription cancelled.
Это серая зона, нужна юр-консультация. Не рекомендую для MVP.

### 5. USDA FoodData Central (замена Spoonacular для nutrition)

- **URL**: [fdc.nal.usda.gov/api-guide.html](https://fdc.nal.usda.gov/api-guide.html)
- **Размер**: ~400K food items с детальной nutrition
- **Содержит**: calories, macros (protein/fat/carbs), micros (vitamins,
  minerals), serving sizes. Не содержит готовых dishes (это ingredient-level),
  но можно композировать nutrition для dish из его ingredients.
- **Лицензия**: US Government work → **Public Domain** (no copyright), fully
  commercial, no restrictions
- **API key**: бесплатный, получить за 1 минуту на сайте (в целях rate limiting)
- **Rate limit**: 1000 req/hour (free tier)

**Использование**: nutrition enrichment опциональный — можно отложить до
Sprint 5+ когда появится фича "calorie counter" или "nutrition info per dish".
Для MVP curated dataset не блокирует.

### 5. Open Food Facts (опционально)

- **URL**: [world.openfoodfacts.org](https://world.openfoodfacts.org/)
- **Содержит**: миллионы packaged products (брендовые товары)
- **Лицензия**: ODbL — fully commercial OK
- **Use case**: НЕ для блюд (это для упакованных товаров). Но если решим
  расширять на packaged drinks, snacks — отличный источник.

### 6. Food-101 (только non-commercial)

- 101 категория × 1000 photos = 101K images
- Только academic/non-commercial. **Нельзя** использовать для нашего SaaS.
- Упомянут только как ориентир для категоризации.

### 7. Recipe1M+ (только research)

- 1M+ рецептов с фото, scraped с cooking sites
- License: research-only. **Нельзя** использовать.

---

## Local dev image storage (MockImageService)

Пока настоящий S3 через `.NET ImageService` не подключён (планируется на
Sprint 6), в dev используется **LocalFileImagePersistence** — файловая
реализация `ImagePersistenceService` interface, сохраняющая байты на
локальный диск.

### Дизайн

**Расположение файлов**: `web/static/images/curated/<hash>.<ext>`

Ключевой трюк: Serverpod уже hoster `web/static/` через `StaticRoute.directory(root)`
в [server.dart](MenuAssistant/menu_assistant_server/lib/server.dart). Значит
файлы **автоматически** доступны по URL `http://localhost:8080/static/images/curated/<hash>.<ext>`
без дополнительного endpoint'а.

### Реализация

```dart
// lib/src/services/image_persistence/local_file_image_persistence.dart
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

import 'image_persistence_service.dart';

/// Dev-only implementation that downloads bytes from [sourceUrl] and saves
/// them to the local `web/static/images/curated/` directory. The saved file
/// is served by Serverpod's built-in StaticRoute.
///
/// Filename is the first 16 chars of sha256(bytes) — content-addressable,
/// so identical images across dishes dedup automatically.
///
/// Production uses [ImageServicePersistence] instead (.NET ImageService → S3).
class LocalFileImagePersistence implements ImagePersistenceService {
  final String _storageDir;
  final String _publicBaseUrl;
  final http.Client _httpClient;

  LocalFileImagePersistence({
    required String storageDir,
    required String publicBaseUrl,
    http.Client? httpClient,
  })  : _storageDir = storageDir,
        _publicBaseUrl = publicBaseUrl,
        _httpClient = httpClient ?? http.Client();

  @override
  Future<String> persist({
    required String sourceUrl,
    required String source,
    required int dishCatalogId,
  }) async {
    try {
      final response = await _httpClient.get(Uri.parse(sourceUrl));
      if (response.statusCode != 200) return sourceUrl;

      // Content-addressable filename: first 16 chars of sha256(bytes)
      final hash = sha256.convert(response.bodyBytes).toString().substring(0, 16);
      final ext = _guessExtension(response.headers['content-type']) ?? 'jpg';
      final filename = '$hash.$ext';

      await Directory(_storageDir).create(recursive: true);
      final filePath = p.join(_storageDir, filename);
      await File(filePath).writeAsBytes(response.bodyBytes);

      return '$_publicBaseUrl/$filename';
    } catch (_) {
      return sourceUrl;
    }
  }

  String? _guessExtension(String? contentType) {
    if (contentType == null) return null;
    if (contentType.contains('jpeg')) return 'jpg';
    if (contentType.contains('png')) return 'png';
    if (contentType.contains('webp')) return 'webp';
    if (contentType.contains('gif')) return 'gif';
    return null;
  }
}
```

### Wire-up в server.dart

```dart
// В _configureServices(pod):
final runMode = pod.runMode;  // 'development' | 'staging' | 'production'
final ImagePersistenceService imagePersistence;

if (runMode == 'development') {
  final apiConfig = pod.config.apiServer;
  imagePersistence = LocalFileImagePersistence(
    storageDir: 'web/static/images/curated',
    publicBaseUrl: '${apiConfig.publicScheme}://${apiConfig.publicHost}:${apiConfig.publicPort}/static/images/curated',
  );
} else {
  // staging / production: real S3 через .NET ImageService
  imagePersistence = ImageServicePersistence(
    baseUrl: key('imageServiceBaseUrl') ?? 'http://image-service:5000',
  );
}
```

### Зависимости

В `pubspec.yaml` нужно добавить:
```yaml
dependencies:
  crypto: ^3.0.5      # для sha256
  path: ^1.9.0        # для p.join (обычно уже есть)
```

### .gitignore

Добавить в `MenuAssistant/menu_assistant_server/.gitignore` или корневой:
```
web/static/images/curated/
```

Чтобы тысячи dev-картинок (5000 × ~100KB = 500MB) не попали в git. Папка
создаётся автоматически при первом запуске.

### Преимущества content-addressable naming

- **Автоматическая дедупликация**: если Wikimedia Commons отдаёт одну и ту же
  картинку для "Spaghetti" и "Spaghetti alla Carbonara" (через общий
  Wikipedia infobox), запишется один раз
- **Идемпотентность**: re-running bootstrap не создаёт дубликатов
- **Простая миграция в S3**: hash остаётся filename key в S3 bucket

### Миграция в настоящий S3 (Sprint 6)

Когда ImageService + .NET/S3 подключатся:
1. `rclone copy web/static/images/curated/ s3://menuassistant-curated-assets/ --progress`
2. Обновить `ImagePersistenceService` bind в `server.dart` на `ImageServicePersistence`
3. Обновить hostname в `curated_dish_image.imageUrl` — скрипт миграции
   (`bin/migrate_image_urls.dart`) переписывает `http://localhost:8080/static/...`
   на `https://cdn.menuassistant.com/...`
4. Файлы становятся недоступны локально, но это ок — dev тоже использует
   prod CDN URL после миграции

Подробнее про миграцию см. следующую секцию.

---

## InferenceService — self-hosted ML микросервис

Для Sprint 4.5 image generation (и опционально translations/descriptions)
используется отдельный Python микросервис на **удалённой машине с GPU**.
Serverpod обращается к нему по HTTP API, получает bytes сгенерированного
изображения, сохраняет через `ImagePersistenceService` как обычно.

### Почему отдельный сервис, а не in-process Python в Serverpod

1. **Изоляция GPU hardware**: GPU на удалённой dev-машине (Ryzen 5950x +
   RTX 3080 Ti 12GB), Serverpod backend может крутиться где угодно (локально,
   Docker, prod ECS). Inference работает отдельно и реиспользуется
2. **Language mismatch**: Serverpod — Dart, ML ecosystem — Python. Subprocess
   spawn внутри Serverpod возможен, но грязно. HTTP API чище
3. **Deploy independence**: сервис можно рестартовать/обновлять независимо
   от Serverpod. Downtime InferenceService не падает Serverpod
4. **Scale flexibility**: можно переместить на другое железо, cluster, или
   поднять несколько instances за load balancer — без изменений в Serverpod
5. **Pluggable models**: easy swap SDXL → Flux → другая модель без
   перекомпиляции Serverpod

### Архитектура

```
┌──────────────────┐      HTTP POST       ┌─────────────────────┐
│   Serverpod      │ ──/generate/image──► │  InferenceService   │
│   Backend        │                       │  (Python FastAPI)   │
│   (Dart, Docker) │ ◄── image/jpeg ──────│  + SDXL/Flux pipe   │
└──────────────────┘                       └─────────────────────┘
        │                                           │
        │                                           ▼
        │                                    ┌──────────────┐
        │                                    │  GPU         │
        │                                    │  (3080 Ti)   │
        │                                    └──────────────┘
        ▼
┌──────────────────┐
│ ImagePersistence │ (dev: LocalFileImagePersistence → web/static/)
│                  │ (prod: ImageServicePersistence → .NET → S3)
└──────────────────┘
```

**Ключевой момент**: InferenceService **stateless** — возвращает bytes, не URL.
Всё хранение image файлов остаётся в домене Serverpod (через
`ImagePersistenceService`). Это позволяет InferenceService рестартовать,
мигрировать, заменять без влияния на existing image URLs в БД.

### Расположение в монорепо

```
MenuAssistant3/
├── MenuAssistant/              # Flutter + Serverpod (Dart)
├── ImageService/               # existing .NET (S3 storage)
├── InferenceService/           # NEW — Python FastAPI + SDXL
│   ├── README.md
│   ├── Dockerfile
│   ├── docker-compose.yml
│   ├── requirements.txt
│   ├── app/
│   │   ├── __init__.py
│   │   ├── main.py             # FastAPI app entry
│   │   ├── config.py           # env vars, secrets
│   │   ├── auth.py             # shared secret middleware
│   │   ├── routes/
│   │   │   ├── __init__.py
│   │   │   ├── health.py       # GET /health, GET /models
│   │   │   └── image.py        # POST /generate/image
│   │   └── models/
│   │       ├── __init__.py
│   │       └── sdxl_pipeline.py # diffusers wrapper
│   └── .gitignore              # models/, venv/, __pycache__
└── (будущий) PaymentService/
```

### API спецификация

**`POST /generate/image`** — генерация изображения из текста

Request:
```json
{
  "prompt": "Professional food photography of Spaghetti alla Carbonara, Italian cuisine, featuring spaghetti, egg, guanciale, pecorino, plated on white ceramic, soft natural lighting, shallow depth of field, appetizing, studio quality, no people, no text",
  "negative_prompt": "blurry, low quality, cartoon, drawing, text, watermark, people, hands",
  "width": 1024,
  "height": 1024,
  "steps": 30,
  "guidance_scale": 7.5,
  "seed": null,
  "model": "sdxl"
}
```

Response (success 200):
- `Content-Type: image/jpeg`
- Body: raw JPEG bytes
- Headers:
  - `X-Inference-Time-Ms: 4523`
  - `X-Model: sdxl-base-1.0`
  - `X-Seed: 12345`

Response (error 4xx/5xx):
```json
{
  "error": "CUDA out of memory",
  "details": "..."
}
```

**`GET /health`** — liveness check, ничего не делает кроме "200 OK"

**`GET /models`** — список доступных моделей
```json
{
  "available": [
    {"id": "sdxl", "name": "Stable Diffusion XL 1.0", "vram_gb": 8},
    {"id": "flux-schnell-nf4", "name": "Flux.1 Schnell (NF4)", "vram_gb": 7}
  ],
  "loaded": "sdxl",
  "gpu": "NVIDIA GeForce RTX 3080 Ti",
  "vram_free_gb": 4.2,
  "vram_total_gb": 12.0
}
```

### Authentication

Простой **shared secret в Bearer header**. MVP-level, достаточно для internal service.

```
Authorization: Bearer {INFERENCE_SERVICE_SECRET}
```

Секрет генерируется при deploy (`openssl rand -hex 32`), хранится:
- В `config/passwords.yaml` Serverpod как `inferenceServiceSecret`
- В env variable `INFERENCE_SERVICE_SECRET` на InferenceService
- **Не** в git

Middleware в FastAPI проверяет header, возвращает 401 при mismatch.

**Upgrade path**: когда понадобится (Sprint 6 multi-service), заменить на
internal JWT с issuer/audience (тот же pattern что `InternalJwt:*` в
ImageService).

### Deployment

**Вариант A: Docker (рекомендую)**

```yaml
# InferenceService/docker-compose.yml
services:
  inference:
    build: .
    ports:
      - "8000:8000"
    environment:
      - INFERENCE_SERVICE_SECRET=${INFERENCE_SERVICE_SECRET}
      - MODEL_CACHE_DIR=/models
      - DEFAULT_MODEL=sdxl
    volumes:
      - ./models_cache:/models    # persistent model weights (~10GB)
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]
    restart: unless-stopped
```

Запуск:
```bash
# На remote GPU машине, один раз
cd InferenceService
echo "INFERENCE_SERVICE_SECRET=$(openssl rand -hex 32)" > .env
docker compose up -d --build

# Проверка
curl http://localhost:8000/health
```

Требуется [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/) на host машине для GPU passthrough в Docker.

**Вариант B: systemd service (без Docker)**

Если не хочется связываться с Docker + nvidia-runtime:
1. `python -m venv venv && source venv/bin/activate`
2. `pip install -r requirements.txt`
3. `/etc/systemd/system/inference.service` с `uvicorn app.main:app --host 0.0.0.0 --port 8000`
4. `systemctl enable --now inference`

Проще в setup, сложнее в cleanup / updates.

### Network connectivity

Serverpod (dev laptop) должен достучаться до InferenceService (remote GPU).

**Текущий вариант: Keenetic роутер + KeenDNS reverse proxy (HTTPS → HTTP)**

GPU машина стоит за роутером Keenetic. Наружу выдаётся HTTPS URL через
KeenDNS (встроенный DDNS + Let's Encrypt). Keenetic делает TLS termination
и перенаправляет трафик на internal `http://<lan-ip>:8000`.

```
Serverpod dev         Internet         Keenetic Router         GPU Machine
 laptop              (HTTPS)           (TLS termination)       (HTTP internal)
    │                   │                    │                       │
    └── HTTPS ─────────►│───► port 443 ──────►│──── HTTP :8000 ──────►│
        https://xxx.keenetic.pro               192.168.x.x:8000
```

**Настройка Keenetic**:
1. **KeenDNS** → "Сетевые правила → Доменное имя" — получаешь
   `yourname.keenetic.pro` (бесплатно) с auto Let's Encrypt SSL
2. **Port forwarding** → "Переадресация портов":
   внешний HTTPS (443) → внутренний `http://<GPU-LAN-IP>:8000`
3. **Dynamic IP** → KeenDNS авто-обновляет DNS при смене внешнего IP

**Config в Serverpod `passwords.yaml`**:
```yaml
shared:
  inferenceServiceBaseUrl: 'https://yourname.keenetic.pro'
  inferenceServiceSecret: '<secret>'
```

**Security**: Bearer token передаётся внутри HTTPS → encrypted in transit.
Без секрета — 401.

**Gotchas**:
- **NAT hairpin**: если Serverpod и GPU в одной LAN, обращение по
  `yourname.keenetic.pro` может не работать (NAT loopback). Обходить
  через `http://192.168.x.x:8000` напрямую (в passwords.yaml менять URL
  в зависимости от того откуда запускаешь)
- **Keenetic timeout**: default ~60 sec на HTTP connection. SDXL inference
  5-25 sec — обычно ок, но Flux Dev NF4 может занять 30+ sec. Если 504
  Gateway Timeout — увеличить timeout в настройках Keenetic
- **Keenetic restart**: port forwarding persistent, KeenDNS cert auto-renew

**Альтернативные варианты** (если KeenDNS не подойдёт):
1. **SSH port forwarding**: `ssh -N -L 8000:localhost:8000 user@gpu` — если есть SSH доступ к GPU машине
2. **Tailscale mesh VPN**: обе машины в private `100.x.x.x` — persistent, zero-config
3. **Cloudflare Tunnel**: outbound-only, никаких открытых портов. Бесплатно

### Config в Serverpod

**`config/passwords.yaml`**:
```yaml
shared:
  # ── Sprint 4.5: InferenceService (self-hosted GPU machine) ─────────
  inferenceServiceBaseUrl: 'http://localhost:8000'    # или Tailscale/LAN IP
  inferenceServiceSecret: '<generated-secret>'
```

**`lib/src/services/inference/inference_service_client.dart`** (новый файл):
```dart
import 'package:http/http.dart' as http;
import '../../service_registry.dart';

class InferenceServiceClient {
  final String _baseUrl;
  final String _secret;
  final http.Client _httpClient;
  static const _timeout = Duration(minutes: 3);  // long-running inference

  InferenceServiceClient({
    required String baseUrl,
    required String secret,
    http.Client? httpClient,
  })  : _baseUrl = baseUrl,
        _secret = secret,
        _httpClient = httpClient ?? http.Client();

  /// Generates an image from [prompt]. Returns raw JPEG bytes.
  /// Throws on non-200 or timeout.
  Future<List<int>> generateImage({
    required String prompt,
    String? negativePrompt,
    int width = 1024,
    int height = 1024,
    int steps = 30,
    double guidanceScale = 7.5,
    String model = 'sdxl',
  }) async {
    final response = await _httpClient
        .post(
          Uri.parse('$_baseUrl/generate/image'),
          headers: {
            'Authorization': 'Bearer $_secret',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'prompt': prompt,
            if (negativePrompt != null) 'negative_prompt': negativePrompt,
            'width': width,
            'height': height,
            'steps': steps,
            'guidance_scale': guidanceScale,
            'model': model,
          }),
        )
        .timeout(_timeout);

    if (response.statusCode != 200) {
      throw Exception(
        'InferenceService error ${response.statusCode}: ${response.body}',
      );
    }
    return response.bodyBytes;
  }

  Future<bool> isHealthy() async {
    try {
      final response = await _httpClient
          .get(Uri.parse('$_baseUrl/health'))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
```

### Интеграция с bootstrap pipeline

В `bin/generate_images.dart` вместо прямых HTTP calls к fal.ai:

```dart
final client = InferenceServiceClient(
  baseUrl: Serverpod.instance.getPassword('inferenceServiceBaseUrl')!,
  secret: Serverpod.instance.getPassword('inferenceServiceSecret')!,
);

// Sanity check перед batch run
if (!await client.isHealthy()) {
  stderr.writeln('InferenceService not reachable');
  exit(1);
}

// Для каждого dish без Commons hit:
final bytes = await client.generateImage(
  prompt: _buildFoodPrompt(dish),
  negativePrompt: 'blurry, cartoon, text, watermark, people',
  model: 'sdxl',
);

// Persist через ImagePersistenceService (локально в dev, S3 в prod)
final url = await imagePersistence.persistBytes(
  bytes: bytes,
  contentType: 'image/jpeg',
  source: 'inference_service',
  dishCatalogId: dish.id!,
);
```

**NB**: `ImagePersistenceService.persist()` сейчас принимает URL (fetch bytes
from that URL). Для InferenceService добавить новый метод `persistBytes()`
который принимает bytes напрямую. Обе реализации (`LocalFileImagePersistence`
и `ImageServicePersistence`) поддерживают оба метода.

### Экономика self-hosted vs cloud API

**Setup one-time**:
- Docker + NVIDIA Container Toolkit install: 30-60 минут
- InferenceService code (~200 LOC Python): 2-3 часа
- Model download (SDXL ~7GB): 10 минут
- Docker build + first run: 10 минут
- Total: **~3-4 часа**

**Per-bootstrap run** (5000 images):
- Electricity: ~400W × 8h × €0.35/kWh = **€1.12**
- GPU wear/tear: минимальный
- API cost: **€0**

**Per live fallback** (user uploads menu, exotic dish не в catalog):
- Inference time: ~5 sec for SDXL, ~10 sec for Flux NF4
- Marginal cost: ~€0.0001 (electricity)
- **vs fal.ai**: $0.008 per image — 80x дороже

**Долгосрочная экономия**: при 1000+ images/месяц (bootstrap + live fallbacks),
self-hosted окупает setup time за первый же месяц.

### Opционально: добавить translation endpoint (Sprint 5)

Тот же InferenceService может предоставлять и NLLB-200 translation:

```
POST /translate
{
  "text": "Spaghetti alla carbonara is a Roman pasta dish...",
  "source_lang": "eng_Latn",
  "target_lang": "rus_Cyrl"
}

Response:
{
  "translated": "Спагетти алла карбонара — римское блюдо..."
}
```

NLLB-200 distilled 600M занимает ~2GB VRAM (осталось ~10GB для SDXL) —
можно держать обе модели загруженными одновременно.

**Решение отложить на Sprint 5** — для bootstrap translations Claude cloud
стоит всего $21, не стоит добавлять complexity в начальный Sprint 4.5. Когда
будем делать Sprint 5 i18n — добавим `/translate` endpoint к существующему
InferenceService.

### Ограничения и gotchas

1. **Cold start**: первый запрос после старта сервиса грузит модель в VRAM
   (~30 sec). Warm requests ~5 sec. Health check следует делать до batch runs
2. **Single GPU = sequential**: один запрос за раз. Для concurrency
   нужно queue front + batch processing. Для bootstrap (sequential) это ok
3. **OOM на больших resolutions**: 1024×1024 ok для SDXL на 12GB, 2048×2048
   OOM. Не менять default без тестов
4. **Model switching expensive**: переключение между SDXL и Flux Schnell
   выгружает/загружает веса (~20 sec). Для production лучше держать один
   default model
5. **Network latency**: через SSH tunnel или Tailscale — добавляет 10-50ms
   на запрос, нерелевантно для 5-секундных generations
6. **Disk space**: model cache ~10GB (SDXL) или ~15GB (SDXL + Flux). На
   remote машине нужен SSD для приемлемого cold start

### Чек-лист перед запуском Sprint 4.5 bootstrap

- [ ] Remote GPU машина доступна (SSH / Tailscale / VPN)
- [ ] NVIDIA driver + CUDA 12.x установлены
- [ ] NVIDIA Container Toolkit (если Docker) или Python 3.11+ (если systemd)
- [ ] Минимум 20GB свободного диска (models + Docker images + buffer)
- [ ] Открыт порт 8000 для Serverpod (через tunnel или firewall rule)
- [ ] `InferenceService/` deployed и `curl /health` возвращает 200
- [ ] `inferenceServiceBaseUrl` + `inferenceServiceSecret` в Serverpod passwords.yaml
- [ ] Test one image generation call через `InferenceServiceClient` из Serverpod script
- [ ] Quality sample: 10 тестовых dishes через SDXL, визуально оценить результат

Если quality не устраивает — переключиться на Flux Schnell NF4 (сложнее
setup, но лучше качество). SDXL + food photography LoRA с civitai обычно
достаточно для MVP.

---

## Environment migration — seed dataset pattern

Основная проблема при переносе curated dataset из dev в prod: у нас **два типа
данных**, которые должны мигрировать синхронно:

1. **Structured data** — `curated_dish`, `curated_dish_image` metadata,
   `dish_translation` (5K rows × ~1KB = ~5-10MB текста)
2. **Binary assets** — сами файлы изображений (5K × ~100KB = ~500MB)

Если их рассинхронизировать — получаем висящие ссылки на несуществующие файлы.

### Стратегия: "Seed dataset as code + assets"

**Идея**: после bootstrap в dev, curated dataset становится **версионированным
артефактом**. Два компонента:

1. **Structured data** → JSON файлы commited в git под `seed_data/curated/`
2. **Binary assets** → отдельный S3 bucket `menuassistant-curated-assets`
   (общий для всех environment'ов)
3. **Manifest** с версией + hash'ами для idempotency

При первом deploy prod окружения:
- Serverpod startup hook проверяет — пустая ли `curated_dish` table
- Если да — запускает `bin/import_curated_dataset.dart`
- Он читает JSON + конструирует URL'ы на основе current env config

### Структура seed_data/curated/

```
seed_data/curated/
├── VERSION                    # semver: "1.0.0"
├── manifest.json              # timestamp, hash всех JSON, image bundle hint
├── curated_dishes.json        # 5000 dishes (structured)
├── curated_dish_images.json   # image metadata с imageKey (not full URL)
└── dish_translations.json     # Sprint 5 translations (когда будут)
```

### Ключевой момент — `imageKey` вместо `imageUrl` в JSON

Полный URL зависит от environment (dev: `localhost:8080`, prod: `cdn.menuassistant.com`).
Чтобы тот же JSON работал везде, в seed файле хранится **только hash**
(content-addressable filename):

```json
{
  "canonicalDishName": "spaghetti carbonara",
  "imageKey": "a3f8b9c2d1e4f5a6.jpg",
  "source": "wikimedia",
  "license": "cc-by-4.0",
  "attribution": "Photo by X via Wikimedia Commons, CC BY 4.0",
  "attributionUrl": "https://commons.wikimedia.org/wiki/File:...",
  "qualityScore": 4,
  "isPrimary": true
}
```

В БД (`curated_dish_image.imageUrl`) уже сохраняется **resolved URL** для
current environment. Трансформация при импорте:

```
full_url = f"{CURATED_IMAGE_BASE_URL}/{imageKey}"
```

Где `CURATED_IMAGE_BASE_URL`:
- Dev: `http://localhost:8080/static/images/curated`
- Staging: `https://cdn-staging.menuassistant.com/curated`
- Prod: `https://cdn.menuassistant.com/curated`

### Binary assets — shared S3 bucket

Картинки слишком большие для git (5K × 100KB ≈ 500MB). Варианты:

| Вариант | Плюсы | Минусы |
|---|---|---|
| **Shared S3 bucket** (рекомендую) | Reproducible, работает везде одинаково, легко обновлять, dev тоже может подтягивать prod assets | Требует AWS account, $0.023/GB/mo (10MB*500MB = ~$0.01/mo) |
| Git LFS | В git pipeline | $5/mo за 50GB, fragile |
| GitHub Release tar.gz | Бесплатно | Ручное версионирование, медленное скачивание |

**Рекомендация**: создать bucket `menuassistant-curated-assets`, настроить
public read (т.к. это hotlink target для apps), rclone sync в bootstrap phase.

### Export script

**`bin/export_curated_dataset.dart`** — запускается в dev после bootstrap:

```
1. Читает из БД:
   - SELECT * FROM curated_dish WHERE status='approved'
   - SELECT * FROM curated_dish_image
   - SELECT * FROM dish_translation
2. Для каждого image row: извлекает hash из imageUrl → imageKey
   (всё что после последнего '/')
3. Пишет JSON файлы в seed_data/curated/
4. Обновляет manifest.json:
   {
     "version": "1.0.1",
     "exportedAt": "2026-04-15T12:00:00Z",
     "dishCount": 5247,
     "imageCount": 6103,
     "jsonHashes": {
       "curated_dishes.json": "sha256:...",
       "curated_dish_images.json": "sha256:..."
     }
   }
5. Опционально: rclone sync web/static/images/curated/ s3://menuassistant-curated-assets/
   (если настроены credentials)
```

### Import script

**`bin/import_curated_dataset.dart`** — запускается на каждом deploy (или
Serverpod startup hook):

```
1. Проверяет seed_data/curated/VERSION
2. Читает текущую версию из dataset_version table (new tiny table)
3. Если версии совпадают → skip (idempotent)
4. Читает JSON файлы
5. Резолвит CURATED_IMAGE_BASE_URL из current Serverpod config
6. Для каждого dish:
   - Upsert по canonical_name (insert if new, update if exists)
7. Для каждого image:
   - Конструирует full URL = {base}/{imageKey}
   - Upsert по (curatedDishId, imageKey) composite key
8. Для каждого translation:
   - Upsert по (dishCatalogId, language)
9. Записывает new version в dataset_version table
```

### Новая таблица `dataset_version`

```yaml
class: DatasetVersion
table: dataset_version
fields:
  name: String                  # "curated_dataset"
  version: String               # "1.0.1"
  appliedAt: DateTime
  dishCount: int
  imageCount: int
indexes:
  dataset_version_name_idx:
    fields: name
    unique: true
```

Упрощённый pattern для отслеживания "какая версия seed dataset уже применена".

### Serverpod startup hook

В `server.dart` после `pod.start()`:

```dart
// Auto-import curated dataset if present and not yet applied
await _tryImportCuratedSeed(pod);
```

Где `_tryImportCuratedSeed`:
1. Проверяет, существует ли `seed_data/curated/` в working directory
2. Если нет — log warning, skip (prod deployments могут не содержать seed)
3. Если да — запускает import скрипт через internal session
4. Log result

### Обновление dataset после first deploy

Добавил новые dishes в dev через admin UI:

```
1. dart run bin/export_curated_dataset.dart
   → обновляет seed_data/curated/*.json
   → bumps VERSION 1.0.1 → 1.0.2
   → rclone sync картинок в S3 bucket (новые хэши)

2. git add seed_data/curated/ && git commit && git push

3. На prod: deploy нового build (git pull + docker rebuild)
   → Serverpod startup hook видит новую версию → import diff
   → upsert по canonical_name обновляет изменённые rows
   → новые rows добавляются
```

**Важно**: import — это **upsert**, не truncate+insert. Существующие entries
обновляются по canonical_name (unique key). Ничего не теряется при обновлениях.

### Что **НЕ** мигрирует через seed

- `dish_catalog` (runtime, пополняется пользователями) — только структура, не данные
- `dish_provider_status` — runtime state, environment-specific
- `llm_usage` — environment-specific cost tracking
- `restaurant` / `menu_item` — user data, не переносится

Seed dataset migrates только **canonical knowledge** (curated dishes + их
images + translations), всё остальное — runtime data per environment.

---

## Controlled Vocabulary (Taxonomy)

Жёсткий словарь тегов — критично для consistency. Без него теги будут
"pasta"/"Pasta"/"pastas"/"паста" — поиск разваливается.

### Cuisines (ISO-style)

```
italian, french, spanish, portuguese, greek, mediterranean,
german, austrian, swiss, hungarian, polish, russian, ukrainian,
british, irish, american, mexican, brazilian, peruvian, argentinian,
japanese, korean, chinese, thai, vietnamese, indian, pakistani,
middle_eastern, lebanese, turkish, moroccan, ethiopian,
caribbean, cajun, southern_us, fusion, international
```

~40 значений. Хранятся в `cuisine` field как single string.

### Course types

```
appetizer, soup, salad, main, side, dessert,
breakfast, brunch, snack, drink, sauce, condiment
```

~12 значений. Single string в `courseType`.

### Cooking methods (теги)

```
grilled, fried, deep_fried, baked, roasted, steamed, boiled,
poached, braised, smoked, raw, marinated, pickled, fermented,
sous_vide, slow_cooked, stir_fried
```

~17 значений. Можно несколько на блюдо.

### Diet flags

```
vegetarian, vegan, pescatarian, gluten_free, dairy_free, nut_free,
egg_free, soy_free, sugar_free, low_carb, keto, paleo, halal, kosher
```

~14 значений. Дополнительные `contains_*` для аллергенов:

```
contains_gluten, contains_dairy, contains_eggs, contains_nuts,
contains_peanuts, contains_soy, contains_fish, contains_shellfish,
contains_pork, contains_alcohol
```

### Texture / Flavor descriptors

```
spicy, sweet, savory, sour, bitter, umami,
creamy, crunchy, crispy, soft, chewy, tender,
rich, light, refreshing, hearty, comfort_food
```

~17 значений. Для UI и фильтрации, не для search-критичной логики.

### Image style tags

```
# Composition
topdown, three_quarter, side, hero, closeup, wide

# Setting
plate, bowl, board, pan, raw_ingredients, plated, lifestyle

# Lighting
bright, dark, dramatic, natural, studio

# Background
white, wooden, stone, dark, fabric, marble, table
```

~30 значений. Для фильтрации в `curated_dish_image.styleTags` — позволит
"показывать разные ракурсы при повторных запросах одного блюда".

---

## Algorithm: dish lookup

При processing меню вызывается `CuratedDishService.findMatch(extractedName)`.
Алгоритм multi-pass с убывающей точностью:

### Pass 1: Exact canonical match (best)

```sql
SELECT * FROM curated_dish
WHERE canonicalName = $normalized
  AND status = 'approved'
LIMIT 1;
```

`$normalized` — `extractedName` приведённое через тот же normalize что
applies к `canonicalName` (lowercase, strip accents, strip punct, collapse
whitespace).

**Hit rate target**: 30-50% после полного импорта TheMealDB + Wikidata
+ накопленных пользовательских данных.

### Pass 2: Alias match

```sql
SELECT * FROM curated_dish
WHERE aliases::jsonb ?| ARRAY[$normalized, $normalized_lower_no_space]
  AND status = 'approved'
LIMIT 1;
```

Покрывает: иностранные названия (русское "Карбонара" → English entry),
spelling variants ("spagetti" vs "spaghetti").

**Hit rate**: +10-20%.

### Pass 3: Token overlap on tags + ingredients

```sql
SELECT cd.*,
  (cardinality(
    ARRAY(SELECT jsonb_array_elements_text(cd.tags::jsonb)
          INTERSECT
          SELECT unnest($input_tokens::text[]))
  ) * 2 +
   cardinality(
    ARRAY(SELECT jsonb_array_elements_text(cd."primaryIngredients"::jsonb)
          INTERSECT
          SELECT unnest($input_tokens::text[]))
  )) AS score
FROM curated_dish cd
WHERE (cd.tags::jsonb ?| $input_tokens
       OR cd."primaryIngredients"::jsonb ?| $input_tokens)
  AND cd.status = 'approved'
ORDER BY score DESC
LIMIT 5;
```

`$input_tokens` — токены имени блюда, `tags` weighted 2×.

**Hit rate**: +10-15%. Ловит "creamy bacon pasta" → spaghetti carbonara.

### Pass 4: pgvector embedding (опционально, дороже)

Если ничего не нашло на pass 1-3:
1. Embed `extractedName` через OpenAI `text-embedding-3-small` ($0.02/1M)
2. Cosine similarity к pre-computed embeddings всех `curated_dish.canonicalName + tags + description`
3. Top-1 если similarity > 0.78

**Hit rate**: catches semantic matches "thin Italian flatbread with toppings"
→ pizza. **Cost**: ~$0.0001 per dish, добавляет ~50ms latency.

Реализовать когда `pgvector` будет в Serverpod (или через raw SQL extension).

### Pass 5: No match — fallback to existing pipeline

Если ничего не нашли в `curated_dish` — идём по старому пути:
- Wikidata description → Unsplash API → Pexels → fal.ai
- Создаётся `dish_catalog` запись с `curatedDishId = null`
- Эта запись попадает в "candidates pool" для админ-ревью

---

## Workflow для наполнения

### Phase 1: Bootstrap (1 неделя работы)

1. **Импортировать TheMealDB** — `bin/import_themealdb.dart`:
   - GET все категории, для каждой — все dishes, для каждой — детали
   - Map в CuratedDish + CuratedDishImage с `status='approved'`
   - Ожидаемо: ~300 dishes
   - Стоимость: $25 one-time donation за commercial-OK key

2. **Импортировать Wikidata SPARQL** — `bin/import_wikidata_dishes.dart`:
   - SPARQL query → 5000 dish Q-ids
   - Multilingual labels → aliases (matched against existing TheMealDB entries)
   - Country/cuisine fields
   - Wikimedia images где есть, с CC license
   - Новые dishes сохраняются как `status='draft'`

3. **Manual review** — простой admin UI:
   - Список `status='draft'` сортированный по completeness (есть image, есть description, есть aliases)
   - Approve / reject / edit
   - Bulk approve для high-quality candidates

### Phase 2: Live enrichment (continuous)

При каждом upload меню:
1. Если `curated_dish` найден → используем
2. Если нет → `dish_catalog` создаётся как обычно, плюс попадает в
   "candidates pool" с counter `seen_count`
3. Когда `seen_count > N` (например, 5) — попадает в priority queue для
   ручного добавления в curated

### Phase 3: Spoonacular enrichment (опционально)

После bootstrap, batch-вызов Spoonacular для каждой curated dish:
- Найти соответствующий recipe в Spoonacular по name match
- Подтянуть полные ингредиенты + nutrition + allergens
- Обновить `curated_dish.dietFlags`, дополнить `primaryIngredients`

Стоимость: ~$29/мес для 1500 запросов в день — хватит на 50K dishes/месяц.

### Phase 4: User-contributed images (опционально, требует auth)

Дать аутентифицированным пользователям загружать свои фото dishes. Пайплайн:
- Upload → ImageService → CuratedDishImage с `source='user_uploaded'`,
  `status='pending_review'`
- Админ approve/reject в админке
- Approved photos получают `qualityScore` от админа
- Score < 3 не показываются как primary

---

## Quality criteria для labeling

Без чётких критериев волонтёры/админы будут размечать по-разному. Это
guidelines что должен делать reviewer.

### Для CuratedDish

**MUST**:
- `canonicalName` lowercased + accent-stripped + не пустое
- `displayName` правильно capitalized в native language
- `cuisine` из controlled vocabulary
- `courseType` из controlled vocabulary
- Хотя бы 1 alias (canonicalName сам)
- Хотя бы 3 primary ingredients
- `description` 1-3 sentences, factual, no marketing fluff
- Хотя бы 1 approved image

**SHOULD**:
- `wikidataId` если можно найти соответствие
- 5+ aliases including major translations (en, ru, es, fr, ...)
- 3-7 tags from controlled vocabulary
- `dietFlags` с auto-inferred contains_* tags

**MUST NOT**:
- Marketing language ("delicious", "mouth-watering")
- Subjective opinions ("the best version")
- Brand names в названии (если только это не genuinely brand-defined dish)
- HTML / markdown в description

### Для CuratedDishImage

**Quality grade rubric** (для `qualityScore`):

**5 — Hero shot**:
- Профессиональное освещение
- Блюдо в фокусе, минимум backgroundnoise
- Хорошая композиция, appetizing
- Min 800×800, sharp focus
- Не имеет watermarks, текста, людей
- Можно использовать как primary image

**4 — Professional**:
- Profession photo но с context (стол, рука, sous chef в фоне)
- Min 600×600
- Без watermarks
- Подходит как secondary image

**3 — Good amateur**:
- Хороший phone photo, recognizable dish
- Адекватное освещение
- Min 400×400
- Может быть primary если 4-5 нет

**2 — Acceptable**:
- Recognizable, но low contrast / busy / dark
- Использовать только если ничего лучше нет

**1 — Bottom barrel**:
- Едва recognizable
- Не показывать в production, держать только для fallback

**Reject criteria** (image не сохраняется вообще):
- Не показывает блюдо (ингредиенты raw, упаковка, пустая тарелка)
- Содержит людей в кадре крупным планом
- Watermark / copyright text
- Resolution < 300×300
- Aspect ratio outside 0.5–2.0
- Очевидно AI-generated artifacts (если source != fal_ai_generated)

### Для CuratedDishImage.styleTags

Тегировать одним значением из каждой группы (composition, setting, lighting,
background) — не больше. Это для variety rotation, не для search.

---

## Technical implementation outline

### Файлы которые нужно создать (Sprint 4.5)

```
MenuAssistant/menu_assistant_server/
├── lib/src/models/
│   ├── curated_dish.spy.yaml                    # NEW
│   └── curated_dish_image.spy.yaml              # NEW
├── lib/src/services/curated/
│   ├── curated_dish_service.dart                # NEW — multi-pass lookup
│   └── taxonomy.dart                            # NEW — controlled vocab constants
├── lib/src/services/image_search/
│   └── curated_image_search_service.dart        # NEW — implements ImageSearchService
├── lib/src/endpoints/
│   └── admin_endpoint.dart                      # NEW — admin curation API
├── bin/
│   ├── import_themealdb.dart                    # NEW — TheMealDB importer
│   └── import_wikidata_dishes.dart              # NEW — SPARQL importer
└── lib/src/services/enrichment/
    └── dish_catalog_service.dart                # MODIFY — try curated lookup first
```

### Wire-up в server.dart

```dart
// Image providers chain:
// 1. CuratedImageSearchService — НАШ датасет (instant, high precision)
// 2. Unsplash API
// 3. Pexels API
// 4. fal.ai
final imageProviders = <ImageSearchService>[
  CuratedImageSearchService(),  // ← новый, первым
];
// + остальные API providers как сейчас
```

### Endpoint API для админки

```dart
class AdminEndpoint extends Endpoint {
  @override bool get requireLogin => true;

  // List candidates for curation (sorted by frequency)
  Future<List<DishCandidate>> listCandidates({int limit = 50});

  // Approve / create curated dish
  Future<CuratedDish> createCuratedDish(CuratedDish dish);
  Future<CuratedDish> updateCuratedDish(CuratedDish dish);
  Future<void> approveCuratedDish(int curatedDishId);

  // Image management
  Future<CuratedDishImage> addImage(int curatedDishId, CuratedDishImage img);
  Future<void> setQualityScore(int imageId, int score);
  Future<void> deleteImage(int imageId);

  // Bulk operations
  Future<void> backfillExistingDishCatalog(int curatedDishId, String normalizedName);
}
```

### Admin UI options

**Option A: Built into Flutter app** — admin tab visible only to users with
specific role. Pros: одна кодбейс. Cons: смешивает customer и admin UI.

**Option B: Отдельный admin web app** — простой Flutter web build, отдельная
маршрутизация. Pros: cleanly separated. Cons: больше работы.

**Option C: Внешний tool** — pgAdmin / Retool / Forest Admin direct connection
to DB. Pros: ноль кода. Cons: нет business logic validation.

**Рекомендация**: Option A для MVP (одна вкладка "Curation" видимая только
если `user.role == 'admin'`), Option B позже когда вырастет.

---

## Стоимость и сроки

### Sprint 4.5 — Bootstrap + базовая инфраструктура (~1-2 недели)

| Работа | Время | Cost |
|---|---|---|
| Модели + миграции | 0.5 дня | $0 |
| `CuratedDishService` + multi-pass lookup | 1 день | $0 |
| `CuratedImageSearchService` + wire-up | 0.5 дня | $0 |
| `import_themealdb.dart` + run | 0.5 дня | $25 (TheMealDB key) |
| `import_wikidata_dishes.dart` + run | 1 день | $0 |
| Admin endpoint API | 1 день | $0 |
| Manual review of bootstrap data | 2 дня | время |
| Backfill linking dish_catalog → curated_dish | 0.5 дня | $0 |

**Итого**: ~7-8 рабочих дней, $25.

### Sprint 4.6 — Admin UI + ongoing curation (~1 неделя)

| Работа | Время | Cost |
|---|---|---|
| Admin tab в Flutter | 2 дня | $0 |
| Candidates queue UI | 1 день | $0 |
| Image upload + quality grading UI | 2 дня | $0 |

### Sprint 4.7 — Spoonacular enrichment (опционально, ~0.5 недели)

| Работа | Время | Cost |
|---|---|---|
| `SpoonacularService` HTTP client | 0.5 дня | $0 |
| Batch enrichment script | 0.5 дня | $29/мес |
| Manual reconciliation для конфликтов | 1-2 дня | время |

### Sprint 4.8 — pgvector semantic search (опционально, ~1 неделя)

| Работа | Время | Cost |
|---|---|---|
| Embedding generation для всех curated dishes | 0.5 дня | ~$1 one-time (text-embedding-3-small) |
| Embedding column + index в Postgres | 0.5 дня | $0 |
| Pass 4 в `findMatch` algorithm | 1 день | ~$0.0001/lookup |

---

## Метрики успеха

После Sprint 4.5 ожидаем:

1. **Hit rate `curated_dish` lookup**: ≥ 30% сразу после bootstrap
2. **Hit rate после Phase 2** (через месяц active curation): ≥ 60%
3. **Image quality**: 100% photos `qualityScore >= 3`, 80% `>= 4`
4. **Latency**: p99 < 30ms для curated lookup (vs 200-500ms для Unsplash API)
5. **Stoимостьr Claude calls** не растёт (curated не делает LLM запросов)

Метрики отслеживаются через дополнения к `dish_provider_status`:
- Новый provider value `curated` для счётчика hits
- Запросы из [METRICS.md](MenuAssistant/menu_assistant_server/METRICS.md)
  будут показывать соотношение `curated` vs `unsplash` vs `fal_ai`

---

## Open questions

Перед началом implementation спросить себя:

1. **Languages для aliases** — какие первые? Predлагаю: `en` (default), `ru`,
   `pt`, `es`, `it`, `fr`, `de`. Это покрывает европейские путешествия.
   Японский/китайский/корейский — позже.

2. **Кто делает curation** — только ты? Или нужен role-based access для
   многопользовательской админки? Для MVP — только ты, потом расширим.

3. **Где хранить bootstrap fixtures** — JSON/YAML файлы в репо `seed_data/`,
   или сразу в БД? Рекомендую JSON в репо для reproducibility — можно
   re-import после wipe.

4. **Тематика фокуса** — европейская/азиатская/латиноамериканская кухня?
   Все сразу размытно. Лучше начать с одной cuisine (например, italian +
   portuguese для текущего тестового кейса с португальскими меню в Лиссабоне).

5. **Reuse существующей инфраструктуры** — `ImagePersistenceService` уже
   может загружать в S3 (когда заработает в Sprint 6). User-uploaded images
   и self-hosted curated images пойдут через тот же сервис.

---

## Что прочитать прежде чем начинать

- [TheMealDB API docs](https://www.themealdb.com/api.php) — endpoints, лицензия
- [Wikidata SPARQL tutorial](https://www.wikidata.org/wiki/Wikidata:SPARQL_tutorial) — синтаксис запросов
- [Wikimedia Commons API](https://commons.wikimedia.org/wiki/Commons:API) — для скачивания фото
- [Open Food Facts data export](https://world.openfoodfacts.org/data) — если решим расширять на packaged products

После прочтения и согласования open questions — можем начинать **Sprint 4.5
Bootstrap**. Я могу написать importers и базовую CuratedDishService за
один заход.
