# Handoff: MenuAssistant — Landing & Mobile App Redesign

## Overview

This handoff contains a complete design system and screen designs for **MenuAssistant**, a B2C mobile app that lets a user snap a photo of a restaurant menu and receive a beautifully rendered, translated, price-converted, allergen-tagged, photo-illustrated version of it in ~20 seconds. It covers:

1. **Marketing landing page** (responsive desktop-first, single page)
2. **Mobile app redesign** — 9 screens replacing the current Flutter UI

Both deliverables share a single visual system so the landing and the app feel like one product.

## About the Design Files

The files in this bundle are **design references created in HTML + React** — prototypes that demonstrate intended look and behavior, not production code to ship.

- **For the mobile app**: the existing app is built in **Flutter**. The designs should be re-implemented in that Flutter codebase using its existing patterns (state management, routing, asset pipeline). Translate the HTML/CSS/React structure into Flutter widgets. Use the design tokens below to drive your theme (`ThemeData`, `ColorScheme`, `TextTheme`).
- **For the landing page**: no framework is specified. Recommended: Next.js or Astro for SEO + image optimization, with vanilla CSS / CSS modules. If the project already has a web frontend, use its conventions.

The React components in `components/screens.jsx` are **reference anatomy** — they show what widgets to build, in what hierarchy, with what copy and spacing. They are NOT meant to be ported as React to Flutter.

## Fidelity

**High fidelity.** All colors, typography, spacing, radii, component anatomy and micro-copy are final and intentional. Implement pixel-for-pixel where reasonable; use the exact design tokens listed below.

The photos in dishes/restaurants are **striped placeholders** — real photography / AI-generated dish photos from the app's existing pipeline should replace them.

---

## Design Tokens

### Colors — Warm theme (default / light)

| Token | Value | Use |
|---|---|---|
| `--bg` | `#FBF8F3` | Page background, phone background |
| `--surface` | `#FFFFFF` | Cards, elevated surfaces |
| `--surface-2` | `#F3EEE5` | Secondary surfaces, inputs, chips off |
| `--ink` | `#1A1713` | Primary text, primary buttons |
| `--ink-2` | `#3D3832` | Body text |
| `--muted` | `#8A8278` | Captions, metadata, placeholders |
| `--line` | `#E6DFD2` | Borders, dividers |
| `--accent` | `#C44E2A` | Terracotta — primary brand accent |
| `--accent-ink` | `#8A3416` | Dark accent text on `--accent-soft` |
| `--accent-soft` | `#F6E2D6` | Tinted backgrounds for accent elements |
| `--ok` | `#3F7A3B` | Success, vegan badges |

### Colors — Sage theme (alternate light)

| Token | Value |
|---|---|
| `--bg` | `#F5F5EF` |
| `--surface-2` | `#EAEBE1` |
| `--ink` | `#16201A` |
| `--accent` | `#3E6B4A` |
| `--accent-ink` | `#2A4C33` |
| `--accent-soft` | `#D8E4D1` |
| `--line` | `#DCDFCE` |

### Colors — Midnight theme (dark)

| Token | Value |
|---|---|
| `--bg` | `#0F1012` |
| `--surface` | `#17181B` |
| `--surface-2` | `#1E2024` |
| `--ink` | `#F5EFE6` |
| `--ink-2` | `#C9C2B6` |
| `--muted` | `#7A7468` |
| `--line` | `#2B2D32` |
| `--accent` | `#E8A96B` |
| `--accent-soft` | `#322217` |

### Typography

Three-family system:

| Role | Family | Fallback | Source |
|---|---|---|---|
| **Display / serif** | `Fraunces` weights 400, 500, 600, 700, italic | `Times New Roman`, serif | Google Fonts, variable |
| **UI / sans** | `Inter` weights 400, 500, 600, 700 | `system-ui`, sans-serif | Google Fonts |
| **Mono / metadata** | `JetBrains Mono` weights 400, 500 | `ui-monospace`, monospace | Google Fonts |

