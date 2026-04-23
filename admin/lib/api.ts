/**
 * Тонкий fetch-wrapper к Serverpod `AdminEndpoint` (см.
 * menu_assistant_server/lib/src/endpoints/admin_endpoint.dart).
 *
 * Serverpod-конвенция вызова endpoint'а:
 *   POST {base}/admin/{methodName}
 *   Content-Type: application/json
 *   body: { <named params as JSON> }
 *
 * Identity в production — через Cloudflare Access header
 * `Cf-Access-Authenticated-User-Email`; в dev — через query param
 * `_adminEmail`, который сервер принимает только если
 * `ADMIN_DEV_BYPASS=true` в окружении Serverpod'а.
 */

const BASE =
  process.env.NEXT_PUBLIC_SERVERPOD_URL ?? "http://localhost:8080";
const DEV_EMAIL = process.env.NEXT_PUBLIC_ADMIN_DEV_EMAIL;

export class AdminApiError extends Error {
  constructor(
    public status: number,
    message: string,
  ) {
    super(message);
    this.name = "AdminApiError";
  }
}

export async function adminCall<T>(
  method: string,
  body: Record<string, unknown> = {},
): Promise<T> {
  const url = new URL(`${BASE}/admin/${method}`);
  if (DEV_EMAIL) {
    url.searchParams.set("_adminEmail", DEV_EMAIL);
  }
  const res = await fetch(url, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(body),
    // Не нужны cookies между поддоменами — Cloudflare Access пишет JWT
    // в `CF_Authorization`, который относится к самому admin-домену, а
    // запрос идёт напрямую в Serverpod.
  });
  if (!res.ok) {
    const text = await res.text().catch(() => res.statusText);
    throw new AdminApiError(res.status, text || res.statusText);
  }
  return (await res.json()) as T;
}

// ── Typed payloads (зеркалят серверные spy.yaml DTO) ─────────────────────

export interface AdminMetrics {
  totalRestaurants: number;
  totalUsers: number;
  totalMenus: number;
  totalDishesInCatalog: number;
  totalCuratedDishes: number;
  totalLlmCostUsd: number;
}

export interface AdminUserRow {
  userId: string;
  email: string | null;
  displayName: string | null;
  createdAt: string;
  lastSignInAt: string | null;
}

export interface Restaurant {
  id: number;
  name: string;
  normalizedName: string;
  latitude?: number | null;
  longitude?: number | null;
  cityHint?: string | null;
  countryCode?: string | null;
  addressRaw?: string | null;
  currency: string;
  createdAt: string;
}

// ── Thin method wrappers ─────────────────────────────────────────────────

export const adminApi = {
  getMetrics: () => adminCall<AdminMetrics>("getMetrics"),
  listRestaurants: (params: {
    offset?: number;
    limit?: number;
    search?: string | null;
  }) => adminCall<Restaurant[]>("listRestaurants", params),
  listUsers: (params: {
    offset?: number;
    limit?: number;
    search?: string | null;
  }) => adminCall<AdminUserRow[]>("listUsers", params),
};
