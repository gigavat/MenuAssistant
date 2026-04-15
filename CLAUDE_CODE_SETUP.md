# Claude Code Setup — MCP серверы и плагины

Инструкция по настройке Claude Code для эффективной работы над MenuAssistant.
Актуально на 2026-04-13 (Windows 11, Python 3.13+, uv, Node.js).

---

## Что это и зачем

**MCP (Model Context Protocol)** — стандарт для подключения к Claude Code
внешних инструментов. Серверы MCP расширяют мои возможности: семантический
поиск символов, актуальная документация, прямые SQL запросы, browser
automation и т.д. Без MCP я работаю только через built-in tools
(Read/Write/Bash/Grep/Glob/WebFetch) — этого хватает, но медленнее.

Установленные MCP серверы подцепляются **при старте Claude Code**. После
добавления нового сервера нужен **полный рестарт** окна Claude Code.

---

## Общий процесс установки

1. Скачать/установить сам сервер (обычно через `uvx`, `uv tool install`,
   `npm`, `pipx`)
2. Зарегистрировать в Claude Code через:
   ```powershell
   claude mcp add -s user <name> -- <command> <args...>
   ```
   Флаг `-s user` = глобально (для всех проектов). Без флага = только для
   текущего проекта.
3. Проверить: `claude mcp list` — должно показать `<name>: ... ✓ Connected`
4. **Полностью закрыть Claude Code и открыть заново** — иначе мои tools не
   обновятся

Посмотреть stderr, если не подключается:
```powershell
claude mcp logs <name>
```

Удалить:
```powershell
claude mcp remove <name> -s user
```

Получить полный resolved config для одного сервера:
```powershell
claude mcp get <name>
```

---

## Must-have серверы

### 1. Serena — семантическая навигация кода

**Что даёт**: LSP-backed поиск символов, references, rename, structured
refactoring для Dart + C# + ещё ~20 языков. Намного точнее и дешевле по
контексту, чем `Grep` + `Read` всего файла.