**Fraunces opsz tip**: use `font-variation-settings: "opsz" 144;` for the very large display heading italic — it gives the correct "newspaper" feel.

#### Type scale (landing)

| Token | Size | Line-height | Letter-spacing | Usage |
|---|---|---|---|---|
| Hero H1 | 88px | 0.97 | −0.035em | Fraunces 500 |
| Section H2 XL | 104px | 0.95 | −0.035em | CTA block |
| Section H2 L | 72px | 0.98 | −0.03em | "How it works" |
| Section H2 M | 56px | 1.02 | −0.025em | Showcase |
| Section H2 S | 44px | 1.05 | −0.02em | Problem |
| Card H3 M | 28px | 1.1 | −0.02em | Steps |
| Card H3 S | 22–26px | 1.1 | −0.02em | Features |
| Body lead | 19px | 1.5 | — | Hero sub |
| Body | 14–16px | 1.5 | — | Inter |
| Eyebrow | 11px UPPERCASE | — | 0.08em | Mono |

#### Type scale (mobile app, inside a 320×660 phone frame)

| Role | Size | Family |
|---|---|---|
| Screen H1 | 30–34px | Fraunces 500 |
| Screen H2 | 24–28px | Fraunces 500 |
| Dish card title | 14px | Fraunces 500 |
| Body | 13px | Inter |
| Price | 28px | Fraunces 500 |
| Caption / metadata | 10–12px | JetBrains Mono |
| Original dish name (above translation) | 9px UPPERCASE | JetBrains Mono |

### Spacing, radii, shadows

- Spacing scale: 4 / 6 / 8 / 10 / 12 / 14 / 16 / 20 / 24 / 28 / 32 / 40 / 48 / 64 / 96px
- Border radii: 8 (tiny tags) / 10 / 12 (chips, inputs) / 14 (buttons, input groups) / 16 (cards) / 18–20 (phone cards) / 28 (bottom sheets) / 40 (big dark sections) / 44 (phone body) / 999 (pills)
- Shadows:
  - Card: `0 20px 40px -10px rgba(26,23,19,0.25)`
  - FAB (accent): `0 10px 30px -5px rgba(196,78,42,0.5)`
  - Floating badge: `0 12px 30px -8px rgba(26,23,19,0.2)`

### Components

- **Buttons**
  - Primary: `--ink` background, `--bg` text, radius 14 (app) / 999 (landing), height 44/48
  - Accent: `--accent` background, white text
  - Ghost: transparent with `--line` border
- **Input**: 14px radius, 44–48 height, `--surface` background, `--line` 1px border, left-side 16px icon, 14px body text, 14px placeholder in `--muted`
- **Chips**: radius 999, padding 6×12 / 5×10, 11–12px font, mono for metadata chips
- **Allergen badge**: 9px Mono, inside photos, tinted green `rgba(63,122,59,0.9)` with 🌱 emoji
- **Photo placeholder**: striped `repeating-linear-gradient(135deg, <stripe> 0 12px, <bg> 12px 24px)` — replace with real photos in production

---

## Screens (mobile app)

All screens are designed inside a **320×660 viewport** representing a phone content area (inside device bezel). Implement them responsive from 360×720 up.

### 01. Onboarding
3-slide onboarding. Slide 1 shows a stylized paper menu being "captured" by a phone.
- Large Fraunces H1 with italic accent word in `--accent`
- Inter body, `--ink-2`
- Dark primary button at the bottom
- Dot pagination at the bottom (active dot is a 20px wide terracotta pill)
- "Skip" link top-right, mono style
- Counter top-left `01 / 03`

### 02. Auth
Replaces the bland "Авторизация" form.
- Eyebrow "Welcome"
- Fraunces headline: "Unlock the menus of the world." with italic "of the world."
- Two inputs (email, password) — icon-prefixed, 14px radius
- **Accent primary button** "Sign in or create" (important: this is terracotta, not blue)
- Divider "or" (mono, uppercase, with 1px lines)
- Ghost Google button

