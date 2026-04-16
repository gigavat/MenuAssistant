# MenuAssistant Roadmap

Что сделано, что осталось, и что отложено. Актуально на 2026-04-13.

Полная версия исходного плана с архитектурными решениями хранится в
`~/.claude/plans/stateful-sniffing-cocke.md` (approved plan). Этот документ —
executive summary для трекинга прогресса.

---

## Стек

| Сервис | Язык | БД | Статус |
|---|---|---|---|
| Flutter клиент | Dart | — | Sprint 1–2 ✅ |
| Serverpod backend | Dart | PostgreSQL + Redis | Sprint 3–4 ✅ |
| ImageService | .NET 10 | PostgreSQL + S3 | Sprint 1 ✅, интеграция pending |
| PaymentService | .NET 10 | PostgreSQL | Не начат |

Монорепо: `MenuAssistant/` + `ImageService/` + (будущий) `PaymentService/`.

---

## ✅ Sprint 1 — Критичные исправления (done)

- `.env` для docker-compose, `.env.example` в git
- `assets/config.json` читается из `main.dart`
- `shared_preferences` для Flutter settings (тема, язык, валюта)
- ImageService: правильный порядок delete (DB → S3)
- ImageService: 10 MB limit + MIME whitelist
- ImageService: EF Core migrations вместо EnsureCreated
- ImageService: real health checks (Npgsql + S3HealthCheck)
- `maxRequestSize: 10485760` во всех Serverpod configs
- Fix 413 при загрузке меню

## ✅ Sprint 2 — DI + качество (done)

- **GetIt** для Flutter DI вместо глобальных `client` / `appState`
- `lib/core/service_locator.dart` регистрирует Client + AppState + RestaurantRepository
- **RestaurantRepository** — абстракция над `client.restaurant.*` и `client.aiProcessing.*`
- Все screens переведены на `getIt<>()` — ни один не импортирует `main.dart`
- Error handling: `appState.loadError` + SnackBar в HomeScreen
- Force-unwrap `!` на nullable ID заменены на `if (id != null)` guards
- `flutter analyze` — 0 warnings

## ✅ Sprint 3 — AI + Dish Catalog (done)

### Модели
- `dish_catalog` — общий реестр блюд (normalized_name unique)
- `dish_image` — фото блюд с атрибуцией + `lastCheckedAt` для health check
- `dish_provider_status` — состояние enrichment по каждому провайдеру
- `menu_item.dishCatalogId` — связь menu item ↔ catalog
- `llm_usage` — token accounting для всех Claude вызовов

### Сервисы
- `ClaudeLlmService` — прямой HTTP к Anthropic Messages API (Haiku 4.5, vision)
- `MockLlmService` — offline fallback
- `UnsplashImageSearchService` — hotlink + download notification
- `PexelsImageSearchService` — hotlink
- `FalAiImageService` — stub с `producesEphemeralUrls: true`
- `WikidataService` — бесплатный источник описаний
- `DishCatalogService` — find-or-create + sync enrichment + backoff
- `ImageServicePersistence` — stub для fal.ai → ImageService upload
- `ImagePersistenceService` interface

### Future calls
- `EnrichmentWorkerFutureCall` — каждые 5 минут обрабатывает pending/rate_limited провайдеры
- `ImageHealthCheckFutureCall` — раз в сутки HEAD-пингует `dish_image` URL

### Endpoint
- `AiProcessingEndpoint.processMenuUpload` переписан:
  - LLM → persist restaurant + membership
  - `llm_usage` записывается через `recordLlmUsage()` helper
  - Для каждого блюда: `DishCatalogService.findOrCreate` → `menu_item.dishCatalogId` + primary image URL
  - Fallback описания из каталога если в меню пусто
- Fix: `session.authenticated!.userIdentifier` вместо `authId` (восстановление персистентности пользовательских данных)

## ⛔ Sprint 4 — Локальный Unsplash dataset (отменён)

**Статус: инфраструктура удалена, заменено custom dataset подходом (см. DATASET_DESIGN.md).**

### Что было сделано и почему отменено

Реализована полная инфраструктура (модель, импортёр, сервис, миграции). После
импорта 3156 food-photos из Unsplash Lite выяснилось, что dataset **не
подходит** для dish-level matching:

- Keywords только scene-level (`food`/`fruit`/`vegetable`/`meal`), нет
  специфичных названий блюд (`carbonara`, `margherita`)
