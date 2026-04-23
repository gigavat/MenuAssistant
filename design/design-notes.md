# MenuAssistant — design notes

## Product recap
B2C app. User photographs / imports a restaurant menu → AI parses and returns a beautiful, translated menu with photos, descriptions, tags, prices in preferred currency. Users save restaurants/dishes, adjust language + currency. Roadmap: social layer, then B2B for restaurants.

## Pain points in current Flutter UI
- Blank grey cards on restaurant list — no sense of place
- Blue `#2D6CFF` feels generic / SaaS, not "food"
- Price styled as a link (underlined-blue feeling) fights with accent
- "ПОЛЬЗОВАТЕЛЬ" + raw UUID reads like a placeholder
- Material search bar is visually noisy; header lacks hierarchy
- No onboarding → first-open screen is already the (empty) home grid
- No empty states with guidance
- No language toggle in-app surface; buried in settings
- Add-menu bottom sheet shows 4 equal icons — hides the primary action (photograph)

## Direction
Warm, editorial, confident. Menu as an object worth showing.
- Neutrals: warm off-white, soft cream, deep charcoal
- Accent: terracotta (food-friendly, not SaaS-blue)
- Type: Fraunces (display) + Inter (UI) + JetBrains Mono (prices / metadata)
- Imagery: real food photography when available; for placeholders, striped SVG + monospace caption "food photo"
