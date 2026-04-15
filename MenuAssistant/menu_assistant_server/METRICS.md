# Observability и метрики MenuAssistant

Этот документ описывает, что и где записывается сервером, какие SQL-запросы
использовать для быстрой диагностики и как расширять метрики при
необходимости. Актуально после Sprint 3 (AI + Dish Catalog).

---

## Что уже записывается автоматически

### 1. `dish_provider_status` — попытки провайдеров обогащения

**Что пишет**: каждая попытка обогащения блюда через Wikidata, Unsplash,
Pexels, fal.ai, Spoonacular. Финальный статус (`success`/`failed`/
`rate_limited`/`pending`), число попыток, сообщение об ошибке, время
следующего ретрая.

**Источник**: [dish_catalog_service.dart](lib/src/services/enrichment/dish_catalog_service.dart)
`_recordProvider()` + [enrichment_worker_future_call.dart](lib/src/future_calls/enrichment_worker_future_call.dart).

### 2. `dish_image` — что в итоге получено

**Что пишет**: каждая сохранённая в каталоге картинка с указанием источника
(`source = unsplash_local | unsplash | pexels | fal_ai | ...`), автор для
атрибуции, флаг `isPrimary`, `lastCheckedAt` от health-check worker.

### 3. `dish_catalog` — общий реестр блюд

**Что пишет**: нормализованное имя, описание, `enrichmentStatus`
(`partial`/`full`), timestamps.

### 4. `serverpod_session_log` — каждый endpoint-вызов

**Что пишет**: `endpoint`, `method`, `duration` (мс), `numQueries`,
`authenticatedUserId`, время. Включается флагом `sessionLogs.persistentEnabled`
в [config/development.yaml](config/development.yaml) — уже включено.

### 5. `serverpod_query_log` — каждый SQL-запрос

**Что пишет**: текст запроса, `duration`, `numRows`, `sessionLogId` (для
связки с родительским endpoint-вызовом).

### 6. `serverpod_log` — логи через `session.log(...)`

**Что пишет**: свободно-форматные логи с `logLevel` (0=debug .. 4=error) и
опциональным stack trace. Связан с `session_log` через `sessionLogId`.

---

## Готовые SQL-запросы

### Провайдеры обогащения

#### Сводка статусов по каждому провайдеру

```sql
SELECT
  provider,
  status,
  COUNT(*)               AS attempts,
  AVG("attemptCount")    AS avg_retries,
  MAX("lastAttemptedAt") AS last_seen
FROM dish_provider_status
GROUP BY provider, status
ORDER BY provider, status;
```

#### Success rate по провайдерам (% успешных от всех попыток)

```sql
SELECT
  provider,
  COUNT(*) FILTER (WHERE status = 'success')      AS success,
  COUNT(*) FILTER (WHERE status = 'failed')       AS failed,
  COUNT(*) FILTER (WHERE status = 'rate_limited') AS rate_limited,
  COUNT(*) FILTER (WHERE status = 'pending')      AS pending,
  ROUND(
    100.0 * COUNT(*) FILTER (WHERE status = 'success') / NULLIF(COUNT(*), 0),
    1
  ) AS success_pct
FROM dish_provider_status
GROUP BY provider
ORDER BY success_pct DESC;
```

#### Последние 20 ошибок — полезно для дебага

```sql
SELECT provider, status, "errorMessage", "lastAttemptedAt"
FROM dish_provider_status
WHERE "errorMessage" IS NOT NULL
ORDER BY "lastAttemptedAt" DESC
LIMIT 20;
```

#### Задачи в очереди на async retry

```sql
SELECT provider, COUNT(*) AS pending_or_rate_limited,
       MIN("nextRetryAt") AS earliest_retry
FROM dish_provider_status
WHERE status IN ('pending', 'rate_limited')
GROUP BY provider;
```

### Endpoint latency и ошибки

#### Latency `aiProcessing` — последние 50 вызовов

```sql
SELECT
  time,
  duration,
  "numQueries",
  "authenticatedUserId"
FROM serverpod_session_log
WHERE endpoint = 'aiProcessing'
ORDER BY time DESC
LIMIT 50;
```

#### Средняя latency по endpoint за последний час

```sql
SELECT
  endpoint,
  method,
  COUNT(*)          AS calls,
  AVG(duration)     AS avg_ms,
  MAX(duration)     AS max_ms,
  SUM("numQueries") AS total_db_queries
FROM serverpod_session_log
WHERE time > NOW() - INTERVAL '1 hour'
GROUP BY endpoint, method
ORDER BY avg_ms DESC;
```

#### Ошибки сервера за сегодня

