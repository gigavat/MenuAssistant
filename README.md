# MenuAssistant

B2C меню-ассистент: фото меню → распознанная/переведённая/иллюстрированная карта блюд за ~20 секунд.

Монорепо из пяти частей:

| Часть | Стек | Port | Назначение |
|---|---|---|---|
| `MenuAssistant/menu_assistant_server` | Serverpod 3.4 / Dart | 8080 / 8081 / 8082 | Основной backend: auth, menus, dishes |
| `MenuAssistant/menu_assistant_flutter` | Flutter | — | Client app (iOS / Android / Windows / Web) |
| `admin/` | Next.js 16 + Tailwind 4 + shadcn | 3000 | Moderation panel (Sprint 4.9) |
| `ImageService/` | .NET 10 | 5131 / 7295 | Хранение curated-изображений (S3 в prod) |
| `InferenceService/` | Python / FastAPI / SDXL | 8000 | Local GPU генерация картинок (Windows native) |

**Инфра (docker)** — Postgres + Redis для dev и test, см. `MenuAssistant/menu_assistant_server/docker-compose.yaml`:

| Сервис | Host-port |
|---|---|
| postgres (dev) | 8090 |
| redis (dev) | 8091 |
| postgres (test) | 9090 |
| redis (test) | 9091 |

---

## Быстрый старт

Нужны запущенными одновременно только три вещи для повседневной разработки:

1. **Docker** — Postgres + Redis (всегда в фоне, startup `docker compose up -d`)
2. **Serverpod** — API на 8080
3. **Flutter** или **admin** — клиент, над которым сейчас работаешь

`ImageService` и `InferenceService` стартуют только когда нужны фичи, которые от них зависят (см. секции ниже).

---

## 1. Docker (Postgres + Redis)

```powershell
cd MenuAssistant/menu_assistant_server
docker compose up -d            # старт в фоне
docker compose ps               # статус
docker compose logs -f postgres # логи
docker compose down             # остановка (данные сохраняются в volume)
docker compose down -v          # остановка + удаление volume (сбросить БД)
```

Пароли Postgres/Redis — в `MenuAssistant/menu_assistant_server/.env` (не коммитится).

---

## 2. Serverpod backend

**Установка** (один раз):

```powershell
cd MenuAssistant/menu_assistant_server
dart pub get
dart pub global activate serverpod_cli
```

**Применить миграции:**

```powershell
dart bin/main.dart --apply-migrations --role maintenance
```

**Сгенерировать код** после изменений в `*.spy.yaml` или `endpoints/*.dart`:

```powershell
serverpod generate
```

**Запуск** (dev, с admin-байпасом для локальной admin-панели):

```powershell
$env:ADMIN_DEV_BYPASS = "true"; dart bin/main.dart
```

- `8080` — API endpoint (`/admin/*`, `/restaurant/*`, `/aiProcessing/*`, …)
- `8081` — Serverpod Insights (stats / future-calls)
- `8082` — WebServer (`/static/*`, `/app/*`)

**`ADMIN_DEV_BYPASS=true`** — dev-флаг, позволяющий admin UI авторизоваться через query param `?_adminEmail=...` вместо реального Cloudflare Access header (в prod будет CF JWT). Без флага admin endpoints вернут 500 «missing identity header». См. `lib/src/endpoints/admin_endpoint.dart`.

**Остановка:** `Ctrl+C` в окне терминала (отпускает 8080/8081/8082).

---

## 3. Flutter client

**Установка:**

```powershell
cd MenuAssistant/menu_assistant_flutter
flutter pub get
```

**Запуск (десктоп Windows — самый быстрый dev-цикл):**

```powershell
flutter run -d windows
```

**Запуск (веб):**

```powershell
flutter run -d chrome --web-port 5000
```

**Запуск (iOS / Android)** — нужен подключённый эмулятор:

```powershell
flutter devices                   # список
flutter run -d <device-id>
```

**Проверки:**

```powershell
flutter analyze                   # lint
flutter test                      # unit + widget tests
```

**Остановка:** `Ctrl+C` в терминале + закрыть окно приложения.

---

## 4. Admin panel (Next.js)

Требует Node 20+ и pnpm.

**Установка** (один раз):

```powershell
cd admin
pnpm install
```

**Конфиг** — файл `.env.local` (уже создан):

```
NEXT_PUBLIC_SERVERPOD_URL=http://localhost:8080
NEXT_PUBLIC_ADMIN_DEV_EMAIL=<email из таблицы admin_user>
```

Чтобы добавить себя в admin (один раз):

