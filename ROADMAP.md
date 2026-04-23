# MenuAssistant Roadmap

Что сделано, что осталось, и что отложено. Актуально на 2026-04-22.

Полная версия исходного плана с архитектурными решениями хранится в
`~/.claude/plans/stateful-sniffing-cocke.md` (approved plan). Этот документ —
executive summary для трекинга прогресса.

Design handoff для UI redesign + landing + admin лежит в `design/` — см. `design/README.md` + `design/design-notes.md`.

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

## ✅ Sprint 4.5 — Curated dish dataset (DONE 2026-04-22)

> **Закрыт 2026-04-22.** 4000+ dishes с описаниями + переводами на 6 языков + сгенерированными картинками готовы и экспортированы. Всё owned + commercial-legal. CuratedDishService интегрирован в `DishCatalogService.findOrCreate` (curated-first lookup, см. [dish_catalog_service.dart:65-94](MenuAssistant/menu_assistant_server/lib/src/services/enrichment/dish_catalog_service.dart#L65-L94)) — live меню уже использует curated dataset для мгновенных descriptions/images без внешних API.

### Итоги

- ~4000+ блюд в `curated_dish` с descriptions (Opus 4.7 + Wikidata + relaxed "plausible" fallback с тегом)
- Переводы на 6 языков (EN/RU/PT/ES/IT/FR/DE) в `dish_translation`
- Картинки в `curated_dish_image` — Flux Schnell GGUF через InferenceService на remote GPU (Windows native, без Docker)
- Export snapshot через `bin/export_curated_dataset.dart` в `seed_data/curated/` (git-tracked) с `dataset_version` idempotency
- Bootstrap cost: ~$50 one-time (Claude API + TheMealDB key + electricity)

### Ниже — оригинальный design документ bootstrap'а (исторический reference)

> **Цель** (оригинальная): ~5000 dishes с описаниями на 7 языках + сгенерированными фото,
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

## ✅ Sprint 4.6 — Design Foundation + Restaurant dedup schema (DONE 2026-04-22)

> **Цель**: подготовить фундамент для трёх треков redesign'а — дизайн-токены и шрифты едины для Flutter / landing / admin, + backend schema-миграция для глобальных ресторанов с fuzzy-match дедупом.

### Итоги
- `design/tokens/{tokens.json,generate.mjs,tokens.css,package.json}` — канонический источник + идемпотентный генератор (`.css` + `.dart`)
- `lib/theme/{tokens.dart,typography.dart,app_theme.dart}` + Fraunces / Inter / JetBrainsMono self-hosted variable TTF (`assets/fonts/`)
- [main.dart](MenuAssistant/menu_assistant_flutter/lib/main.dart): `buildTheme(AppTheme.warm)` / `AppTheme.midnight` вместо `seedColor: Colors.blueGrey`
- `restaurant` schema перестроена: `normalizedName`, `latitude/longitude`, `cityHint`, `countryCode`, `addressRaw`. `pg_trgm` extension + GIN index `restaurant_name_trgm_idx` + geo index
- Новое: `user_restaurant_visit`, `menu_source_page`. Удалено: `restaurant_member`
- `menu_item.{imageUrl,descriptionRaw}` удалены; новый `MenuItemView` DTO + `MenuItemViewMapper` резолвит description из `dish_catalog`, imageUrl из `dish_image WHERE isPrimary=true` (+ partial index `dish_image_primary_idx`)
- Новое: `RestaurantDedupService` (pg_trgm similarity ≥ 0.92 + ≤150m → auto-merge, 0.70–0.92 + ≤300m → ask user, иначе → new). Unit tests — 11/11
- Новое: `IpGeoService` + `DbIpUpdateFutureCall` (DB-IP Lite country CSV, weekly refresh)
- `ClaudeLlmService.parseMenu({required List<MenuPageBytes> pages})` — multi-image support
- `RestaurantEndpoint.confirmMatch(pending, matchedId)` — сливает/отклоняет dedup кандидата
- `docs/legal/db-ip-attribution.md` — обязательный CC-BY 4.0 текст для landing `/legal` (Sprint 4.8)
- Migration: `migrations/20260422100510849/` применена локально. `dart analyze` + `flutter analyze` — 0 errors

### Deferred в follow-up спринт (отмечено в коде)
- **mmdb city-level парсинг** — сейчас `IpGeoResult.cityName/latitude/longitude = null`. Dedup city-scope fallback работает только когда мы добавим mmdb reader (~200 LOC binary-tree walker). Сценарий `similarity ≥ 0.92 + same city → ask user` дорм пока нет city-level данных.
- Flutter UI переключатель тем (warm/sage/midnight) — `buildTheme()` готова, переключатель в 4.7

Handoff для всех трёх треков: `design/` (prototype HTML/JSX + `design/README.md` с полным спектром tokens/typography/components). Дубль `design_handoff_menuassistant/` удалён 2026-04-22.

### Ниже — оригинальный design документ (исторический reference)

### 4.6.1 Design tokens (source of truth)

- `design/tokens/tokens.json` — canonical значения (Warm/Sage/Midnight themes, spacing, radii, typography scale, shadows). Ровно то что в `design/README.md`
- `design/tokens/generate.mjs` — скрипт конвертации json → два представления:
  - `design/tokens/tokens.css` — CSS variables для landing + admin
  - `MenuAssistant/menu_assistant_flutter/lib/theme/tokens.dart` — `AppColors` / `AppSpacing` / `AppRadii` / `AppShadows` классы
- Правка одного цвета = правка одного JSON → regenerate → все три поверхности получают update. Без этого гарантированный drift на месяце-втором

### 4.6.2 Typography (Fraunces / Inter / JetBrains Mono)

- Скачать TTF в `MenuAssistant/menu_assistant_flutter/assets/fonts/` (Fraunces variable, Inter, JetBrains Mono)
- Подключить в `pubspec.yaml` с правильными weights (Fraunces 400/500/600/700 + italic; Inter 400/500/600/700; Mono 400/500)
- Важно: Fraunces variable — `opsz=144` для очень крупного display italic через `FontVariation` в `TextStyle`
- Новый `lib/theme/typography.dart` с `TextTheme` маппингом type scale (Screen H1 30-34 / Body 13 / Price 28 / etc.)
- Применить в `main.dart` ThemeData (заменить текущий `seedColor: Colors.blueGrey`)
- Landing + admin шрифты через Google Fonts CDN или self-host для performance

### 4.6.3 Restaurant dedup schema + DB-IP geo

**Новая модель данных**: глобальные рестораны (не per-user) + join-таблица визитов. Существующие user-restaurants дропаем (не в prod).

**ВАЖНО**: миграция трогает ТОЛЬКО `restaurant` + связанные `menu` / `category` / `menu_item` (user-facing). НЕ трогает `user`/auth, `dish_catalog`, `curated_dish`/`curated_dish_image`/`dish_translation`, `dataset_version`, `llm_usage`, `user_favorite_*` (favorites dish/restaurant).

**Изменения в моделях:**
```yaml
# restaurant.spy.yaml (перестроена)
class: Restaurant
fields:
  name: String                    # canonical (from menu or user input)
  normalizedName: String          # для fuzzy match (lowercase + strip accents/punct)
  latitude: double?
  longitude: double?
  cityHint: String?               # IP-derived, если precise geo нет
  countryCode: String?            # ISO 3166-1 alpha-2
  addressRaw: String?
  # userId УДАЛЁН — ресторан глобальный
indexes:
  restaurant_geo_idx:
    fields: latitude, longitude
  restaurant_name_trgm_idx:
    fields: normalizedName
    type: gin                     # pg_trgm

# user_restaurant_visit.spy.yaml (NEW)
class: UserRestaurantVisit
fields:
  userId: int                     # relation to serverpod User
  restaurantId: int               # relation to Restaurant
  firstVisitAt: DateTime
  lastVisitAt: DateTime
  liked: bool, default=false
indexes:
  user_restaurant_visit_uniq_idx:
    fields: userId, restaurantId
    unique: true
```

**Миграция**: `DROP TABLE restaurant CASCADE` (снесёт `menu`/`category`/`menu_item` FK) → recreate. Включить `pg_trgm` extension в `up.sql`.

**Fuzzy-match пороги** (решение 2026-04-22):
- `pg_trgm` similarity ≥ 0.92 + radius ≤ 150m → **auto-merge** (новый `user_restaurant_visit`)
- 0.70 – 0.92 + radius ≤ 300m → **ask user** через endpoint `RestaurantEndpoint.confirmMatch(uploadId, matchedId | null)`
- < 0.70 или radius mismatch → new restaurant
- Без precise geo → city-scope из DB-IP (см. ниже)

**IP-geo: DB-IP Lite City** (НЕ MaxMind):
- Причина: MaxMind GeoLite2 с Dec 2019 под EULA с 30-day data retention cap + обязательный account/license key. DB-IP Lite City — CC-BY 4.0 (без ShareAlike), нет retention ограничений, без регистрации
- Self-hosted mmdb ~50MB, weekly update через cron
- Backend-only lookup (не distrib'утим derivatives), gotcha #13-18 (CC-BY-SA concerns) не конфликтует
- Attribution: одна строка в landing `/legal` footer: *"IP geolocation by DB-IP"* со ссылкой
- **НЕ** используется для precise coords (city-level точности мало для 150m радиуса) — только scope-hint для fuzzy-name-matching когда precise geo отсутствует
- `package:maxmind_db_reader` в Dart работает с DB-IP mmdb форматом тоже
- Новый `lib/src/services/geo/ip_geo_service.dart` + cron-задача на download через Serverpod FutureCall

**Новый `RestaurantDedupService`** (в `lib/src/services/restaurant/`):
- `findOrCreate(name, geo?, userId) → (restaurantId, requiresConfirmation: bool, candidates: [])`
- При `requiresConfirmation=true` клиент показывает modal "Возможно, это {candidate.name}?" → Да/Нет
- Если Нет → создаём новый ресторан с `pendingReviewFlag=false` (не блокируем публикацию — решение 2026-04-22: никакого gating)

### 4.6.4 Multi-page menu поддержка (backend часть)

Нужна для нормального UX при длинных меню. Flutter UI часть — в Sprint 4.7.

```yaml
# menu_source_page.spy.yaml (NEW)
class: MenuSourcePage
fields:
  menu: Menu?, relation
  ordinal: int                    # 0-based page index
  sourceType: String              # 'photo' | 'pdf_page' | 'link_screenshot'
  imageUrl: String
  createdAt: DateTime
indexes:
  menu_source_page_menu_ordinal_idx:
    fields: menuId, ordinal
    unique: true
```

- Claude Haiku request: multi-image `content: [{type:"image", ...}, {type:"image", ...}, {type:"text", ...}]`
- ClaudeLlmService принимает `List<Uint8List>` вместо single bytes
- Cost implications в `llm_usage`: записываем total tokens per menu, не per page

### 4.6.5 Schema cleanup — убрать денормализованные URL snapshot'ы

**Обнаружено 2026-04-22** при миграции URL с :8080 на :8082 (см. gotcha #20): `menu_item.imageUrl` хранит копию URL из `dish_image`/`curated_dish_image` на момент парсинга меню (ставится в [ai_processing_endpoint.dart:79](MenuAssistant/menu_assistant_server/lib/src/endpoints/ai_processing_endpoint.dart#L79)). При изменении URL в источнике `menu_item.imageUrl` остаётся stale. Нужен `UPDATE` в нескольких местах вместо одного.

**Решение**: удалить `menu_item.imageUrl` field. Резолвить через JOIN в endpoint'ах, которые отдают меню клиенту:
```
menu_item → dish_catalog → dish_image (WHERE isPrimary=true) → imageUrl
```

Эквивалентно для описаний: `menu_item.description` сейчас тоже денормализовано (fallback'ается из `dish_catalog.description` при парсинге) — проверить и при необходимости тоже убрать.

**Миграция**: `ALTER TABLE menu_item DROP COLUMN "imageUrl"` (+ аналогично для description если уберём). Endpoint'ы переписать на JOIN.

Объём: 259 menu_items + 143 dish_images сейчас — overhead JOIN ничтожен. Scaling-wise: добавить индекс `dish_image_dishCatalogId_isPrimary_idx (dishCatalogId, isPrimary) WHERE isPrimary = true` для fast-lookup.

**Делается в Sprint 4.6** вместе с перестройкой `restaurant` schema — одна миграция покрывает оба изменения.

### 4.6.6 Критерии готовности Sprint 4.6

- `design/tokens/tokens.json` + генератор работает, два target'а (`.css`, `.dart`) пересобираются идемпотентно
- Шрифты подключены, `flutter run` собирается, старые экраны визуально используют Fraunces + terracotta (ожидаемый хаос до redesign экранов в Sprint 4.7)
- `restaurant` схема мигрирована, `pg_trgm` extension активна, `user_restaurant_visit` создана
- `RestaurantDedupService.findOrCreate` с fuzzy-match + geo работает на unit-тестах
- DB-IP mmdb скачивается cron'ом, `IpGeoService.lookup(ip)` возвращает city/country
- `menu_source_page` таблица готова, `ClaudeLlmService` принимает multi-image
- Landing `/legal` page (даже stub) содержит attribution DB-IP
- `menu_item.imageUrl` (и возможно `description`) удалены из schema, endpoint'ы резолвят через JOIN на `dish_image`
- `dart analyze` — 0 errors

---

## ✅ Sprint 4.7 — Flutter redesign (DONE 2026-04-22)

> **Цель**: 9 экранов дизайна перенесены в Flutter по tokens из Sprint 4.6, новая navigation структура, multi-page upload UI, geo permission flow.

### Итоги
- **Shared widgets**: 10 штук (`primary_button`, `accent_button`, `ghost_button`, `app_input`, `app_chip`, `photo_placeholder`, `allergen_badge`, `accent_fab`, `app_bottom_sheet`, `lang_dropdown`) + 2 illustrations (`paper_menu`, `glass_pill`). Все используют `Theme.of(context).colorScheme` + `AppSpacing/AppRadii/AppShadows` из tokens — нулевой drift от design/README.md
- **9 экранов**: OnboardingScreen (3 слайда), AuthScreen (merged email+pass + Google), HomeScreen (search + chips + list + AccentFab), AccountScreen (абсорбировал settings), RestaurantScreen (sliver hero + category list), DishListScreen (2×N grid), MenuItemScreen (DishDetail), AddMenuBottomSheet (multi-page flow), MatchConfirmationDialog, EmptyHomeScreen
- **Удалены**: `greetings_screen.dart`, `sign_in_screen.dart`, `settings_screen.dart`
- **i18n**: gen_l10n SDK-native pipeline. `app_en.arb` (100+ ключей) + `app_ru.arb` (полный перевод). PT/ES/IT/FR/DE — stubs с EN-fallback. Runtime switch работает через `MaterialApp.locale = appState.languageCode`
- **Geolocation**: `geo_service.dart` — `geolocator 14.0.2` для permission+position, `native_exif 0.7.0` для iOS/Android EXIF, `exif 3.3.0` pure-Dart fallback. `AppState.requestLocationPermission()` + `lastKnownPosition`
- **Multi-page upload**: `AddMenuBottomSheet` — primary accent card (camera) → preview strip (PageView + remove-per-page) → Ghost "Add page" + Accent "Done → Parse" → `processMultiPageMenu(List<MenuPageInput>)` → если `requiresConfirmation` показывает `MatchConfirmationDialog`
- **Match confirmation**: `MatchConfirmationDialog` показывает candidate (name + address + similarity% + distance) + "Yes / No". "Yes" → `restaurantRepo.confirmMatch(pending, matchedId)` мерджит категории + visits
- **Onboarding gate**: `main.dart` читает `SharedPreferences('onboardingCompleted')` — первый запуск → OnboardingScreen; иначе Auth/Home
- `flutter analyze` — 0 errors. `dart analyze` (server) — 0 errors. Unit tests server-side — 11/11

### Deferred в follow-up спринт
- **Screenshot tests** для hero экранов (`golden_toolkit` + CI pipeline) — требует CI настройки, вне scope spec для 4.7
- **Полные переводы PT/ES/IT/FR/DE** — stubs на EN сейчас, перевод нужен перед маркетинговым релизом. Источник-референс: `SCREEN_I18N` в `design/components/screens.jsx`
- **Profile name/email из auth** — сейчас Header в AccountScreen использует fallback из `recentRestaurants.first.name` + `authInfo.authUserId`. Правильный profile endpoint — follow-up
- **EmptyHomeScreen подключение** — компонент готов, но HomeScreen пока показывает inline-empty (`_buildInlineEmpty`) для экономии push-навигации при пустом state. Подключить к `main.dart` gate когда получим реальный user-flow feedback

### Mapping с существующими экранами

| Design # | Существующий Flutter | Действие |
|---|---|---|
| 01 Onboarding | `greetings_screen.dart` | **Удалить** (Serverpod starter leftover) + новый `OnboardingScreen` (3 слайда, один из них — geo permission prompt) |
| 02 Auth | `auth_screen.dart` + `sign_in_screen.dart` | **Merge в один** AuthScreen (email + password → backend определяет signin vs signup) |
| 03 Home | `home_screen.dart` | Redesign: grid → vertical list, FAB terracotta 60×60 r=20 |
| 04 Restaurant | `restaurant_screen.dart` | 180px hero + glass back/heart + natural-language search |
| 05 Dish list | inline часть `restaurant_screen.dart` | 2×N grid |
| 06 Dish detail | `menu_item_screen.dart` | Clean read (убраны "Show original" / "Save" — April handoff update) |
| 07 Add menu sheet | `widgets/add_menu_bottom_sheet.dart` | + **multi-page flow**: "Add page" после первой фотки, reorder, done |
| 08 Profile | `account_screen.dart` | Полный redesign, поглощает `settings_screen.dart` (Language / Currency / Diet / Theme inline) |
| 09 Empty | новый | Paper-menu SVG + "Capture first menu" |
| — | `favorite_restaurants_screen.dart` / `favorite_dishes_screen.dart` | Keep, redesign, переходы из Profile |
| — | `settings_screen.dart` | **Удалить** (поглощён Profile) |

### 4.7.1 Shared widgets (fundament перед экранами)

В `lib/widgets/`:
- `PrimaryButton` / `AccentButton` / `GhostButton`
- `AppInput` (icon-prefixed, 14px radius, 44-48 height)
- `AppChip` (pill 999, mono metadata variant)
- `PhotoPlaceholder` (striped SVG — fallback для случаев когда картинка ещё не готова)
- `AllergenBadge` (9px Mono, green tint)
- `AccentFab` (60×60 r=20 terracotta)
- `AppBottomSheet` (28r, drag handle)
- `LangDropdown` (7 языков, flag + code + native name)

### 4.7.2 Geo permission flow

Onboarding slide 2 (из 3) — "Разрешите доступ к геолокации, чтобы мы могли точнее определять рестораны".
- Если Allow → persist permission state в `app_state`
- Если Deny → fallback на EXIF GPS (при upload) + DB-IP (server-side)
- Можно повторно запросить позже из Profile → "Location" setting

### 4.7.3 Multi-page upload UI

В `AddMenuBottomSheet`:
- После первой фотки → экран preview "Page 1" + button "Add page" / "Done"
- "Add page" → camera → preview "Page 2" → опять "Add page"/"Done"
- Drag-reorder pages
- Done → upload multipart с всеми `menu_source_page.image` + ordinal

### 4.7.4 Ask-user match confirmation

Новый modal после upload, если backend вернул `requiresConfirmation=true`:
- "Это **Tasca do Zé** на **Rua do Almada 182**?" + фото / адрес candidate
- [Да, это он] → merge, open restaurant
- [Нет, другой] → create new restaurant

### 4.7.5 i18n (7 языков)

- `flutter_localizations` + ARB файлы: `app_en.arb` / `app_ru.arb` / `app_pt.arb` / `app_es.arb` / `app_it.arb` / `app_fr.arb` / `app_de.arb`
- Перенос `SCREEN_I18N` из `design/components/screens.jsx` (reference copy-strings)
- Fallback chain: specific → EN → RU (как в handoff)

### Критерии готовности Sprint 4.7

- Все 9 экранов дизайна работают pixel-close к prototype'у
- Auth merged в один экран
- Multi-page upload работает end-to-end (photo → preview → add → submit → parsed menu)
- Geo permission запрашивается в onboarding, отказ корректно fallback'ит на EXIF/IP
- Ask-user match modal появляется при similarity 0.70-0.92
- `settings_screen.dart` + `greetings_screen.dart` удалены
- 7 языков переключаются без перезапуска app'а
- `flutter analyze` — 0 warnings, screenshot-тесты для hero экранов зелёные

---

## ⏳ Sprint 4.8 — Landing (Astro)

> **Цель**: SEO-friendly static single-page landing, хостится Serverpod'ом как static route.

### Стек

**Astro** (не Next.js). Причина:
- Static + minimal JS — лендинг в основном контент, не app
- Polyglot marquee — единственный JS island (остальное zero-JS)
- Сборка → plain HTML/CSS/JS → кладётся в `MenuAssistant/menu_assistant_server/web/pages/landing/`
- Serverpod хостит через `StaticRoute.directory('web/pages/landing')`

### Структура

Новая папка в корне репо `landing/`:
- `src/components/` — Astro components из handoff (`Nav`, `Hero`, `Problem`, `Polyglot`, `HowItWorks`, `Features`, `AppShowcase`, `Cta`, `Footer`)
- `src/content/i18n.json` — 7 языков (EN/RU/PT/ES/IT/FR/DE), copy из handoff HTML
- `src/pages/index.astro` — импорт секций, SSR
- `src/pages/legal.astro` — privacy, terms, DB-IP attribution, Wikimedia attribution
- `public/` — real photos (selected из `web/static/images/curated/` ~20 hero-quality)
- `astro.config.mjs` — i18n routing (`/`, `/ru`, `/pt`, ...)

### Polyglot marquee (JS island)

Единственный JS на странице. Recipe:
- rAF-driven marquee, два экземпляра контента back-to-back, measured loop width
- Smooth decelerate to stop on hover (~600ms easeOutCubic)
- Accel back on mouseleave
- `visibilitychange` pause когда tab hidden
- На mobile — native horizontal scroll with snap

`client:idle` hydration — загружается после первого idle browser frame.

### Deploy

- `pnpm build` → `dist/` → rsync в `MenuAssistant/menu_assistant_server/web/pages/landing/`
- Serverpod `server.dart`: `pipeline.addRoute(StaticRoute(directory: 'web/pages/landing', ...))` на путь `/` или `/landing`
- SSL via CloudFront (Sprint 6)

### Критерии готовности Sprint 4.8

- Лендинг доступен на `/landing` (pre-Sprint-6) или на root `/` domain (post-Sprint-6)
- 7 языков работают через URL-prefix routing
- Polyglot marquee: hover pause smooth, accessibility-fallback на reduced-motion
- Lighthouse score ≥ 95 (perf + SEO + best practices)
- Real photos загружены, striped placeholders исчезли
- `/legal` содержит attribution DB-IP + Wikimedia

---

## ⏳ Sprint 4.9 — Admin (Next.js separate site)

> **Цель**: полная moderation-панель для продукта как **отдельный сайт** на отдельном домене с собственной авторизацией. Не пересекается с Flutter app.

Ключевое решение (2026-04-22): admin — не вкладка в Flutter, а standalone Next.js на `admin.menuassistant.app` с отдельной авторизацией через Cloudflare Access.

### Стек

- **Next.js 15 App Router** + **TanStack Query** + **TanStack Table** (virtualization для 4000+ rows)
- **shadcn/ui** поверх `tokens.css` из Sprint 4.6 (не Material / Tailwind-only)
- Handoff JSX из `design/admin/app.jsx` — прямой reuse как reference, конверсия в shadcn-based components
- Deploy: **Vercel free tier**
- Домен: `admin.menuassistant.app` (subdomain)

### Авторизация — отдельный контур

**Cloudflare Access (free tier до 50 users)** как auth-gate перед Vercel deploy:
- Email-OTP identity (zero password management в нашей БД)
- Gate перед Next.js app — неавторизованный не увидит login page вообще
- Identity = email, проксируется в request header `Cf-Access-Authenticated-User-Email`

**Thin `admin_user` table** в Serverpod DB:
- PK: `email` (lowercase)
- Fields: `invitedAt`, `lastLoginAt`, `displayName`, `role` (MVP: без ролей, `role='moderator'` default)
- НЕ пересекается с Serverpod `User` table — полная изоляция от B2C auth
- Нужен только для audit trail (связать actions с email)

**Новые admin endpoints** в Serverpod (отдельная scope `AdminEndpoint` с middleware `requireAdminAccess`):
- Middleware проверяет `Cf-Access-Authenticated-User-Email` header, lookup в `admin_user`, подставляет identity в session
- Без header или email не в `admin_user` → 401

### 10 экранов (из handoff `design/admin/app.jsx`)

1. **Dashboard** — KPI (menus parsed, accuracy, in queue, active users, avg parse time) + volume chart + top parse issues + moderator activity table
2. **Queue / Menu validator (combined)** — решение 2026-04-22: не blocking gate, а observability. Все parsed menus списком + click → validator view (source photo per page + parsed items editable + approve/reject). Правки пушатся на клиент
3. **Dish review** — catalog-level approval queue (pending `curated_dish` entries с `plausible_description` tag, low confidence etc.)
4. **Photo review** — grid картинок с `qualityScore < 3`, keyboard-driven grading (1-5 + Enter для следующей)
5. **Translations** — таблица переводов по языкам, inline edit
6. **Dish library** — full `dish_catalog` + `curated_dish` CRUD
7. **Restaurants** — список глобальных ресторанов. **"Claim" column hard-hidden** до Sprint 6 (B2B)
8. **Users** — таблица пользователей Flutter app (read-only из B2C User table). Роли (user/moderator/admin) **отложены в техдолг**, в MVP — плоский список
9. **Audit log** — immutable, 24-месячное хранение, IP tracking, non-editable

### Новые Serverpod модели для admin

```yaml
# admin_user.spy.yaml
class: AdminUser
fields:
  email: String                   # PK (lowercase)
  displayName: String?
  invitedAt: DateTime
  lastLoginAt: DateTime?
  role: String, default='moderator' # MVP: только moderator/admin
indexes:
  admin_user_email_idx:
    fields: email
    unique: true

# audit_log.spy.yaml
class: AuditLog
fields:
  timestamp: DateTime
  actorEmail: String              # FK admin_user.email
  action: String                  # 'approved' | 'edited' | 'rejected_photo' | 'merged' | 'deleted' | 'flagged' | 'role_changed'
  objectType: String              # 'menu' | 'dish' | 'restaurant' | 'user' | 'translation'
  objectId: String
  diff: String                    # JSON diff or human-readable summary
  ipAddress: String?              # из Cf-Connecting-IP
indexes:
  audit_log_timestamp_idx:
    fields: timestamp
  audit_log_actor_idx:
    fields: actorEmail
```

**Retention**: 24 месяца decision (2026-04-22). Оценка: 10 moderators × 100 actions/day × 24mo = 720k rows × ~500B = ~360 MB worst case, реально ~50-100 MB. PostgreSQL free tier справляется. При разрастании — archive в S3 Glacier через cron ($0.004/GB-month).

### Критерии готовности Sprint 4.9

- Admin доступна на `admin.menuassistant.app` через Cloudflare Access email-OTP
- Все 10 экранов реализованы (Queue/Validator merged, Claim column hidden, Users без roles MVP)
- Правки в validator моментально пушатся на Flutter client (через Serverpod real-time streams или poll)
- Audit log записывается на каждое mutation через Serverpod middleware
- `admin_user` table создана, invite flow работает через admin UI (Dashboard → Invite moderator → email OTP setup)
- Design tokens из Sprint 4.6 используются — visual consistency с Flutter + landing
- Density tweaker panel из prototype **вырезан** (это dev edit-mode Claude Design, не prod feature)

---

## ⏳ Sprint 4.10 — Curated Candidate Promotion

> **Цель**: замкнуть петлю роста curated dataset — блюда из реальных меню, не
> нашедшие себе пару в `curated_dish`, автоматически агрегируются в очередь
> кандидатов и через admin ревью промоутятся в curated_dish. Требует готовой
> admin UI из Sprint 4.9.

### Проблема

Сейчас при парсинге меню в [dish_catalog_service.dart:59-93](MenuAssistant/menu_assistant_server/lib/src/services/enrichment/dish_catalog_service.dart#L59-L93):
1. Lookup в `dish_catalog` по `normalizedName` — если есть, reuse.
2. `CuratedDishService.findMatch` (3-pass) — если match, линкуем `curatedDishId`.
3. Иначе — создаём `dish_catalog` row с `curatedDishId=null` + live enrichment (Wikidata / Unsplash / Pexels / fal.ai).

Unmatched блюда оседают в `dish_catalog` как мёртвый груз: никем не агрегируются, не ранжируются по частоте, нет workflow продвижения в curated. Это блокирует рост покрытия (целевые 90%+ menu items → известный curated dish).

### 4.10.1 Новая таблица `curated_dish_candidate`

```yaml
# lib/src/models/curated_dish_candidate.spy.yaml
class: CuratedDishCandidate
table: curated_dish_candidate
fields:
  # Стабильный группирующий ключ (normalizedName после fuzzy-collapse).
  # Один candidate = один потенциальный curated_dish.
  groupKey: String
  # Представительное имя (самый частый canonicalName в группе).
  displayName: String
  # Агрегаты от aggregator future call.
  occurrenceCount: int             # сколько menu_item ссылок суммарно
  restaurantCount: int             # distinct ресторанов
  countryCodes: List<String>?      # страны, где всплывало
  # До 20 разных canonicalName вариантов и dishCatalogIds для показа в admin UI.
  sampleVariants: List<String>
  sampleDishCatalogIds: List<int>
  # State machine:
  # pending   — ждёт ревью
  # enriching — approved, работает CandidateEnrichmentFutureCall
  # promoted  — создан CuratedDish, остаётся как audit trail
  # merged    — совмещён с существующим CuratedDish (см. promotedCuratedDishId)
  # rejected  — не блюдо / junk / дубликат с отклонением
  reviewStatus: String
  promotedCuratedDishId: int?
  rejectReason: String?
  reviewedBy: String?              # admin_user.email
  reviewedAt: DateTime?
  firstSeenAt: DateTime
  lastSeenAt: DateTime
  createdAt: DateTime
  updatedAt: DateTime
indexes:
  curated_dish_candidate_group_key_idx:
    fields: groupKey
    unique: true
  curated_dish_candidate_status_idx:
    fields: reviewStatus
  curated_dish_candidate_occurrence_idx:
    fields: occurrenceCount
```

`dish_catalog.curatedDishId` уже nullable — расширения existing таблиц не нужно.

### 4.10.2 Aggregator future call (daily, self-rescheduling)

Паттерн — как [enrichment_worker_future_call.dart](MenuAssistant/menu_assistant_server/lib/src/future_calls/enrichment_worker_future_call.dart): `FutureCall` + `callAtTime` в `finally`.

Логика одного tick'а:
1. `SELECT` all `dish_catalog WHERE curated_dish_id IS NULL`.
2. Для каждой — `COUNT(*)` по `menu_item WHERE dish_catalog_id = dc.id`, distinct `restaurant_id` (join category → restaurant), `restaurant.countryCode`.
3. Fuzzy-collapse вариантов в один `groupKey` (см. 4.10.3).
4. `UPSERT` в `curated_dish_candidate` по `groupKey`:
   - новый row → `reviewStatus='pending'`
   - `promoted` / `rejected` / `merged` — не трогаем (исторический snapshot), только `lastSeenAt`
   - `enriching` — обновляем агрегаты
5. После promoted candidate'а backfill: `UPDATE dish_catalog SET curated_dish_id = <promotedCuratedDishId> WHERE normalized_name IN (candidate.sampleVariants)` — замыкает петлю, следующее меню с тем же блюдом не попадёт в unmatched set.

Интервал — 24h (ночью). Для MVP хватит полного rescan'а, позже incremental по `updatedAt`.

### 4.10.3 Fuzzy-collapse стратегия

На старте **token-set overlap** (стратегия B):
- `groupKey` = normalized + отсортированные токены ≥3 символов + join через `-`.
- Пример: `"Spaghetti alla Carbonara"` → `"alla-carbonara-spaghetti"`.
- Порог merge: token overlap ≥70% и первый токен совпадает.

Ложные склейки reviewer увидит и разделит через endpoint `split`. Когда объём перевалит за ~10k unmatched rows — перейти на embeddings через существующий `InferenceServiceClient` (локальный, бесплатно).

### 4.10.4 Promotion workflow

**Перед началом спринта: рефактор bin/*.dart Sprint 4.5 скриптов** — выделить общий `CandidateEnrichmentService` с методами `generateDescription(curatedId)` / `generateImage(curatedId)` / `generateTranslations(curatedId)`. И bin-скрипты, и future call зовут одинаково. Без этого copy-paste неизбежен.

**Admin endpoints** в `admin_endpoint.dart` (auth через Cloudflare Access middleware из Sprint 4.9):

| Endpoint | Действие |
|---|---|
| `candidates.list(filter)` | pending/enriching queue с sort by `occurrenceCount DESC` |
| `candidates.approve(id)` | создать `CuratedDish` draft → `candidate.reviewStatus='enriching'` → schedule `CandidateEnrichmentFutureCall` |
| `candidates.merge(id, existingCuratedDishId)` | дописать `displayName` в `aliases` existing dish, `status='merged'`, backfill `dish_catalog` |
| `candidates.reject(id, reason)` | `status='rejected'`, `rejectReason` |
| `candidates.split(id, regex)` | разделить candidate на 2 по regex/prefix на `sampleVariants` (опциональный, можно отложить) |

`CandidateEnrichmentFutureCall`:
1. Wikidata enrichment (country, cuisine, aliases).
2. Claude description generation.
3. fal.ai image generation + ImageService upload.
4. Translations batch (EN→7 языков).
5. `curated_dish.status='approved'`, `candidate.reviewStatus='promoted'`, backfill `dish_catalog`.

### 4.10.5 Admin UI (дописывается в Next.js admin из 4.9)

Новый экран **Candidates queue** (после Dish review, перед Dish library):
- Default filter `status=pending`, sort `occurrenceCount DESC`. Колонки: displayName, occurrences, restaurants, countries, sample variants (chips).
- Detail pane: превью `sampleVariants`, кнопки *Approve* / *Merge into…* (autocomplete по existing curated_dish) / *Reject* / *Split*.
- Queue filter "hot only" (`>=2 restaurants OR >=3 occurrences`), "new today", "enriching" (что сейчас варится).

### 4.10.6 Backfill текущего состояния

Один ручной прогон aggregator'а после деплоя — получает стартовый top-N unmatched из того, что уже накопилось в `dish_catalog` за Sprint 4.7+. Ожидаем сотни кандидатов, admin backlog на первую неделю.

### 4.10.7 Фильтры мусора на уровне aggregator'а

- Skip `length(normalizedName) < 4` (OCR обрезки).
- Skip rows где `canonicalName` начинается с цифры или спец.символа.
- Min threshold для admin queue: `>=2 restaurants OR >=3 occurrences` (опечатки/уникумы отфильтровать).

### Разбивка

| Stage | Суть | Оценка |
|---|---|---|
| 4.10.1 | Модель + миграция + ServiceRegistry wiring | 0.5 дня |
| 4.10.2 | Рефактор Sprint 4.5 bin/*.dart в `CandidateEnrichmentService` | 1 день |
| 4.10.3 | Aggregator future call + fuzzy-collapse (token-set) | 1.5 дня |
| 4.10.4 | Admin endpoints (list / approve / merge / reject) | 1 день |
| 4.10.5 | `CandidateEnrichmentFutureCall` orchestration | 0.5 дня |
| 4.10.6 | Admin UI screen в Next.js | 1.5 дня |
| 4.10.7 | Backfill + QA на реальных данных + корректировка fuzzy-порогов | 0.5 дня |
| **Итого** | | **~6 дней** |

### Критерии готовности

- Aggregator крутится ежедневно, заполняет `curated_dish_candidate` из unmatched `dish_catalog`.
- Admin queue показывает top-N pending с agregатами и sample variants.
- Approve запускает end-to-end enrichment → `CuratedDish` с description + image + translations.
- Backfill `dish_catalog.curatedDishId` срабатывает автоматически после promotion/merge.
- Coverage metric (`menu_item` с `curated_dish` link) трекается и растёт от месяца к месяцу.

### Success metrics

- **Coverage growth**: процент `menu_item` с `dish_catalog.curatedDishId IS NOT NULL` растёт month-over-month.
- **Queue throughput**: среднее время от `firstSeenAt` до `reviewedAt` < 7 дней.
- **Approval rate**: `approved+merged / reviewed` — если <30%, значит aggregator пропускает junk (подкрутить min threshold).
- **Dedup quality**: `merged / (approved+merged)` растёт со временем (новые curated перестают появляться, всё больше дубликатов) — это та цель, к которой идём.

### Открытые вопросы (решить перед стартом)

1. `candidates.approve` создаёт `curated_dish.status='approved'` или `'draft'`? Предлагаю `approved` с возможностью понизить обратно — иначе два раунда ревью.
2. Fuzzy strategy — token-set сразу или пробовать embeddings через `InferenceServiceClient`? Я за token-set на старте, embeddings когда объём вырастет.
3. `candidates.split` endpoint — MVP или отложить до первой реальной нужды? Отложить.

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

Sprints 1-3 + 4.5 ✅ done. Sprint 4 отменён. Далее рекомендую:

1. **Sprint 4.6** — Design Foundation (tokens + fonts + restaurant dedup schema + DB-IP + multi-page backend). Фундамент для трёх треков, параллелизуется с любой другой работой
2. **Sprint 4.7** — Flutter redesign (9 экранов, multi-page UI, geo onboarding). Большой спринт, ~6-8 недель
3. **Sprint 4.8** — Landing (Astro). ~1 неделя, параллельно с 4.7 можно
4. **Sprint 4.9** — Admin Next.js отдельный сайт. ~4-6 недель, можно параллельно с 4.7 для ускорения
5. **Sprint 4.10** — Curated Candidate Promotion. ~1 неделя, требует готовой admin UI из 4.9. Замыкает loop: unmatched menu dishes → candidate queue → curated_dish
6. **Sprint 5** — Локализация меню (i18n + currency). Использует инфраструктуру `dish_translation` из Sprint 4.5
7. **Sprint 6** — PaymentService + AWS production deploy
8. **Tech debt**: Spoonacular (#1), fal.ai upload (#2), Observability (#8-10)

**Параллелизация Sprint 4.6 → 4.9**: 4.6 фундамент, блокирует 4.7-4.9. После 4.6 — три независимых трека (Flutter / landing / admin), можно вести параллельно. Общая длительность: ~10-12 недель sequential, ~6-8 недель при параллельности.

### TODO tech debt (записано в этот спринт-цикл, но отложено)

- **Moderator roles** (user / moderator / admin) — сейчас flat в `admin_user`. Добавить role enum + permission middleware когда появится >1 модератора
- **Multi-moderator conflict resolution** — lock / optimistic concurrency на Menu validator. Сейчас single-moderator (только автор проекта)
- **B2B restaurant claim flow** — `partners.menuassistant.app` отдельный frontend, `restaurant.claimedBy: AdminUser?` поле. Sprint 6+
- **Dish confidence scoring** — добавить `confidence: int` в Claude JSON schema + `menu_item.confidence`. Будет видно какие блюда priority-review, когда moderator workflow появится

---

## Критические файлы для следующих спринтов

### Sprint 4.6 — Design Foundation + Restaurant dedup

- Новое: `design/tokens/tokens.json`, `design/tokens/generate.mjs`, `design/tokens/tokens.css`
- Новое: `MenuAssistant/menu_assistant_flutter/lib/theme/tokens.dart`, `typography.dart`
- Новое: `MenuAssistant/menu_assistant_flutter/assets/fonts/Fraunces*.ttf`, `Inter*.ttf`, `JetBrainsMono*.ttf`
- [main.dart](MenuAssistant/menu_assistant_flutter/lib/main.dart) — замена blueGrey seedColor на новую тему
- [pubspec.yaml](MenuAssistant/menu_assistant_flutter/pubspec.yaml) — секция fonts
- [restaurant.spy.yaml](MenuAssistant/menu_assistant_server/lib/src/models/restaurant.spy.yaml) — перестройка, удаление userId, добавление geo fields + pg_trgm index
- Новое: `MenuAssistant/menu_assistant_server/lib/src/models/user_restaurant_visit.spy.yaml`
- Новое: `MenuAssistant/menu_assistant_server/lib/src/models/menu_source_page.spy.yaml`
- Новое: `MenuAssistant/menu_assistant_server/lib/src/services/restaurant/restaurant_dedup_service.dart`
- Новое: `MenuAssistant/menu_assistant_server/lib/src/services/geo/ip_geo_service.dart`
- Новое: `MenuAssistant/menu_assistant_server/lib/src/future_calls/db_ip_update_future_call.dart`
- [claude_llm_service.dart](MenuAssistant/menu_assistant_server/lib/src/services/llm/claude_llm_service.dart) — multi-image content support

### Sprint 4.7 — Flutter redesign

- **Удалить**: `greetings_screen.dart`, `settings_screen.dart`
- **Merge**: `auth_screen.dart` + `sign_in_screen.dart` → `auth_screen.dart` (один экран)
- **Redesign** все: `home_screen.dart`, `restaurant_screen.dart`, `menu_item_screen.dart`, `account_screen.dart`, `favorite_restaurants_screen.dart`, `favorite_dishes_screen.dart`, `widgets/add_menu_bottom_sheet.dart`
- **Новое**: `lib/screens/onboarding_screen.dart`, `lib/screens/empty_home_screen.dart`, `lib/screens/match_confirmation_dialog.dart`
- **Новое**: `lib/widgets/primary_button.dart`, `accent_button.dart`, `ghost_button.dart`, `app_input.dart`, `app_chip.dart`, `photo_placeholder.dart`, `allergen_badge.dart`, `accent_fab.dart`, `app_bottom_sheet.dart`, `lang_dropdown.dart`
- **Новое**: `lib/l10n/app_*.arb` (7 files)
- [restaurant_repository.dart](MenuAssistant/menu_assistant_flutter/lib/repositories/restaurant_repository.dart) — multi-page upload, match confirmation flow
- [app_state.dart](MenuAssistant/menu_assistant_flutter/lib/core/app_state.dart) — geo permission state

### Sprint 4.8 — Landing

- Новая папка в корне репо: `landing/` (Astro проект)
- Ключевые: `landing/src/pages/index.astro`, `landing/src/components/Polyglot.astro`, `landing/src/content/i18n.json`
- Build artifact: `MenuAssistant/menu_assistant_server/web/pages/landing/` (generated, в .gitignore)
- [server.dart](MenuAssistant/menu_assistant_server/lib/server.dart) — StaticRoute для `web/pages/landing`

### Sprint 4.9 — Admin (отдельный сайт)

- Новая папка в корне репо: `admin/` (Next.js проект)
- Новое: `MenuAssistant/menu_assistant_server/lib/src/models/admin_user.spy.yaml`, `audit_log.spy.yaml`
- Новое: `MenuAssistant/menu_assistant_server/lib/src/endpoints/admin_endpoint.dart` (+ middleware `requireAdminAccess`)
- Новое: `MenuAssistant/menu_assistant_server/lib/src/services/audit/audit_service.dart`
- Cloudflare Access config (terraform или ручной setup в dashboard)

### Sprint 4.10 — Curated Candidate Promotion

- Новое: `MenuAssistant/menu_assistant_server/lib/src/models/curated_dish_candidate.spy.yaml`
- Новое: `MenuAssistant/menu_assistant_server/lib/src/services/curated/curated_candidate_aggregator_service.dart`
- Новое: `MenuAssistant/menu_assistant_server/lib/src/services/curated/candidate_enrichment_service.dart` (общий для bin-скриптов + future call)
- Новое: `MenuAssistant/menu_assistant_server/lib/src/future_calls/curated_candidate_aggregator_future_call.dart`
- Новое: `MenuAssistant/menu_assistant_server/lib/src/future_calls/candidate_enrichment_future_call.dart`
- [admin_endpoint.dart](MenuAssistant/menu_assistant_server/lib/src/endpoints/admin_endpoint.dart) — новые методы `candidates.{list,approve,merge,reject,split}`
- **Рефактор**: `bin/generate_descriptions.dart`, `bin/generate_images.dart`, `bin/generate_translations.dart`, `bin/enrich_from_wikidata.dart` — извлечь общую логику в `CandidateEnrichmentService`
- [service_registry.dart](MenuAssistant/menu_assistant_server/lib/src/service_registry.dart) — зарегистрировать aggregator + enrichment service
- Новое (admin UI): `admin/app/candidates/page.tsx`, `admin/components/CandidateRow.tsx`, `admin/components/CandidateDetailDrawer.tsx`

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