```sql
SELECT sl.time, sl.endpoint, sl.method, l.message, l."stackTrace"
FROM serverpod_session_log sl
JOIN serverpod_log l ON l."sessionLogId" = sl.id
WHERE l."logLevel" >= 4  -- ERROR
  AND sl.time > CURRENT_DATE
ORDER BY sl.time DESC;
```

### SQL-запросы к базе

#### Топ-10 самых медленных SQL-запросов за последний час

```sql
SELECT
  query,
  duration,
  "numRows",
  time
FROM serverpod_query_log
WHERE time > NOW() - INTERVAL '1 hour'
ORDER BY duration DESC
LIMIT 10;
```

### Каталог блюд и покрытие картинками

#### Сколько блюд обогащено "полностью" vs "частично"

```sql
SELECT
  "enrichmentStatus",
  COUNT(*) AS count
FROM dish_catalog
GROUP BY "enrichmentStatus";
```

#### Покрытие блюд изображениями

```sql
SELECT
  COUNT(DISTINCT dc.id)                                      AS total_dishes,
  COUNT(DISTINCT di."dishCatalogId")                         AS dishes_with_images,
  COUNT(DISTINCT dc.id) - COUNT(DISTINCT di."dishCatalogId") AS dishes_without_images
FROM dish_catalog dc
LEFT JOIN dish_image di ON di."dishCatalogId" = dc.id;
```

#### Распределение источников изображений

```sql
SELECT source,
       COUNT(*)                            AS images,
       COUNT(DISTINCT "dishCatalogId")     AS unique_dishes
FROM dish_image
GROUP BY source
ORDER BY images DESC;
```

Это самый важный отчёт для оценки эффективности кэша: чем больше блюд
получают картинку от `unsplash_local`, тем меньше нагрузка на Unsplash API
и тем быстрее обработка.

#### Broken images обнаруженные health-check worker-ом

```sql
SELECT COUNT(*) FILTER (WHERE "lastCheckedAt" IS NULL)                AS never_checked,
       COUNT(*) FILTER (WHERE "lastCheckedAt" > NOW() - INTERVAL '7 days') AS fresh,
       COUNT(*) FILTER (WHERE "lastCheckedAt" <= NOW() - INTERVAL '7 days') AS stale
FROM dish_image;
```

---

## Как запускать запросы

### Быстрый one-shot

```powershell
docker exec menu_assistant_server-postgres-1 psql -U postgres -d menu_assistant -c "SELECT provider, status, COUNT(*) FROM dish_provider_status GROUP BY provider, status;"
```

### Интерактивная сессия

```powershell
docker exec -it menu_assistant_server-postgres-1 psql -U postgres -d menu_assistant
```

Пример внутри psql:
```
\dt                               -- список таблиц
\d dish_provider_status           -- схема таблицы
SELECT ... ;                      -- запросы
\q                                -- выход
```

### GUI (рекомендую)

Подключи **pgAdmin** или **DBeaver** к:
- Host: `localhost`
- Port: `8090`
- Database: `menu_assistant`
- User: `postgres`
- Password: из [MenuAssistant/menu_assistant_server/.env](.env) → `POSTGRES_PASSWORD`

В GUI удобнее видеть результаты с автообновлением, писать запросы с
автодополнением и сохранять часто-используемые.

---

## Чего НЕ покрывают автоматические метрики

1. **LocalUnsplash hit rate vs Unsplash API** — `dish_provider_status` пишет
   только провайдер, который сработал в финале. Если `unsplash_local` отдал
   картинку, catalog service до `unsplash` API даже не ходил и там записи
   нет. Косвенный индикатор — распределение по `dish_image.source`.

2. **Wikidata** — записывается в `dish_provider_status` с
   `provider='wikidata'`, но только когда Wikidata её зовёт. Если блюдо уже
   было в каталоге, Wikidata не вызывается.