```powershell
docker exec menu_assistant_server-postgres-1 psql -U postgres -d menu_assistant -c "INSERT INTO admin_user (email, role, \`"invitedAt\`") VALUES ('you@example.com', 'admin', NOW()) ON CONFLICT (email) DO NOTHING;"
```

**Dev-сервер:**

```powershell
pnpm dev                          # http://localhost:3000, HMR
```

**Production-сборка / проверки:**

```powershell
pnpm lint
pnpm build                        # .next/ + static prerendering
pnpm start                        # запустить production build на :3000
```

**Остановка:** `Ctrl+C` в терминале.

---

## 5. ImageService (.NET)

Нужен только при работе с curated-картинками или prod-like image upload flow. В повседневном dev-цикле Serverpod использует `LocalFileImagePersistence` (файлы в `web/static/images/curated`) и сервис не требуется.

**Запуск:**

```powershell
cd ImageService/ImageService.Api
dotnet run
```

- `5131` — HTTP API
- `7295` — HTTPS (dev certificate)

**Остановка:** `Ctrl+C`.

---

## 6. InferenceService (Python / SDXL)

Нужен только для локальной генерации изображений через SDXL (remote GPU машина). На dev-машине обычно не запускается.

См. [InferenceService/README.md](InferenceService/README.md) — там описано как на Windows-native (без Docker):

```powershell
cd InferenceService
.\setup_windows.ps1               # первый раз: venv + requirements
.\run_windows.ps1                 # старт uvicorn на :8000
```

**Остановка:** `Ctrl+C`.

---

## Освобождение портов / остановка всего

Если где-то зависли сервисы и нужно быстро освободить порты (типичный случай — `8080 is already in use` при повторном запуске Serverpod).

### PowerShell — найти процесс на порту

```powershell
# Кто держит 8080?
Get-NetTCPConnection -LocalPort 8080 -State Listen |
  Select-Object LocalPort,OwningProcess,@{n='Process';e={(Get-Process -Id $_.OwningProcess).ProcessName}}

# Убить по PID
Stop-Process -Id <pid> -Force
```

### PowerShell — прибить всех `dart`, `node`, `dotnet` и докер

```powershell
# Завершить все dart / dartvm процессы (Serverpod, Flutter)
Get-Process dart,dartvm -ErrorAction SilentlyContinue | Stop-Process -Force

# Завершить все node процессы (Next.js dev, pnpm)
Get-Process node -ErrorAction SilentlyContinue | Stop-Process -Force

# Завершить все dotnet (ImageService)
Get-Process dotnet -ErrorAction SilentlyContinue | Stop-Process -Force

# Остановить docker-контейнеры (Postgres, Redis)
cd MenuAssistant/menu_assistant_server; docker compose down
```

### Git Bash — одной командой

```bash
# Из корня репо
taskkill //F //IM dart.exe //IM dartvm.exe //IM node.exe //IM dotnet.exe 2>/dev/null
cd MenuAssistant/menu_assistant_server && docker compose down
```

### Проверить что всё свободно

```powershell
netstat -ano | Select-String ":8080|:8081|:8082|:3000|:5131|:8000" | Select-String "LISTENING"
# пустой вывод = всё свободно
```

---

## Типичные рабочие сценарии

### Работаю над Flutter client'ом

1 терминал: `cd MenuAssistant/menu_assistant_server; $env:ADMIN_DEV_BYPASS="true"; dart bin/main.dart`
2 терминал: `cd MenuAssistant/menu_assistant_flutter; flutter run -d windows`

### Работаю над admin-панелью

1 терминал: `cd MenuAssistant/menu_assistant_server; $env:ADMIN_DEV_BYPASS="true"; dart bin/main.dart`
2 терминал: `cd admin; pnpm dev` → открыть http://localhost:3000

### Меняю схему БД / endpoint

```powershell
cd MenuAssistant/menu_assistant_server
# отредактировать *.spy.yaml или endpoints/*.dart
serverpod generate
serverpod create-migration
dart bin/main.dart --apply-migrations --role maintenance
# потом запустить Serverpod как обычно
```

### Сбросить БД к чистому состоянию

```powershell
cd MenuAssistant/menu_assistant_server
docker compose down -v            # удаляет volume
docker compose up -d
dart bin/main.dart --apply-migrations --role maintenance
# если нужен dataset — dart bin/import_curated_dataset.dart
```

---

## Документация

- [ROADMAP.md](ROADMAP.md) — спринты и планы
- [DATASET_DESIGN.md](DATASET_DESIGN.md) — как собирается curated dish dataset
- [design/README.md](design/README.md) — design system / tokens
- [ImageService/README.md](ImageService/README.md) — image storage API
- [InferenceService/README.md](InferenceService/README.md) — SDXL deployment notes
