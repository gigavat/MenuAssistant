# Получение API ключей для MenuAssistant

Этот документ описывает все внешние сервисы, используемые сервером, и как
получить ключи. Все ключи сохраняются в `config/passwords.yaml` под секцией
`shared:` (или конкретного окружения, если хочется разные значения для
dev/staging/production).

> **Важно**: `config/passwords.yaml` содержит секреты и **не должен** попадать
> в git. Убедитесь, что он в `.gitignore`.

> **Цены и лимиты ниже актуальны на момент написания (апрель 2026)** и могут
> меняться. Перед запуском в production проверьте текущие тарифы на сайтах
> провайдеров.

---

## Сводная таблица

| Сервис          | Назначение                          | Бесплатный лимит         | Платный план          | Обязателен |
|-----------------|-------------------------------------|--------------------------|-----------------------|------------|
| Anthropic Claude (Haiku 4.5) | Распознавание меню (vision LLM) | $5 кредит при регистрации| ~$0.008/меню          | **Да**     |
| Unsplash        | Поиск стоковых фото блюд            | 50 req/час (demo), 5000 req/час (prod) | бесплатно | Желательно |
| Pexels          | Резерв для Unsplash                 | 200 req/час, 20K/месяц   | бесплатно             | Желательно |
| **InferenceService** (self-hosted) | Генерация фото через SDXL/Flux на своём GPU | — | Electricity only (~€0.0001/img) | **Да для Sprint 4.5** |
| fal.ai (Flux 2) | Fallback cloud generation если InferenceService недоступен | $1 кредит при регистрации| ~$0.008/изображение | Опционально (backup) |
| TheMealDB       | Bootstrap curated dataset (Sprint 4.5) | free test key | $25 one-time supporter key (commercial) | Да для Sprint 4.5 |
| Wikidata        | Описания блюд + multilingual labels | без ключа, без лимита    | —                     | Не нужен   |
| Wikimedia Commons | Commercial-legal food images (CC0/CC BY) | без ключа, либеральный rate limit | — | Не нужен |
| USDA FoodData Central | Nutrition facts (Sprint 5+ опционально) | 1000 req/hour | — | Не нужен |
| ~~Spoonacular~~ | ~~Ингредиенты, питание~~ | — | ~~от $29/мес~~ | **НЕ используем** (termination clause risk) |

**Минимум для рабочего MVP**: только `anthropicApiKey`. Сервер автоматически
fallback'ает на `MockLlmService` если ключ пустой, поэтому без него тоже
запускается, но получаешь захардкоженное португальское меню вместо реального
распознавания.

---

## 1. Anthropic Claude (обязательно)

**Что делает**: распознаёт меню с фото/PDF/URL через vision-модель Claude Haiku 4.5
и возвращает структурированный JSON с ресторанами, категориями и блюдами.

### Получение ключа

