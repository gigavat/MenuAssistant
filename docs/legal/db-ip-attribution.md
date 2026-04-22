# DB-IP attribution

The MenuAssistant backend uses the **DB-IP Lite** IP-to-country dataset
(CC-BY 4.0) for offline IP-geo lookups in `IpGeoService`. The attribution
below is a hard requirement of the licence — it must be visible to
end users.

## Canonical attribution string

> IP geolocation by DB-IP — https://db-ip.com

## Placement

| Surface          | Status          | Owner sprint |
| ---------------- | --------------- | ------------ |
| Landing `/legal` | NOT YET BUILT   | 4.8          |
| Admin footer     | NOT YET BUILT   | 4.9          |
| Flutter about    | NOT YET WIRED   | 4.7          |

When implementing each surface, include the canonical string verbatim
with the hyperlink wired to https://db-ip.com.

## Dataset details

- Source: https://db-ip.com/db/download/ip-to-country-lite
- Release cadence: monthly (1st of each month)
- Refresh job: `DbIpUpdateFutureCall` re-fetches every 7 days; see
  `lib/src/future_calls/db_ip_update_future_call.dart`
- Licence full text: https://creativecommons.org/licenses/by/4.0/

## Scope limitation (Sprint 4.6)

We load the country-level CSV only. The city-level mmdb format gives
coarser-grained positions (≈city centroid) but requires a binary-tree
reader we haven't written yet. `IpGeoResult.cityName` / `.latitude` /
`.longitude` stay null until a follow-up sprint adds mmdb parsing.