**Зависимости:**
- `uv` ([install](https://docs.astral.sh/uv/getting-started/installation/))
- Git (для `uvx --from git+...`)
- Python 3.11+ (uv поставит сам если нет)
- Dart SDK в PATH (для Dart LSP — уже есть, раз проект билдится)

**Установка:**
```powershell
# 1. Установить Serena как uv tool (быстрее чем uvx --from git каждый раз)
uv tool install --python 3.13 --from git+https://github.com/oraios/serena serena-agent

# 2. Проверить что CLI доступна
serena --help

# 3. Зарегистрировать в Claude Code (user scope → для всех проектов)
claude mcp add -s user serena -- serena start-mcp-server --context ide-assistant --project-from-cwd

# 4. Проверить
claude mcp list
```

**Важно**: флаг `--project-from-cwd` означает, что Serena индексирует
директорию, из которой запущен Claude Code. **Всегда запускай Claude Code
из корня проекта**:
```powershell
cd c:\Users\andre\OneDrive\Desktop\MenuAssistant3
claude
```
Иначе Serena будет сканировать домашнюю папку и ничего релевантного не
найдёт.

**Проверить что я вижу Serena tools**: напиши мне что-нибудь, я вызову
`ToolSearch query="select:mcp__serena__find_symbol"` и попробую
`find_symbol` на реальном классе проекта (например `DishCatalogService`).
Должен вернуть точные file/line координаты, не regex match.

**Типовые проблемы на Windows:**
- `uvx not found` → uv не в PATH, перезапусти PowerShell или добавь `%USERPROFILE%\.local\bin`
- `git not found` → установить [Git for Windows](https://git-scm.com/download/win)
- Долгий первый старт → uv компилирует пакет из git. После `uv tool install` этого больше не будет
- Dashboard открывается при ручном запуске → это нормально, означает Serena работает. В Claude Code режиме stdio дашборд не открывается
- "Failed to connect" в `claude mcp list` но команда работает руками → ты запустил Claude Code **до** регистрации. Полностью закрыть и открыть заново
- OneDrive в пути к проекту → иногда глючит; если всё прочее не помогает, скопируй проект в `C:\dev\MenuAssistant3`

**Python 3.14 warning** про Pydantic V1 — информационный, не фатал. Если
мешает — переустанови с `--python 3.13`.

**Dart / C# language servers:**
- Dart LSP бандлится с Dart SDK — работает если `dart` в PATH
- OmniSharp (C#) ставится отдельно: `dotnet tool install -g omnisharp`

---

### 2. context7 — актуальная документация пакетов

**Что даёт**: вытягивает свежие docs для любой библиотеки в момент запроса.
Для этого проекта особенно полезно: Serverpod 3.4 API часто меняется между
минорами, Flutter/Dart тоже, .NET 10 ещё свежий. Мои training data могут
отставать — context7 подтягивает "здесь и сейчас".

**Зависимости**: Node.js LTS ([nodejs.org](https://nodejs.org/))

**Установка:**
```powershell
claude mcp add -s user context7 -- npx -y @upstash/context7-mcp
```

Первый запуск может тормозить пока `npx` скачивает пакет (~10s). После —
мгновенно.

**Типовые проблемы:**
- `npx not found` → Node.js не установлен или не в PATH
- "Failed to connect" → иногда npm registry недоступен через корпоративный
  прокси; установи `@upstash/context7-mcp` локально через `npm install -g`
  и зарегистрируй без `-y`

---

## Nice-to-have серверы

### 3. postgres — прямые SQL запросы к БД

**Что даёт**: я могу запрашивать БД через типизированный tool вместо
`docker exec ... psql -c`. Особенно полезно для проверки состояния после
миграций, диагностики пользовательских данных, запуска SQL из
[METRICS.md](MenuAssistant/menu_assistant_server/METRICS.md).

**Зависимости**: Node.js

**Установка:**

Пароль возьми из `MenuAssistant/menu_assistant_server/.env` →
`POSTGRES_PASSWORD`.

```powershell
claude mcp add -s user postgres -- npx -y @modelcontextprotocol/server-postgres "postgresql://postgres:ТВОЙ_ПАРОЛЬ@localhost:8090/menu_assistant"
```

**⚠️ Предупреждение о безопасности**: команда с паролем попадёт в
`~/.claude.json` как plaintext. Это нормально для локального user scope
на твоём dev-машине, но:
- **Не коммить** `~/.claude.json` в публичные репозитории
- При смене пароля в `.env` нужно перерегистрировать

Альтернатива — хранить URL в env variable и ссылаться на неё (зависит от
версии MCP клиента).

**Когда пригодится**: Sprint 5 (отладка переводов/валют), Sprint 6
(отладка подписок), любые diagnostics где не хочется каждый раз писать
docker exec.

---

### 4. chrome-devtools — Flutter web debugging

**Что даёт**: управление Chrome DevTools из Claude Code — скриншоты,
network inspection, console errors, live CSS/JS patches. Нужен для
визуальной отладки Flutter web.

**Зависимости**: Node.js + локальный Chrome

**Установка:**
```powershell
claude mcp add -s user chrome-devtools -- npx -y chrome-devtools-mcp
```

**Когда пригодится**: Sprint 5 когда будем делать локализацию UI и
тестировать переводы в разных языках. Sprint 6 — отладка Stripe checkout
flow.

---

### 5. playwright — E2E тесты

**Что даёт**: полноценные E2E сценарии (open app → login → upload menu →
verify dish list). Альтернатива chrome-devtools с более высокоуровневым
API.

**Зависимости**: Node.js + браузеры (`npx playwright install`)

**Установка:**
```powershell
claude mcp add -s user playwright -- npx -y @playwright/mcp
```

**Когда пригодится**: Sprint 6 — интеграционные тесты полного цикла
multi-service. Также полезно для регрессионного тестирования перед
деплоем.

---

## Что НЕ рекомендую ставить

| Сервер | Почему не надо |
|---|---|
| **filesystem** | Уже встроен в Claude Code (Read/Write/Glob) |
| **git** | Уже встроен через Bash |
| **fetch** | Уже встроен через WebFetch |
| **memory** / knowledge-graph | Claude Code уже имеет auto-memory (`~/.claude/projects/*/memory/`) |
| **github** | Только если активно управляешь PR/issues через меня. Для single-developer workflow встроенный `gh` CLI в Bash достаточен |
| **sequential-thinking** | Полезен для сложных reasoning задач, но для обычной разработки оверхед |

---

## Матрица приоритетов для MenuAssistant

| Приоритет | Сервер | Спринт где пригодится |
|---|---|---|
| **Must-have сейчас** | Serena | Постоянно — поиск символов в больших файлах |
| **Must-have сейчас** | context7 | Постоянно — свежие docs Serverpod/Flutter |
| **Nice-to-have** | postgres | Sprint 5+ для диагностики |
| **Sprint 5+** | chrome-devtools | UI localization debugging |
| **Sprint 6** | playwright | E2E tests перед production |

Начни с **Serena + context7** — это универсальный апгрейд. Остальные
добавляй по мере того как появятся соответствующие задачи.

---

## Быстрый чек-лист при установке

После каждой установки:
1. `claude mcp list` — статус всех серверов
2. Если `✗ Failed to connect` — `claude mcp logs <name>` покажет причину
3. **Полностью закрой и открой Claude Code заново**
4. Запусти Claude Code из корня проекта: `cd MenuAssistant3 && claude`
5. Спроси меня "работает ли Serena?" — я проверю доступность tools через
   `ToolSearch`

---

## Обновление серверов

Серверы установленные через `uv tool install` или `uvx --from git+...`
периодически нуждаются в обновлении.

**Serena:**
```powershell
uv tool upgrade serena-agent
```

**Context7 / Postgres / Chrome DevTools / Playwright (npx):**
Автообновление при каждом запуске (флаг `-y` обходит prompt). Но лучше
раз в месяц запустить:
```powershell
npx clear-npx-cache
```

---

## Troubleshooting общих проблем

### "Failed to connect" в `claude mcp list`

1. Проверь что команда работает вручную в PowerShell — скопируй из
   `claude mcp get <name>` вывод
2. Если вручную работает — проблема в environment variables при спавне
   subprocess. Проверь PATH в Claude Code через `echo $env:PATH` из
   bash tool
3. `claude mcp logs <name>` — смотри stderr subprocess
4. Если "command not found" — путь к исполняемому файлу не в PATH из
   под Claude Code. Используй абсолютный путь:
   ```powershell
   claude mcp add -s user serena -- "C:\Users\andre\AppData\Roaming\uv\tools\serena-agent\Scripts\serena.exe" start-mcp-server ...
   ```

### Tools доступны в `claude mcp list`, но не работают из Claude Code

- Claude Code сессия запущена ДО регистрации → полный рестарт
- Проверь что я действительно вижу tool: `ToolSearch` должен найти
  `mcp__<server>__<tool>` когда я его ищу

### Серверы из разных scopes конфликтуют

У Claude Code три scope для MCP:
- **local** — `.mcp.json` в текущей директории (имеет приоритет)
- **project** — `.claude.json` секция `projects.<path>.mcpServers`
- **user** — `.claude.json` секция `mcpServers`

Если у тебя одновременно зарегистрированы серверы с одинаковым именем в
разных scope, применяется самый приоритетный. Чтобы увидеть все — открой
`~/.claude.json` и грепни по имени сервера:
```powershell
Select-String -Path $env:USERPROFILE\.claude.json -Pattern '"serena"'
```

Удалить из конкретного scope:
```powershell
claude mcp remove serena -s local
claude mcp remove serena -s project
claude mcp remove serena -s user
```

---

## Проверка работы Serena (для новой сессии)

После рестарта Claude Code скажи мне: **"проверь Serena на символе
DishCatalogService"**. Я запрошу `ToolSearch` на `mcp__serena__find_symbol`,
вызову его на `DishCatalogService` в
`lib/src/services/enrichment/dish_catalog_service.dart` и верну тебе:
- Точное имя класса
- File + line range
- Список публичных методов (если запрошу `get_symbols_overview`)

Если ответ будет с координатами (`line 28-260`) — Serena работает и
индексирует Dart LSP. Если получу "no results" или ошибку — что-то
сломано в MCP integration.

---

## Полезные команды для повседневной работы

```powershell
# Список всех MCP серверов + статусы
claude mcp list

# Детали конкретного сервера
claude mcp get serena

# Stderr одного сервера (для debugging)
claude mcp logs serena

# Удалить сервер из user scope
claude mcp remove serena -s user

# Добавить новый сервер в user scope
claude mcp add -s user <name> -- <command> <args>

# Перезапустить все MCP серверы (косвенно — через рестарт Claude Code)
# Просто закрой и открой окно
```