### 03. Home (restaurant list)
**Replaces empty grey tiles.**
- Search bar + account avatar (terracotta soft circle with "И")
- Greeting "Hi, Ivan" (mono) + Fraunces H1 "Where today? Your menus." with italic accent
- Horizontal filter chip row (Recent, Liked, Porto, Lisboa, Gluten-free)
- **Vertical list of restaurant cards**, NOT grid of empty tiles. Each card:
  - 64×64 photo (placeholder striped)
  - Name in Fraunces 500 16px
  - Cuisine tag 11px muted
  - Heart icon top-right (filled terracotta when liked)
  - Bottom row: 📍 city + last-visit date in mono 11px
- FAB bottom-right: 60×60, radius 20, terracotta, camera icon

### 04. Restaurant
- 180px full-bleed hero photo with gradient overlay
- Back + heart buttons floating on glass
- Overlay text: city · cuisine (mono eyebrow) + restaurant name in Fraunces 28px
- **Natural-language search** input: placeholder "something with cod, under 25€"
- Filter pill row: `RU ↔ PT` (accent), `€`, 🌱, `gf`
- **Categories as list**, numbered `01 … 06`, with item counts — more legible than the current grey grid

### 05. Dish list
Grid 2×N. Each card:
- Photo placeholder 120px tall, radius 14
- Heart in glassy pill top-right
- Optional vegan badge bottom-left
- Below photo: original dish name in 9px mono uppercase, translated name in 14px Fraunces 500
- Price (mono 12px) left + allergen tags right

### 06. Dish detail
- 260px hero photo + gradient, dot pagination (photo gallery)
- Eyebrow: original Italian name in mono
- H1 in Fraunces 500 24px (translated name)
- **Price row**: mono uppercase label "Price" / "Цена" left; big Fraunces 28px number + `EUR · ≈ 4 680 ₽` in mono muted
- Allergen/ingredient chips — 3 accent-soft "present" chips, 2 neutral "contains" chips with emoji
- "Composition" block with description
- Bottom: ghost "Show original" + accent "Save"

### 07. Add menu (bottom sheet)
- Blurred+dimmed home screen behind
- 28px-radius sheet rising from bottom
- Drag handle
- Eyebrow + Fraunces H2 "Snap it — we do the rest" with italic accent phrase
- Body copy explains ~20s processing
- **Primary action card** full-width in accent color: "Take a photo — paper menu on the table" + chevron
- **3 secondary tiles** below: Gallery / PDF doc / Link

### 08. Profile
Replaces the current `ПОЛЬЗОВАТЕЛЬ` + hex-ID + red "Выйти" screen.
- Avatar 64×64 radius 20 (accent-soft, serif initial italic)
- Name Fraunces 22px + email mono 12px
- **3-stat strip**: Places / Dishes / Cities — each in a bordered card, big Fraunces number
- Settings list: Liked places, Liked dishes, Language, Currency, Diet & allergens, Theme
- Each row: 32×32 icon tile, label, value in mono right-aligned, chevron

### 09. Empty state
Shown when the user has no menus yet. Replaces an empty home.
- Paper menu illustration (two stacked paper layers + accent FAB)
- Fraunces H2 "Still empty." with italic accent "empty"
- Body nudging to snap the first menu
- Dark button "Capture first menu" with camera icon

---

## Interactions & Behavior

- **Translation**: Tap a "RU ↔ PT" chip to toggle between original and translated dish names. Keep original always visible as a small label above translation.
- **Allergen filters**: applied globally from profile — hides incompatible dishes across all menus.
- **Smart search** (home + restaurant): natural-language query → backend AI → dish results.
- **Like / save**: heart icon on restaurants and dishes, persisted to profile.
- **Add menu flow**: FAB → bottom sheet → choose source (camera/gallery/PDF/link) → upload → loading state (~20s) → new restaurant appears at top of Home list.

## State Management

