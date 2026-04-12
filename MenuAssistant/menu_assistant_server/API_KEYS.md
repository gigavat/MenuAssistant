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
| fal.ai (Flux 2) | Генерация фото если стока нет       | $1 кредит при регистрации| ~$0.008/изображение   | Опционально|
| Spoonacular     | Ингредиенты, пищевая ценность       | 150 req/день             | от $29/мес            | Опционально|
| Wikidata        | Описания блюд (бесплатный fallback) | без ключа, без лимита    | —                     | Не нужен   |

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

## 4. fal.ai Flux 2 (опционально)

**Что делает**: генерирует AI-изображение блюда когда ни Unsplash, ни Pexels
не нашли подходящего фото. Гарантирует, что у каждого блюда есть картинка.

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

## 5. Spoonacular (опционально, для async обогащения)

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

## 6. Wikidata (бесплатно, ключ не нужен)

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