3. **Claude токены и стоимость** — см. отдельную секцию
   [llm_usage ниже](#llm-usage-claude-токены-и-стоимость).

4. **Rate limit Unsplash/Pexels** — приближение лимита видно только по
   `status='rate_limited'` в `dish_provider_status`. Точного "осталось N
   запросов в час" API не возвращают стабильно.

---

## llm_usage — Claude токены и стоимость

Таблица `llm_usage` записывает каждый вызов Claude API с фактическим
числом токенов из поля `usage` ответа Anthropic. Стоимость в USD
вычисляется сразу при записи по ценам Haiku 4.5 ($1/1M input,
$5/1M output, $1.25/1M cache write, $0.10/1M cache read).

### Поля

| Поле | Описание |
|---|---|
| `model` | Идентификатор модели Claude (e.g. `claude-haiku-4-5-20251001`) |
| `operation` | `menu_extraction` или `dish_description` |
| `inputTokens` | Токены ввода (промпт + изображение) |
| `outputTokens` | Токены ответа |
| `cacheCreationTokens` | Токены записанные в prompt cache |
| `cacheReadTokens` | Токены прочитанные из prompt cache |
| `estimatedCostUsd` | Посчитанная стоимость в $ |
| `restaurantId` | Ссылка на ресторан (только для `menu_extraction`) |
| `createdAt` | Время вызова |

### Стоимость за день / месяц

```sql
SELECT
  DATE_TRUNC('day', "createdAt")       AS day,
  operation,
  COUNT(*)                             AS calls,
  SUM("inputTokens")                   AS in_tokens,
  SUM("outputTokens")                  AS out_tokens,
  ROUND(SUM("estimatedCostUsd")::numeric, 4) AS usd_total
FROM llm_usage
WHERE "createdAt" > NOW() - INTERVAL '30 days'
GROUP BY day, operation
ORDER BY day DESC, operation;
```

### Стоимость одной обработки меню (среднее / макс)

```sql
SELECT
  operation,
  COUNT(*)                                  AS calls,
  ROUND(AVG("estimatedCostUsd")::numeric, 5) AS avg_cost_usd,
  ROUND(MAX("estimatedCostUsd")::numeric, 5) AS max_cost_usd,
  ROUND(AVG("outputTokens")::numeric, 0)     AS avg_output_tokens,
  ROUND(MAX("outputTokens")::numeric, 0)     AS max_output_tokens
FROM llm_usage
GROUP BY operation;
```

### Самые дорогие обработки меню (топ-10)

```sql
SELECT
  u."createdAt",
  u."restaurantId",
  r.name              AS restaurant_name,
  u."inputTokens",
  u."outputTokens",
  ROUND(u."estimatedCostUsd"::numeric, 4) AS cost_usd
FROM llm_usage u
LEFT JOIN restaurant r ON r.id = u."restaurantId"
WHERE u.operation = 'menu_extraction'
ORDER BY u."estimatedCostUsd" DESC
LIMIT 10;
```

### Суммарный расход на Claude за всё время

```sql
SELECT
  ROUND(SUM("estimatedCostUsd")::numeric, 2) AS total_usd,
  COUNT(*)                                   AS total_calls,
  SUM("inputTokens" + "outputTokens")        AS total_tokens
FROM llm_usage;
```

---

## Опциональные расширения (на будущее)

### Админ-endpoint со сводкой

Создать `admin.getMetrics()` endpoint, возвращающий агрегированный JSON со
счётчиками. Защищать либо scope-based auth, либо shared secret из
`passwords.yaml`. Можно подцепить к Grafana Simple JSON datasource.

### In-process counters

`ProviderMetricsService` с атомарными счётчиками (reset на рестарт) для
живого view "что сейчас происходит" без походов в SQL. Полезно на
production dashboard.

### Долгосрочно — OpenTelemetry + Grafana

- Serverpod сессии → OTLP exporter → Tempo/Jaeger (traces)
- Prometheus metrics endpoint → Grafana dashboard
- Sentry для перехвата exceptions (server + client)
- PostHog для продуктовых событий (upload, favorite, search)

Для MVP пока рано. Текущие SQL-запросы закрывают 90% потребностей.

---

## Быстрый "health pulse" — одна команда

Удобный комбинированный отчёт для быстрой проверки состояния системы:

```powershell
docker exec menu_assistant_server-postgres-1 psql -U postgres -d menu_assistant <<'SQL'
\echo '=== Dish provider success rates ==='
SELECT provider,
       COUNT(*) FILTER (WHERE status='success') AS ok,
       COUNT(*) FILTER (WHERE status='failed') AS fail,
       COUNT(*) FILTER (WHERE status='rate_limited') AS rl
FROM dish_provider_status GROUP BY provider;

\echo ''
\echo '=== Image source distribution ==='
SELECT source, COUNT(*) FROM dish_image GROUP BY source ORDER BY count DESC;

\echo ''
\echo '=== Recent aiProcessing latency ==='
SELECT ROUND(AVG(duration)::numeric, 0) AS avg_ms,
       ROUND(MAX(duration)::numeric, 0) AS max_ms,
       COUNT(*) AS calls
FROM serverpod_session_log
WHERE endpoint='aiProcessing' AND time > NOW() - INTERVAL '1 day';

\echo ''
\echo '=== Claude usage today ==='
SELECT operation,
       COUNT(*) AS calls,
       ROUND(SUM("estimatedCostUsd")::numeric, 4) AS usd
FROM llm_usage
WHERE "createdAt" > CURRENT_DATE
GROUP BY operation;
SQL
```