- Descriptions — AI captions сцены, не блюд (`"white ceramic teacup with coffee"` для всех coffee mug фото)
- Coverage в descriptions: **0** matches для `pasta`, `burger`, `salad`;
  только 12 для `coffee`, 4 для `cake`
- Все 73 тестовых вызова `unsplash_local` упали со статусом `failed: no results`

**Корневая проблема**: Unsplash Lite — это photography license dataset, а не
food dataset. AI labeling scene-level, а не dish-level. Архитектурное
несоответствие, не баг.

### Что удалено (миграция 20260414072454496)

- `unsplash_local_photo` table — DROP
- `lib/src/models/unsplash_local_photo.spy.yaml`
- `lib/src/services/image_search/local_unsplash_image_search_service.dart`
- `bin/import_unsplash_dataset.dart`
- LocalUnsplash из `imageProviders` цепочки в `server.dart`

### Что осталось как урок

- Lessons learned записаны в `gotchas_lessons_learned.md` (memory)
- Текущая цепочка: `Unsplash API → Pexels → fal.ai`
- Замена — **собственный curated dish dataset** в Sprint 4.5 (см. ниже + `DATASET_DESIGN.md`)

## ⏳ Sprint 4.5 — Curated dish dataset (bootstrap legally)

> **Цель**: ~5000 dishes с описаниями на 7 языках + сгенерированными фото,
> всё **owned by us**, полностью commercial-legal. Заменяет неудачный
> Unsplash Lite подход. Подробный дизайн — `DATASET_DESIGN.md`.

### Критические legal constraints (НЕ нарушать)

- **НЕ скрапить** TheMealDB / Wikipedia / recipe blogs — ToS violations + EU database rights
- **НЕ использовать img2img** / photoshop фильтры на чужих фото — это **derivative work**, не отмывает copyright, создаёт цифровой след инфраженмента (fal.ai logs могут быть запрошены court order)
- **НЕ копировать описания** из TheMealDB/Wikipedia даже через перевод — translations это derivative works под тем же copyright
- **НЕ использовать** Recipe1M+, Food-101 — research-only лицензии

### Что МОЖНО (и формирует бутстрап-стратегию)