- `user` (auth, locale, currency, diet preferences)
- `restaurants` (user's saved menus, each with `categories → dishes`)
- `dishLikes`, `restaurantLikes`
- `visitHistory` (timestamped)
- `search query` + `parsed filters`
- `processing jobs` (pending menu parses)

## Assets

- No custom icons in this handoff — use the app's existing icon library (current Flutter app uses Material icons; keep them, restyle containers). Line weight 1.5–1.8px @ 14–22px sizes.
- **Google Fonts**: Fraunces, Inter, JetBrains Mono — add to pubspec / fonts/ folder.
- **Dish/restaurant photography**: replace striped placeholders with the existing AI photo pipeline.
- **Logo mark**: simple serif "M" italic in terracotta circle 28×28, radius 8. Placeholder — a real mark should be designed.

## Landing page content

See `MenuAssistant Design.html` — sections in order:
1. Nav (logo + links + RU/EN + "Download" button)
2. Hero (headline, sub, App Store + Google Play, 3 stats)
3. Problem (two italic quotes)
4. "How it works" (4 steps)
5. Features grid (6 bento cells: translation big-dark, allergen filters accent, smart search, currency, history, recommendations)
6. Mobile app showcase (the 9 screens above, on dark backdrop)
7. CTA (huge Fraunces headline + store buttons)
8. Footer

All copy is provided in **Russian + English** — see `i18n` object in the HTML file.

## Files in this bundle

- `MenuAssistant Design.html` — the full landing + app prototype, single file
- `components/screens.jsx` — React components for all 9 app screens (reference only, translate to Flutter)
- `components/ios-frame.jsx` — reusable phone bezel (reference)
- `README.md` — this document

## Recent changes (April 2026)

- **Language switcher in nav** — now a **dropdown** (flag + code trigger → menu with flag, code, native name). 7 languages: EN, RU, PT, ES, IT, FR, DE.
- **Mobile app screens translate into all 7 languages** — translation table lives in `components/screens.jsx` as `SCREEN_I18N[key][lang]`. Fallback order: specific lang → English → Russian.
- **Dish card screen** — `Показать оригинал` and `Сохранить` action buttons removed; the dish detail is now a clean single-column read.
- **Polyglot section redesigned** — was a tabs + single card layout that duplicated the nav's language switcher. Replaced with a **horizontal auto-scrolling rail** (55 s loop) showing all 7 language variants of the same dish (Bacalhau à Brás) side-by-side. Implemented as a JS rAF marquee (two copies back-to-back, measured loop width) that **smoothly decelerates to a stop on hover** (~600 ms easeOutCubic) and accelerates back on mouse-leave. Pauses entirely when tab is hidden. On mobile, should become a native horizontal scroll with snap — marquee is a desktop enhancement.
- **Step 01 (Снимок) card** in "Как работает" — rebuilt with a richer visual showing all three input methods (tilted photo with washi tape, PDF doc, URL link chip) instead of just a camera icon.
- **Anchor scrolling** — sections use `scroll-margin-top: 80 px` so the sticky nav doesn't cover headings when clicking in-page links; `#how` uses 40 px because of its larger internal `padding-top`.

## Implementation checklist for Claude Code

1. Add Fraunces, Inter, JetBrains Mono to Flutter `pubspec.yaml` and `assets/fonts/`
2. Create `theme/colors.dart` with all tokens from the Warm theme; parameterize for Sage and Midnight
3. Create `theme/typography.dart` mapping the type scale to `TextTheme`
4. Build shared widgets: `PrimaryButton`, `AccentButton`, `GhostButton`, `AppInput`, `Chip`, `PhotoPlaceholder`, `AllergenBadge`, `FAB`, `BottomSheet`, `LangDropdown`
5. Implement screens in order: Auth → Home → Restaurant → Dish list → Dish detail → Add menu sheet → Profile → Empty → Onboarding
6. Wire up theme switching (System / Light / Dark)
7. Ensure locale switching works end-to-end for all 7 languages (EN, RU, PT, ES, IT, FR, DE) — use Flutter's `intl` / ARB files
8. For the landing: reproduce the Polyglot marquee with CSS + a small rAF loop (or `Marquee` package); pause-on-hover is the key interaction