1. Открыть [console.anthropic.com](https://console.anthropic.com/)
2. Зарегистрироваться (email/Google). Получаешь $5 бесплатных кредитов.
3. **Settings → API Keys → Create Key**, выбрать workspace `Default`
4. Скопировать ключ (`sk-ant-api03-...`) — показывается **только один раз**
5. Положить в `config/passwords.yaml`:
   ```yaml
   shared:
     anthropicApiKey: 'sk-ant-api03-...'
   ```

### Цены и лимиты

- **Модель**: `claude-haiku-4-5-20251001` (используется в `ClaudeLlmService`)
- **Input**: $1.00 / 1M токенов
- **Output**: $5.00 / 1M токенов
- **Vision**: ~1,500 токенов на одну фотографию меню (при `max_tokens: 4096`)
- **Стоимость одного меню**: ~$0.005–0.01 в зависимости от размера меню
- **Rate limit (Tier 1)**: 50 RPM, 50,000 ITPM, 10,000 OTPM — поднимается
  автоматически по мере накопления потраченной суммы

### Важно про "подписку Claude Pro"

Подписка на claude.ai ($20/мес для веб-интерфейса) **не даёт доступа к API**.
API оплачивается отдельно по pay-as-you-go через консоль. Привязка карты
обязательна после исчерпания стартового кредита.

### Документация

- [API reference](https://docs.anthropic.com/en/api/messages)
- [Pricing](https://www.anthropic.com/pricing#api)
- [Rate limits](https://docs.anthropic.com/en/api/rate-limits)

---

## 2. Unsplash (желательно)

**Что делает**: ищет реальные стоковые фото блюд. Используется как первичный
источник изображений.

### Получение ключа

1. Открыть [unsplash.com/developers](https://unsplash.com/developers) и завести
   аккаунт
2. **Your apps → New Application**, принять API guidelines
3. Заполнить название и описание приложения (можно `MenuAssistant`,
   "Restaurant menu helper")
4. Скопировать **Access Key** (поле "Access Key", не Secret Key)
5. Положить в `passwords.yaml`:
   ```yaml
   shared:
     unsplashAccessKey: 'AbCdEfGh...'
   ```

### Цены и лимиты

- **Demo tier** (по умолчанию после регистрации): **50 запросов/час**
- **Production tier** (после ручной модерации заявки): **5000 запросов/час**
  - Чтобы перевести приложение в production, нужно отправить пример работы
    приложения через форму "Apply for Production"
- **Бесплатно навсегда**, никаких платных тарифов

### Требования к атрибуции

Unsplash требует подписи под каждым фото в формате:

> Photo by [Author Name](author_link) on [Unsplash](https://unsplash.com)

В коде это уже сделано — `UnsplashImageSearchService` сохраняет
`attribution` и `attributionUrl` в `dish_image`.

### Документация

- [API docs](https://unsplash.com/documentation)
- [Guidelines](https://help.unsplash.com/en/articles/2511245-unsplash-api-guidelines)

---

## 3. Pexels (желательно)

**Что делает**: альтернативный источник стоковых фото. Используется как fallback
если Unsplash достиг rate limit.

### Получение ключа

1. Открыть [pexels.com/api](https://www.pexels.com/api/), залогиниться (email/Google)
2. **Get Started → Your API Key** — ключ выдаётся сразу, без модерации
3. Положить в `passwords.yaml`:
   ```yaml
   shared:
     pexelsApiKey: '563492ad6f917000010000...'
   ```

### Цены и лимиты

- **200 запросов/час**
- **20,000 запросов/месяц**
- Если нужны лимиты выше — связаться с support@pexels.com (бесплатно для
  большинства use cases)
- **Бесплатно навсегда**

### Атрибуция

Не требуется, но желательна. В коде уже сохраняется (`Photo by X on Pexels`).

### Документация

- [API docs](https://www.pexels.com/api/documentation/)

---

## 4. InferenceService (self-hosted, обязателен для Sprint 4.5)

**Что делает**: self-hosted Python микросервис (FastAPI + SDXL) на удалённой
GPU машине. Генерирует food photos через text-to-image без API cost,
rate limits или зависимости от cloud providers. Заменяет fal.ai / BFL для
bootstrap и live fallback generation.

### Требования для развёртывания

- **Железо**: машина с NVIDIA GPU ≥8GB VRAM (рекомендуется 12GB+). Текущий
  target — Ryzen 5950x + RTX 3080 Ti 12GB + 64GB RAM
- **OS**: Linux (Ubuntu 22.04+ рекомендуется) или Windows с WSL2
- **Software**:
  - NVIDIA Driver ≥535
  - CUDA 12.1+
  - **Вариант A (рекомендую)**: Docker + NVIDIA Container Toolkit
  - **Вариант B**: Python 3.11+ + systemd
- **Диск**: ≥20GB свободно (модели ~10GB + Docker + buffer)
- **Сеть**: способ добраться из Serverpod dev laptop (LAN, SSH tunnel, Tailscale, VPN)

### Deployment (кратко)

```bash
# На remote GPU машине
cd InferenceService
echo "INFERENCE_SERVICE_SECRET=$(openssl rand -hex 32)" > .env
docker compose up -d --build

# Первый pull моделей (одноразовый, ~10GB)
# Автоматически при первом image request

# Проверка
curl http://localhost:8000/health
# → {"status": "ok"}

curl http://localhost:8000/models \
  -H "Authorization: Bearer <secret>"
# → {"available": [...], "loaded": "sdxl", "gpu": "RTX 3080 Ti"}
```

Детальная инструкция + архитектура — [`DATASET_DESIGN.md`](../../DATASET_DESIGN.md) секция "InferenceService".

Код сервиса — [`InferenceService/`](../../InferenceService/) в корне монорепо.

### Сеть: Keenetic KeenDNS reverse proxy

GPU машина за роутером Keenetic. Keenetic выдаёт HTTPS URL через
KeenDNS (`yourname.keenetic.pro`) с auto Let's Encrypt и
форвардит на `http://<gpu-lan-ip>:8000`.

**Настройка**: KeenDNS → домен + port forwarding 443 → gpu-ip:8000.
Подробности — [DATASET_DESIGN.md](../../DATASET_DESIGN.md#inferenceservice--self-hosted-ml-микросервис).

### Конфигурация в Serverpod

`config/passwords.yaml`:
```yaml
shared:
  # Sprint 4.5: Self-hosted InferenceService (через Keenetic reverse proxy)
  inferenceServiceBaseUrl: 'https://yourname.keenetic.pro'
  inferenceServiceSecret: '<secret из .env на GPU машине>'
```

### Стоимость

- **Setup one-time**: 3-4 часа работы (Docker, model download, test generation)
- **Per image**: ~€0.0001 electricity (~5 sec SDXL inference на 3080 Ti)
- **Bootstrap 5000 images**: ~€1 total electricity
- **API fees**: **$0** — нет rate limits, нет quotas

**Сравнение с cloud API**:
| Provider | Bootstrap 5000 images |
|---|---|
| fal.ai Flux Schnell | ~$40 |
| fal.ai Flux Dev | ~$125 |
| BFL Flux Dev direct | ~$125 |
| Google Vertex Imagen 3 | ~$200 |
| **InferenceService (self-hosted)** | **~€1** |

Однако: **setup time** это инвестиция. Для первого bootstrap окупается
немедленно. Для долгосрочной работы — полный control, zero marginal cost.

### Доступные модели

На старте:
- **SDXL 1.0** (Stability AI, default) — ~8GB VRAM, 5 sec/img, good quality

Опционально для качества:
- **Flux.1 Schnell NF4** — ~7GB VRAM, 8 sec/img, лучшее качество (4-step inference)
- **Flux.1 Dev NF4** — ~11GB VRAM, 25 sec/img, топ качество (в притык по VRAM)

Модели меняются через переменную `DEFAULT_MODEL` в `.env` или параметр
`model` в каждом запросе к `/generate/image`.

### Troubleshooting

**CUDA out of memory**:
- Уменьшить resolution (1024→768)
- Переключиться на меньшую модель (SDXL → SD 1.5)
- Закрыть другие GPU processes
- Перезапустить сервис (VRAM fragmentation)

**Первый запрос очень медленный (30+ сек)**:
- Нормально, это cold start — модель загружается в VRAM
- Warm requests ~5 сек

**"Model not found" при первом запуске**:
- Модели скачиваются с Hugging Face при первом use
- Проверить интернет на GPU машине + disk space
- Можно предзагрузить manually через `huggingface-cli download stabilityai/stable-diffusion-xl-base-1.0`

### Документация

- Код: [InferenceService/](../../InferenceService/)
- Архитектура: [DATASET_DESIGN.md секция "InferenceService"](../../DATASET_DESIGN.md#inferenceservice--self-hosted-ml-микросервис)
- [Diffusers library docs](https://huggingface.co/docs/diffusers/index)

---

## 5. fal.ai Flux 2 (backup fallback)

**Что делает**: cloud-based генерация AI-изображений. В Sprint 4.5 заменён
**InferenceService** (см. выше). Оставлен как **опциональный backup** если
self-hosted сервис недоступен (перебои с GPU машиной, сетью).

### Получение ключа

1. Открыть [fal.ai](https://fal.ai/) и залогиниться (Google/GitHub)
2. **Dashboard → API Keys → Add Key**
3. Скопировать ключ (формата `b1d2e3f4-...:abc123...`)
4. Положить в `passwords.yaml`:
   ```yaml
   shared:
     falAiApiKey: 'b1d2e3f4-...:abc123...'
   ```
5. Привязать карту в **Billing** для использования платных моделей (Flux 2
   платный, бесплатные кредиты ~$1 при регистрации)

### Цены и лимиты

- **Flux 2** (через `fal-ai/flux-2/text-to-image`): **~$0.008 за изображение**
  (square_hd, ~1024×1024)
- При регистрации даётся $1 стартовый кредит (~125 изображений)
- Pay-as-you-go, минимальный депозит $5
- Rate limit зависит от тарифа, для базового — десятки запросов в минуту

### Альтернативы

Если fal.ai недоступен, можно подменить на:
- `together.ai` — есть Flux Schnell за $0.003/img
- `replicate.com` — Flux Dev за $0.025/img
- `stability.ai` — Stable Diffusion 3 Medium за $0.035/img

Реализация в `lib/src/services/image_search/fal_ai_image_service.dart`,
интерфейс `ImageSearchService` — переписать под другого провайдера легко.

### Документация

- [Flux 2 model page](https://fal.ai/models/fal-ai/flux-2)
- [API docs](https://docs.fal.ai/)

---

## 6. ⚠️ Spoonacular (НЕ используем — termination clause)

**Что делает**: предоставляет ингредиенты, пищевую ценность, аллергены, рецепты.
Используется в фоновом enrichment worker'е (пока не реализован — Sprint 4).

### Получение ключа

1. Открыть [spoonacular.com/food-api](https://spoonacular.com/food-api)
2. **Start Now → Sign Up**, выбрать тариф (есть Free)
3. **My Console → Profile → API Key**
4. Положить в `passwords.yaml`:
   ```yaml
   shared:
     spoonacularApiKey: 'aBcDeF1234567890...'
   ```

### Цены и лимиты

| План       | Цена/мес | Точек/день | Точек/секунду |
|------------|----------|------------|---------------|
| Free       | $0       | 150        | 1             |
| Cook       | $29      | 1500       | 5             |
| Culinarian | $79      | 5000       | 5             |
| Chef       | $149     | 12500      | 5             |

**"Точки"** — внутренняя единица; один запрос на дешёвый endpoint = 1 точка,
сложный (рецепт + ingredients + nutrition) = до 5 точек.

### Документация

- [API docs](https://spoonacular.com/food-api/docs)
- [Pricing](https://spoonacular.com/food-api/pricing)

---

## 7. ⛔ Локальный Unsplash dataset (Sprint 4 отменён — см. ROADMAP)

**Что делает**: pre-built индекс из 25K фотографий Unsplash Lite dataset,
отфильтрованных по food-related ключевым словам. Стоит первым в цепочке
image providers — для типовых блюд (паста, бургер, салат...) ответ за ~5–50ms
без обращения к Unsplash API. Для экзотики цепочка fallback'ает на Unsplash
API → Pexels → fal.ai.

### Ключ не нужен

Lite dataset публичен и [распространяется по лицензии Unsplash](https://github.com/unsplash/datasets#documentation),
которая разрешает коммерческое использование метаданных. URL фотографий
ведут на Unsplash CDN — мы только хотлинкуем, не кешируем байты.

### Установка датасета

1. Скачать архив:
   ```bash
   curl -L -o unsplash-lite.zip \
     https://unsplash.com/data/lite/latest
   ```
   ~650 MB. Можно скачать и вручную с [github.com/unsplash/datasets](https://github.com/unsplash/datasets).

2. Распаковать в любую директорию:
   ```bash
   unzip unsplash-lite.zip -d /tmp/unsplash-lite/
   ```
   Внутри будут файлы `photos.tsv000`, `keywords.tsv000`, `collections.tsv000`,
   `colors.tsv000`, `conversions.tsv000`.

3. Импортировать в Postgres (требует уже применённой миграции с
   `unsplash_local_photo`):
   ```bash
   cd MenuAssistant/menu_assistant_server
   dart run bin/import_unsplash_dataset.dart /tmp/unsplash-lite/
   ```

   Скрипт:
   - Парсит `keywords.tsv` и оставляет фото у которых хотя бы один тег
     совпадает с food-whitelist (≈80 ключевых слов: food, pizza, burger,
     pasta, dish, meat, fish, vegetable, dessert, ...)
   - Из 25K фото остаётся ~3–7K food-фото
   - Bulk-вставляет их в `unsplash_local_photo` батчами по 500
   - Обычно занимает 30–90 секунд

4. Перезапустить Serverpod сервер (если он работает) — `LocalUnsplashImageSearchService`
   подхватит наполненную таблицу автоматически.

### Re-import при обновлении датасета

Unsplash обновляет Lite dataset раз в несколько месяцев. Чтобы подхватить
новые фотографии:

```bash
dart run bin/import_unsplash_dataset.dart /tmp/unsplash-lite/
```

Скрипт идемпотентен: существующие записи (по `unsplashId`) перезаписываются.

### Цены и лимиты

- **0 запросов в Unsplash API** — никаких лимитов
- **0 хранения** платных байтов — только метаданные ~5–10 MB в Postgres
- **Latency**: 5–50ms на запрос (sequential scan по ~5–10K строк)
- **Атрибуция обязательна** — в `dish_image.attribution` сохраняется
  "Photo by X on Unsplash" со ссылкой на автора

### Lite vs Full dataset

- **Lite**: 25K фото, **commercial OK**, ~650 MB, обновляется
- **Full**: 6.5M+ фото, **только non-commercial research**, десятки GB

Для нашего SaaS подходит **только Lite**. Full использовать нельзя по
лицензии.

### Документация

- [Datasets repo](https://github.com/unsplash/datasets)
- [Lite license](https://github.com/unsplash/datasets/blob/master/DOCS.md)

---

## 8. Wikidata (бесплатно, ключ не нужен)

**Что делает**: выдаёт короткие описания блюд через MediaWiki API.
Используется как первичный источник в `WikidataService`, перед обращением
к Claude для генерации описаний.

- **Без ключа**, без лимитов (рекомендуется User-Agent заголовок — уже добавлен)
- API: `https://www.wikidata.org/w/api.php?action=wbsearchentities`

### Документация

- [API docs](https://www.wikidata.org/w/api.php?action=help&modules=wbsearchentities)
- [Etiquette](https://www.mediawiki.org/wiki/API:Etiquette)

---

## Применение ключей

После того как все нужные ключи добавлены в `config/passwords.yaml`:

1. **Перезапустить Serverpod сервер** (`Ctrl+C` и снова `dart bin/main.dart`)
2. При старте `_configureServices` в `lib/server.dart` прочитает ключи
   через `pod.getPassword(...)` и зарегистрирует соответствующие сервисы
3. Если ключ пустой/отсутствует — соответствующий сервис **просто пропускается**:
   - `anthropicApiKey` пуст → используется `MockLlmService` (захардкоженное меню)
   - `unsplashAccessKey` пуст → Unsplash не пробуется, сразу Pexels
   - и т.д.

Это позволяет постепенно добавлять провайдеры без поломки сервера.

## Безопасность

- `config/passwords.yaml` **никогда не коммитить в git**
- Для CI/CD использовать переменные окружения через секретный store
  (GitHub Secrets, AWS Secrets Manager) и шаблонизировать `passwords.yaml`
  при деплое
- Ротировать ключи раз в несколько месяцев (особенно Anthropic — там pay-per-use)
- Для production окружения настроить отдельные ключи (секция `production:` в
  `passwords.yaml` вместо `shared:`)