- ✅ **Wikidata SPARQL** — CC0 facts (dish name, country, cuisine, ingredients, Q-ids), multilingual labels 50+ языков. Полностью free commercial use
- ✅ **TheMealDB API с $25 supporter key** — explicit commercial rights. Бери только **facts** (name, region, category, ingredient list), **НЕ** descriptions, **НЕ** instructions, **НЕ** images
- ✅ **Claude-generated descriptions** — per [Anthropic Commercial Terms](https://www.anthropic.com/legal/commercial-terms) output принадлежит тебе
- ✅ **Claude translations твоих же descriptions** — translation of your own work = your own work
- ✅ **fal.ai Flux text-to-image** (НЕ img2img) — per fal.ai ToS output принадлежит тебе, commercial OK. Prompt describes dish, no input photo → output 100% original
- ✅ **User-uploaded photos** через explicit license grant в приложения ToS (паттерн Yelp/Foursquare)

### Bootstrap Sprint 4.5 — 5 скриптов

Каждый скрипт идемпотентный, пишет прогресс в БД, поддерживает resume.
Расположение — `MenuAssistant/menu_assistant_server/bin/`.

#### 1. `import_wikidata_dishes.dart`

SPARQL query к `query.wikidata.org` → ~5000 dish entities.

Pull:
- Dish entity Q-id → `curated_dish.wikidataId`
- English label → `displayName`
- Normalized form → `canonicalName`
- Multilingual labels (en, ru, pt, es, it, fr, de) → `aliases`
- Country (P495) → `countryCode`
- Cuisine (P2012) → `cuisine`
- Ingredient statements (P527) → `primaryIngredients`
- **НЕ брать** P18 (images) — лицензии смешанные, делаем свои через fal.ai

Query template — в `DATASET_DESIGN.md` секция "Источники данных → Wikidata SPARQL".

Save with `status='draft'`. Manual review через admin UI (Sprint 4.6) переведёт часть в `approved`.

**Стоимость**: $0. **Время**: ~30 минут query + bulk insert.

#### 2. `import_themealdb.dart`

TheMealDB API с paid supporter key (требуется **ДО запуска**: купить у [themealdb.com/api.php](https://www.themealdb.com/api.php) за $25).

Pull:
- Для каждой категории: list all dishes
- Для каждого dish: `strMeal`, `strArea`, `strCategory`, `strIngredient1..20`
- **НЕ брать** `strInstructions`, `strMeal` description, `strMealThumb` — это чужой copyright
- Enrich существующие `curated_dish` записи (matched через canonicalName) — дополнить `primaryIngredients`, уточнить `cuisine`/`courseType`
- Create new только если нет match в Wikidata

**Стоимость**: $25 one-time. **Время**: ~15 минут (300 dishes).

#### 3. `generate_descriptions.dart`

Claude Haiku 4.5 batch calls для всех `curated_dish` где `description IS NULL`.

Prompt template:
```
Write a factual 2-sentence description of {dishName}, a dish from {cuisine}.
Include: main preparation method, key ingredients ({ingredients}),
typical serving context. No marketing language, no first-person, no opinions.
Output only the two sentences in English.
```

Через `recordLlmUsage()` логируется cost в `llm_usage` с `operation='curated_dish_description'`.

**Стоимость**: ~$0.0003/dish × 5000 = **~$1.50**. **Время**: ~20 минут с batching.

#### 4. `generate_translations.dart`

Для каждого `curated_dish` с `description != null` — batch Claude calls для перевода на 6 языков (ru, pt, es, it, fr, de).

Пишет в новую таблицу `dish_translation` (спроектирована в Sprint 5 плане —
можно создать модель сейчас, она пригодится в обоих спринтах):

```yaml
class: DishTranslation
table: dish_translation
fields:
  curatedDish: CuratedDish?, relation
  language: String              # ISO 639-1
  name: String                  # переведённое display name
  description: String
  source: String                # "claude_auto"
  createdAt: DateTime
```

Batch по 20 dishes × 6 languages в одном Claude call (один call → 120 переводов).
Cost через `llm_usage` с `operation='dish_translation'`.

**Стоимость**: ~$0.007/dish × 5000 = **~$35**. **Время**: ~1 час с rate limit management.

#### 5. `generate_images.dart`

**Двухфазная стратегия**: сначала пробуем Wikimedia Commons (бесплатно, "настоящие" фото для популярных блюд), затем fallback на **InferenceService** (self-hosted SDXL/Flux) для остальных. Обе фазы сохраняют файлы через `LocalFileImagePersistence` (dev) или `ImageServicePersistence` (prod, Sprint 6) — реализация выбирается автоматически по runMode.

**Фаза 1 — Wikimedia Commons lookup** для всех `curated_dish` с `wikidataId`:

1. Через Wikidata SPARQL query property `P18` (image) для конкретного `wikidataId` → URL файла в Commons
2. Если P18 нет — search в Commons API по `displayName` (до 10 результатов)
3. Для каждого кандидата — imageinfo API с `extmetadata` → проверить `LicenseShortName`
4. **Фильтр**: только `PD-*`, `CC0`, `CC BY 2.0/3.0/4.0`. Отбрасываем `CC BY-SA`, `CC BY-NC`, `GFDL`, `fair use`
5. Quality filter: min 400×400, aspect ratio 0.5-2.0
6. Первый подходящий — **скачиваем bytes**, передаём в `imagePersistence.persistBytes(...)` → получаем local URL (dev) или S3 URL (prod)
7. Сохраняем с `source='wikimedia'`, `license={actual_license}`, `attribution='Photo by {Artist} via Wikimedia Commons, {License}'`, `attributionUrl={file_page_url}`

**Coverage estimate**: 30-50% для популярных блюд (pizza, carbonara, sushi), 5-10% для экзотики.

**Фаза 2 — InferenceService fallback** для dishes без Commons hit:

Перед запуском sanity check:
```dart
if (!await inferenceClient.isHealthy()) {
  stderr.writeln('InferenceService not reachable — abort');
  exit(1);
}
```

Prompt template:
```
Professional food photography of {displayName}, {cuisine} cuisine,
featuring {primary_ingredients}, plated on white ceramic,
soft natural lighting, top-down or three-quarter angle,
shallow depth of field, appetizing, studio quality, no people, no text
```

Negative prompt:
```
blurry, low quality, cartoon, drawing, text, watermark, people, hands, raw ingredients
```

- Вызываем `InferenceServiceClient.generateImage(prompt, ...)` — получаем raw JPEG bytes
- 2 attempts per dish (разные seeds) — выбираем лучший вручную или через CLIP scorer
- **Передаём bytes** в `imagePersistence.persistBytes(...)` → получаем local URL
- Результат: `source='inference_service'`, `license='owned'`, `qualityScore=3` (default)

**Стоимость**:
- Wikimedia Commons: ~1500 images × $0 = **$0**
- InferenceService self-hosted: ~3500 × 2 attempts × €0 marginal = **~€1** (electricity)
- **Total: ~€1** (экономия ~$55 vs fal.ai approach)

Плюс control over generation: можно менять prompts, модели, steps, seeds без rate limits или API versioning concerns.

**Время**:
- Commons phase: ~1 час
- InferenceService SDXL phase: ~7 часов (5 sec/image × 3500 × 2 attempts / 3600)
- Всего ~8 часов, unattended overnight run

**Fallback на cloud API**: если InferenceService недоступен, можно временно переключиться на fal.ai/BFL через env flag. Оставить `FalAiImageService` как backup provider.

#### 6. Infrastructure: LocalFileImagePersistence + InferenceServiceClient

Два новых класса, необходимых **до** запуска `generate_images.dart`.

##### 6a. `lib/src/services/image_persistence/local_file_image_persistence.dart`

Новая реализация `ImagePersistenceService` interface, сохраняющая файлы
в `web/static/images/curated/` с content-addressable naming (sha256 hash →
filename). Serverpod автоматически hoster файлы через существующий
`StaticRoute.directory('web/static')`, так что URL становится
`http://localhost:8080/static/images/curated/<hash>.<ext>` без дополнительного
endpoint'а.

**Важно**: добавить метод `persistBytes(bytes, contentType, source, dishCatalogId)`
в дополнение к существующему `persist(sourceUrl, ...)`. Bytes-based нужен для
InferenceService (который возвращает bytes напрямую, без intermediate URL).

Wire-up в `server.dart` — выбор реализации по runMode: development →
`LocalFileImagePersistence`, staging/prod → `ImageServicePersistence` (.NET S3).

Добавить в `.gitignore`: `web/static/images/curated/` (чтобы dev картинки не попали в git).

Подробный дизайн + код — `DATASET_DESIGN.md` секция "Local dev image storage".

##### 6b. `lib/src/services/inference/inference_service_client.dart`

HTTP клиент для self-hosted InferenceService (Python FastAPI с SDXL на
remote GPU машине). Тонкая обёртка над `http.Client`:
- `POST /generate/image` с Bearer auth → возвращает `List<int>` bytes
- `GET /health` → bool reachability check
- Timeout 3 минуты (SDXL inference может быть медленным)

Конфигурация через `config/passwords.yaml`:
```yaml
inferenceServiceBaseUrl: 'http://localhost:8000'
inferenceServiceSecret: '<32-char hex>'
```

Интегрируется в `ServiceRegistry` наряду с существующими сервисами. Используется
из `bin/generate_images.dart` и (опционально, Sprint 5+) из live request path
для fallback generation.

Подробный дизайн API + code sample — `DATASET_DESIGN.md` секция "InferenceService".

**Стоимость**: $0. **Время**: ~2 часа оба класса + тесты.

**Pre-requisite**: InferenceService должен быть **задеплоен** на remote GPU
машину **до** этой работы — см. `InferenceService/README.md`.

#### 7. `export_curated_dataset.dart` + `import_curated_dataset.dart`

**Миграционная инфраструктура** для переноса curated dataset из dev в prod
без потерь. Обязательно перед first prod deploy.

**Export** (запускается в dev после bootstrap):
- Читает `curated_dish`, `curated_dish_image`, `dish_translation` из БД
- Пишет JSON файлы в `seed_data/curated/` (commited в git)
- Image URLs трансформируются в `imageKey` (content hash only, без env-specific prefix)
- Обновляет `manifest.json` с новой версией + timestamp + row counts
- Опционально: rclone sync `web/static/images/curated/` → S3 bucket `menuassistant-curated-assets`

**Import** (запускается на каждом deploy или Serverpod startup hook):
- Читает `seed_data/curated/VERSION`
- Проверяет `dataset_version` table — если уже применено, skip (idempotent)
- Upsert rows по canonical_name (для dishes) / (dishId, imageKey) composite key (для images)
- Резолвит полные URL из `CURATED_IMAGE_BASE_URL` current environment'а
- Записывает новую версию в `dataset_version`

**Новая таблица** `dataset_version` (для idempotency tracking):
```yaml
class: DatasetVersion
table: dataset_version
fields:
  name: String            # "curated_dataset"
  version: String         # "1.0.0"
  appliedAt: DateTime
  dishCount: int
  imageCount: int
indexes:
  dataset_version_name_idx:
    fields: name
    unique: true
```

Подробный дизайн + структура JSON файлов — `DATASET_DESIGN.md` секция
"Environment migration — seed dataset pattern".

**Стоимость**: $0 (no API calls) + опционально S3 storage ~$0.01/мес за 500MB
**Время**: ~3 часа написание обоих скриптов + тесты

### Сводная таблица cost bootstrap

| Item | Cost |
|---|---|
| Wikidata SPARQL import | $0 |
| TheMealDB supporter key (one-time) | $25 |
| Wikimedia Commons images (no API key) | $0 |
| USDA FoodData Central (опционально, Sprint 5+) | $0 |
| Claude descriptions (5000 dishes) | ~$1.50 |
| Claude translations (×6 languages) | ~$21 |
| InferenceService electricity (~8 hours generation) | ~€1 |
| **Total bootstrap cash cost** | **~$48** |
| | |
| ~~Spoonacular subscription~~ | **НЕ используем** (termination risk) |
| ~~fal.ai / BFL image generation~~ | **Заменён InferenceService** (экономия ~$55) |
| S3 bucket curated-assets (после first deploy) | ~$0.01/мес |
| Per new exotic dish (live fallback via InferenceService) | ~€0.0001 electricity |

**One-time setup time cost** (не в $):
- TheMealDB key registration: 5 мин
- InferenceService deployment (Docker + SDXL): ~3-4 часа
- Python environment + SDXL model download (~7GB): 30 мин
- Network setup (Tailscale / SSH tunnel): 30 мин
- Test generation quality on 10 sample dishes: 30 мин
- Total one-time: **~5 часов** работы

После setup — **нулевая marginal cost** на image generation, полный control,
нет rate limits, нет зависимости от сторонних API.

### Pre-требования перед запуском Sprint 4.5

1. **TheMealDB supporter key** — купить за $25 на themealdb.com. Положить в `config/passwords.yaml` как `theMealDbApiKey`.

2. **Увеличить `anthropicApiKey` кредиты** — для bootstrap нужно ~$25 на Claude (descriptions + translations). Текущий ключ должен иметь баланс или auto-refill.

3. **Deploy InferenceService на remote GPU машину** — заменяет fal.ai/BFL для image generation. Self-hosted Python FastAPI с SDXL (позже Flux Schnell NF4). Подробный дизайн — `DATASET_DESIGN.md` секция "InferenceService". Стек:
   - Remote машина: Ryzen 5950x + RTX 3080 Ti 12GB + 64GB RAM
   - Docker + NVIDIA Container Toolkit ИЛИ Python 3.11 + systemd
   - SSH tunnel / Tailscale / LAN — network connectivity к Serverpod dev laptop
   - Setup time: ~3-4 часа one-time
   - После setup: zero API cost per image, только electricity (~€1 на весь bootstrap)

   **Deployment checklist** — см. `DATASET_DESIGN.md` секция "Чек-лист перед запуском Sprint 4.5 bootstrap"

   **Конфигурация в Serverpod** `config/passwords.yaml`:
   ```yaml
   shared:
     inferenceServiceBaseUrl: 'http://localhost:8000'    # через SSH tunnel
     inferenceServiceSecret: '<openssl rand -hex 32>'
   ```

4. ~~Купить fal.ai credits~~ — **больше не требуется**. InferenceService заменяет cloud generation. Fal.ai / BFL оставить как опциональный fallback если InferenceService недоступен (один env flag).

4. **Decision: `dish_translation` модель** — создавать сейчас (Sprint 4.5) или ждать Sprint 5 (локализация). Рекомендую создать в Sprint 4.5, тогда Sprint 5 построит на готовой инфраструктуре.

5. **Decision: focus cuisines** — bootstrap все cuisines сразу (~5000 dishes, $142), или начать с italian + portuguese (меньше, дешевле, тестируется быстрее)? Для MVP Лиссабон-кейса достаточно italian + portuguese + spanish + french (~1500 dishes, ~$45).

### Sprint 4.6 — Admin UI для curation (после Sprint 4.5)

После bootstrap понадобится простой admin интерфейс:
- Список candidates (dish_catalog entries с `curatedDishId=NULL`, sorted by frequency)
- CRUD для curated_dish и curated_dish_image
- Manual quality grading для images (rubric 1-5 из DATASET_DESIGN.md)
- Bulk approve / reject draft entries из Wikidata import

Реализация — отдельная вкладка в Flutter app с role-based access (только `user.role == 'admin'`). Детали в DATASET_DESIGN.md секция "Admin UI options".

### Критерии готовности Sprint 4.5

- `curated_dish` заполнена ~5000 entries (или меньше если focus cuisines)
- Все entries имеют `description` на английском
- Переводы на 6 языков в `dish_translation`
- Хотя бы 1 image per dish в `curated_dish_image`, все `source='fal_ai_generated'` с `license='owned'`
- `CuratedDishService.findMatch(dishName)` работает с multi-pass lookup (canonical → alias → token overlap)
- `DishCatalogService.findOrCreate` проверяет `curated_dish` первым, hit rate ≥ 30% на тестовых меню
- Все costs записаны в `llm_usage` с соответствующими operation tags
- `dart analyze` — 0 errors

## Бонус-работа (вне спринтов)

- **METRICS.md** — SQL-запросы для observability
- **API_KEYS.md** — инструкции по получению всех ключей
- **`llm_usage` таблица** + `recordLlmUsage()` helper — cost tracking всех Claude вызовов (menu_extraction + dish_description)
- **Hotlinking compliance** — ToS Unsplash/Pexels соблюдаем, Unsplash download notification fires
- **ImageHealthCheckFutureCall** — auto-recovery broken image links
- **FutureCall zero-arg refactor** — совместимость с auto-discovered dispatcher Serverpod 3.4
- `passwords.yaml` в `.gitignore`

---

## ⏳ Sprint 5 — Локализация меню (i18n + currency)

> **Цель**: турист в Лиссабоне фоткает меню на португальском, в приложении
> видит русские названия и цены в рублях по текущему курсу.

### 5.1 Двухуровневая модель имён в Dish Catalog

Расширить `dish_catalog.spy.yaml`:
```yaml
fields:
  normalizedName: String          # ключ дедупликации
  canonicalNameEn: String         # стабильное английское (для FTS, docs)
  canonicalNameOriginal: String   # как было в оригинальном меню
  originalLanguage: String        # ISO 639-1 (pt, ru, en, ...)
  ...
```

Новая таблица переводов:
```yaml
class: DishTranslation
table: dish_translation
fields:
  dishCatalog: DishCatalog?, relation
  language: String               # ISO 639-1
  name: String                   # переведённое название
  description: String?
  source: String                 # llm | manual | auto
  createdAt: DateTime
indexes:
  dish_translation_lookup_idx:
    fields: dishCatalogId, language
    unique: true
```

### 5.2 Claude extraction → English-first

Переписать промпт `ClaudeLlmService._menuExtractionSystemPrompt`, чтобы
для каждого блюда возвращал:
- `name_original` — как написано в меню
- `name_en` — нормализованное английское
- `description_original` / `description_en`
- На уровне меню: `language_detected`, `currency_detected`

### 5.3 Translation worker (lazy on-demand)

`DishTranslationService`:
- При запросе меню в языке X проверяет `dish_translation` для каждого блюда
- Если перевода нет → добавляет в новый `dish_translation_status` (аналог `dish_provider_status`)
- Возвращает английское имя как fallback
- `TranslationWorkerFutureCall` батчит 50 блюд за один Claude вызов
- `recordLlmUsage(session, usage, 'dish_translation')` — всё уже готово из Sprint 3 бонуса

### 5.4 Currency conversion

Новый сервис `CurrencyService` + таблица:
```yaml
class: CurrencyRate
table: currency_rate
fields:
  baseCode: String      # ISO 4217 (EUR)
  quoteCode: String     # ISO 4217 (RUB)
  rate: double
  fetchedAt: DateTime
indexes:
  currency_rate_pair_idx:
    fields: baseCode, quoteCode
    unique: true
```

- Источник: [exchangerate.host](https://exchangerate.host/) (free, no key)
- `CurrencyRateUpdateFutureCall` — раз в час обновляет курсы
- Цены **хранятся в исходной валюте** в `menu_item.price` + `menu_item.currency`
- Конвертация в `appState.currencyCode` — на клиенте или в endpoint (на выбор)

### 5.5 Изменения в моделях

- `restaurant`: `originalLanguage: String`, `originalCurrency: String`
- `menu_item`: `currency: String` (обычно совпадает с restaurant, но иногда смешанное)
- `category`: `nameOriginal: String`, `nameEn: String`

### 5.6 API endpoints

- `getMenuForLanguage(restaurantId, language)` — возвращает меню с переводами
- `getCurrencyRate(base, quote)` — для on-the-fly конверсии в Flutter
- Batch helper: `convertPrices(List<int> menuItemIds, String targetCurrency)`

### 5.7 Flutter

- Настройки уже хранят `languageCode` + `currencyCode`
- В `RestaurantScreen`/`MenuItemScreen` показывать переведённые имена (fallback на оригинал)
- Индикатор "перевод обновляется" пока async worker дорабатывает
- Price formatting через локальный конвертер с курсом из `CurrencyRate`

### Критерии готовности

- Португальское меню → русские имена + рубли по текущему курсу
- Кэш переводов: повторное открытие меню не зовёт Claude
- Курсы обновляются в фоне, не влияют на UI latency
- Смешанные меню (part EN / part местный) обрабатываются корректно
- `llm_usage` отдельно трекает `dish_translation` калькуляцию стоимости

---

## ⏳ Sprint 6 — Платежи и деплой

### 6.1 PaymentService (.NET 10)

> **Кроссплатформенная подписка**: центральная таблица `user_subscriptions`
> ключом `userId` из JWT, НЕ платформа. Android покупка видна на iOS и Web.

**Собственная БД (отдельная PostgreSQL схема):**
- `user_subscriptions` (userId, status, expiresAt, productId) — единая запись
- `subscription_sources` (userId, platform, externalId, expiresAt) — источники
- `payment_events` (аудит всех событий)

**Зависимости:**
- `Stripe.net` — официальный Stripe .NET SDK
- `app-store-server-library-dotnet` (github.com/getmimo) — community Apple SDK
- `Google.Apis.AndroidPublisher.v3` — Google .NET SDK

**API:**
- `POST /payments/stripe/create-intent`
- `POST /payments/stripe/webhook`
- `POST /payments/apple/validate` — App Store signed transaction
- `POST /payments/apple/webhook` — App Store Server Notifications
- `POST /payments/google/validate` — purchase token
- `GET /payments/subscription/status?userId=X` — вызывается из Serverpod

**Flutter:**
- `in_app_purchase` для iOS/Android
- `flutter_stripe` для Web
- Модель: free tier (3 ресторана) + paid monthly/yearly

### 6.2 AWS инфраструктура

```
Route 53 → ALB (public)
  ├─ /api/*       → ECS Fargate: Serverpod Backend
  ├─ /images/*    → ECS Fargate: ImageService (.NET)
  ├─ /payments/*  → ECS Fargate: PaymentService (.NET)
  └─ /*           → S3 + CloudFront (Flutter Web)

Internal ALB (private):
  Serverpod → ImageService (internal JWT)
  Serverpod → PaymentService

RDS PostgreSQL Multi-AZ — каждый сервис своя schema
ElastiCache Redis — сессии Serverpod
S3 — image bytes
Secrets Manager — все пароли и API ключи
ECR — Docker образы
CloudWatch + X-Ray — logs + traces
```

### 6.3 Infrastructure as Code

- Terraform или AWS CDK
- Отдельные stacks для dev/staging/prod
- RDS с Multi-AZ + automated backups
- VPC с public/private subnets
- IAM roles для ECS задач

### 6.4 CI/CD

- GitHub Actions:
  - lint + test на каждый PR
  - build Docker образы → push в ECR на merge в main
  - deploy в staging автоматически, в prod через manual approval
- E2E тесты через `docker-compose.test.yml` перед деплоем

---

## 📋 Отложенные TODO

### Технический долг

1. **Spoonacular интеграция** (Sprint 3 заложено в `dish_provider_status` seed):
   - Создать `SpoonacularService` по паттерну `UnsplashImageSearchService`
   - Добавить в `EnrichmentWorker._imageProviders` map
   - Обогащает `dish_catalog`: ингредиенты, пищевая ценность, аллергены

2. **fal.ai реальная загрузка в S3** (Sprint 3 stub):
   - `ImageServicePersistence.persist()` сейчас только скачивает байты
   - Нужно добавить HTTP клиент к .NET ImageService с internal JWT
   - Генерировать JWT с issuer/audience из `InternalJwt:*` конфига ImageService
   - Upload через `POST /api/images` multipart
   - Без этого fal.ai URL протухают через ~24h

3. **PDF handling** в `ClaudeLlmService._buildUserContent`:
   - Сейчас любой файл идёт как `image/jpeg`
   - Anthropic API требует отдельный `document` content block для PDF
   - Нужна ветка `if (fileName.endsWith('.pdf')) { ... document block ... }`

4. **URL fetching** при пустых bytes:
   - Сейчас при `fileBytes.isEmpty` Claude просит "инферить по имени"
   - Лучше: server-side fetch URL, extract HTML/screenshot, передать как vision input
   - Нужен `URL → image bytes` помощник (например через Puppeteer/Playwright или `webshot`)

5. **GIN индекс для `unsplash_local_photo.keywords`**:
   - Ждёт поддержки `jsonb` в Serverpod (сейчас только `json`)
   - Когда появится — вернуть индекс в `unsplash_local_photo.spy.yaml`
   - Workaround: raw SQL cast `keywords::jsonb ?|` без индекса работает на ~5-10K rows за ~30ms

6. **`generateDishDescription` usage tracking**:
   - ✅ Уже реализовано в Sprint 3 бонус
   - Пишется в `llm_usage` с `operation='dish_description'`, `restaurantId=null`

7. **Claude JSON robustness**:
   - Сейчас `_parseMenuJson` падает на невалидном JSON
   - Можно добавить retry с promt "fix this JSON": ... при первой ошибке
   - Или structured outputs через tool use (когда поддержит Haiku)

### Observability

8. **Admin endpoint `admin.getMetrics()`** — агрегированный JSON со счётчиками для web dashboard или Grafana Simple JSON datasource

9. **PostHog** для client-side product events (menu_uploaded, dish_favorited, search_used)

10. **Sentry** для server + client error tracking

11. **Prompt caching** — добавить `cache_control: {type: ephemeral}` к system promt (когда Haiku поддержит полноценно). Снижает повторные `menu_extraction` стоимости ~10×.

### UX улучшения

12. **Resize фото на клиенте перед отправкой** — с 1024×1365 до 1024×768 экономит ~45% input токенов Claude при vision

13. **Progress indicator для upload** — сейчас просто spinner без процента

14. **Offline mode** — кэшировать недавние меню в SharedPreferences для просмотра без сети

15. **Shared image cache** — вместо hotlink каждый раз использовать Flutter `cached_network_image` пакет

### Интеграционные тесты

16. **`docker-compose.test.yml`** в корне монорепо:
    ```yaml
    services:
      postgres-test:
      redis-test:
      minio:
      serverpod-test:
      imageservice-test:
      paymentservice-test:
    ```

17. **End-to-end test**: upload photo → AI parse → dish catalog → UI rendering

18. **Cross-platform subscription test**: mock Stripe purchase → status visible via mock Apple/Google endpoints

---

## Порядок реализации

Рекомендую:

1. **Sprint 4.5** — curated dish dataset bootstrap (~$142, ~1 неделя работы). Даёт dataset который станет основой для Sprint 5 локализации и уберёт зависимость от external image APIs в hot path
2. **Sprint 5** — локализация, строится поверх Sprint 4.5 `dish_translation` инфраструктуры
3. **Sprint 4.6** — admin UI для ongoing curation (можно отложить до первых реальных пользователей)
4. **Технический долг #1 Spoonacular** — если хочется расширенную информацию о блюдах (ingredients, nutrition, allergens)
5. **Sprint 6 — PaymentService + AWS** — когда готов к production
6. **Технический долг #2 fal.ai upload** — параллельно с Sprint 6 (ImageService уже поднят в AWS)
7. **Observability #8-10** — перед первыми реальными пользователями

---

## Критические файлы для следующих спринтов

### Sprint 5 — локализация

- [claude_llm_service.dart](MenuAssistant/menu_assistant_server/lib/src/services/llm/claude_llm_service.dart) — промпт extension
- [dish_catalog.spy.yaml](MenuAssistant/menu_assistant_server/lib/src/models/dish_catalog.spy.yaml) — миграция схемы
- Новое: `dish_translation.spy.yaml`, `currency_rate.spy.yaml`
- Новое: `lib/src/services/enrichment/dish_translation_service.dart`
- Новое: `lib/src/services/currency/currency_service.dart`
- Новое: `lib/src/future_calls/translation_worker_future_call.dart`
- Новое: `lib/src/future_calls/currency_rate_update_future_call.dart`
- [restaurant_endpoint.dart](MenuAssistant/menu_assistant_server/lib/src/endpoints/restaurant_endpoint.dart) — новые методы
- [restaurant_repository.dart](MenuAssistant/menu_assistant_flutter/lib/repositories/restaurant_repository.dart) — Flutter wrappers
- [menu_item_screen.dart](MenuAssistant/menu_assistant_flutter/lib/screens/menu_item_screen.dart) — перевод UI

### Sprint 6 — платежи

- Новая папка в корне репо: `PaymentService/` (структура аналогична ImageService)
- [pubspec.yaml](MenuAssistant/menu_assistant_flutter/pubspec.yaml) — добавить `in_app_purchase` + `flutter_stripe`
- Новая папка: `infrastructure/` — Terraform или CDK
- `.github/workflows/` — CI/CD pipelines
