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

// ── Phase C typed payloads ───────────────────────────────────────────────

export interface CuratedDish {
  id: number;
  canonicalName: string;
  displayName: string;
  wikidataId?: string | null;
  cuisine?: string | null;
  countryCode?: string | null;
  courseType?: string | null;
  aliases?: string[] | null;
  tags?: string[] | null;
  primaryIngredients?: string[] | null;
  dietFlags?: string[] | null;
  description?: string | null;
  origin?: string | null;
  status: string;
  approvedBy?: string | null;
  createdAt: string;
  updatedAt: string;
}

export interface DishCatalogRow {
  id: number;
  normalizedName: string;
  canonicalName: string;
  cuisineType?: string | null;
  description?: string | null;
  curatedDishId?: number | null;
  curatedDisplayName?: string | null;
  primaryImageUrl?: string | null;
  enrichmentStatus: string;
  createdAt: string;
  updatedAt: string;
}

export interface TranslationRow {
  translationId?: number | null;
  curatedDishId: number;
  dishDisplayName: string;
  language: string;
  name?: string | null;
  description?: string | null;
  source?: string | null;
  createdAt?: string | null;
}

export interface DishTranslation {
  id?: number;
  curatedDishId: number;
  language: string;
  name: string;
  description: string;
  source: string;
  createdAt: string;
}

export interface PhotoReviewRow {
  imageId: number;
  curatedDishId: number;
  dishDisplayName: string;
  imageUrl: string;
  source: string;
  qualityScore: number;
  isPrimary: boolean;
  width?: number | null;
  height?: number | null;
  createdAt: string;
}

export interface CuratedDishImage {
  id?: number;
  curatedDishId: number;
  imageUrl: string;
  source: string;
  qualityScore: number;
  isPrimary: boolean;
  createdAt: string;
}

export interface AuditLog {
  id?: number;
  timestamp: string;
  actorEmail: string;
  action: string;
  objectType: string;
  objectId: string;
  diff: string;
  ipAddress?: string | null;
}

// ── Phase D payloads ─────────────────────────────────────────────────────

export interface MenuQueueEntry {
  restaurantId: number;
  name: string;
  cityHint?: string | null;
  countryCode?: string | null;
  parsedAt: string;
  updatedAt?: string | null;
  dishCount: number;
  categoryCount: number;
  pageCount: number;
  moderationStatus?: string | null;
}

export interface MenuSourcePage {
  id?: number;
  restaurantId?: number | null;
  uploadBatchId: string;
  ordinal: number;
  sourceType: string;
  imageUrl: string;
  createdAt: string;
}

export interface Category {
  id?: number;
  name: string;
  restaurantId?: number | null;
  createdAt: string;
  approvalStatus?: string | null;
}

export interface MenuItem {
  id?: number;
  name: string;
  price: number;
  tags?: string[] | null;
  spicyLevel?: number | null;
  categoryId?: number | null;
  dishCatalogId?: number | null;
  createdAt: string;
  approvalStatus?: string | null;
}

export interface MenuValidationView {
  restaurant: Restaurant & {
    moderationStatus?: string | null;
    updatedAt?: string | null;
  };
  pages: MenuSourcePage[];
  categories: Category[];
  items: MenuItem[];
}

// ── Thin method wrappers ─────────────────────────────────────────────────

export const adminApi = {
  // Phase A/B
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

  // Phase C.1/2 — Dish Library + Dish Review
  listCuratedDishes: (params: {
    status?: string | null;
    cuisine?: string | null;
    search?: string | null;
    offset?: number;
    limit?: number;
  }) => adminCall<CuratedDish[]>("listCuratedDishes", params),
  updateCuratedDish: (params: {
    id: number;
    displayName?: string;
    cuisine?: string;
    countryCode?: string;
    courseType?: string;
    description?: string;
    status?: string;
  }) => adminCall<CuratedDish>("updateCuratedDish", params),
  listDishCatalog: (params: {
    linked?: boolean | null;
    search?: string | null;
    offset?: number;
    limit?: number;
  }) => adminCall<DishCatalogRow[]>("listDishCatalog", params),

  // Phase C.3 — Translations
  listTranslations: (params: {
    language: string;
    search?: string | null;
    offset?: number;
    limit?: number;
  }) => adminCall<TranslationRow[]>("listTranslations", params),
  upsertTranslation: (params: {
    curatedDishId: number;
    language: string;
    name: string;
    description: string;
  }) => adminCall<DishTranslation>("upsertTranslation", params),

  // Phase C.4 — Photo review
  listLowQualityPhotos: (params: {
    maxQuality?: number | null;
    offset?: number;
    limit?: number;
  }) => adminCall<PhotoReviewRow[]>("listLowQualityPhotos", params),
  setPhotoQuality: (params: { imageId: number; qualityScore: number }) =>
    adminCall<CuratedDishImage>("setPhotoQuality", params),
  deletePhoto: (params: { imageId: number }) =>
    adminCall<boolean>("deletePhoto", params),

  // Phase C.5 — Audit log
  listAuditLog: (params: {
    actorEmail?: string | null;
    objectType?: string | null;
    action?: string | null;
    offset?: number;
    limit?: number;
  }) => adminCall<AuditLog[]>("listAuditLog", params),

  // Phase D — Queue + Validator
  listMenuQueue: (params: {
    status?: string | null;
    search?: string | null;
    offset?: number;
    limit?: number;
  }) => adminCall<MenuQueueEntry[]>("listMenuQueue", params),
  getMenuForValidation: (params: { restaurantId: number }) =>
    adminCall<MenuValidationView>("getMenuForValidation", params),
  updateMenuItem: (params: {
    itemId: number;
    name?: string;
    price?: number;
    approvalStatus?: string;
  }) => adminCall<MenuItem>("updateMenuItem", params),
  updateCategory: (params: {
    categoryId: number;
    name?: string;
    approvalStatus?: string;
  }) => adminCall<Category>("updateCategory", params),
  approveMenu: (params: { restaurantId: number }) =>
    adminCall<Restaurant>("approveMenu", params),
  rejectMenu: (params: { restaurantId: number; reason: string }) =>
    adminCall<Restaurant>("rejectMenu", params),
};
