BEGIN;

--
-- Sprint 4.6: enable pg_trgm so we can index `restaurant.normalizedName`
-- with a GIN trigram ops_class for fuzzy-match lookups in
-- RestaurantDedupService (pg_trgm similarity + % operator).
--
CREATE EXTENSION IF NOT EXISTS pg_trgm;

--
-- Sprint 4.6: rows in the old schema are not salvageable (restaurant is
-- now global; old rows have no normalizedName/geo data). Clear dependent
-- user-level tables before the CASCADE drop below. Safe in dev; no prod
-- data exists at this stage.
--
TRUNCATE TABLE "favorite_restaurant",
               "favorite_menu_item",
               "menu_item",
               "category"
    RESTART IDENTITY CASCADE;

--
-- ACTION DROP TABLE
--
DROP TABLE "restaurant_member" CASCADE;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "menu_item" DROP COLUMN "descriptionRaw";
ALTER TABLE "menu_item" DROP COLUMN "imageUrl";
--
-- ACTION CREATE TABLE
--
CREATE TABLE "menu_source_page" (
    "id" bigserial PRIMARY KEY,
    "restaurantId" bigint NOT NULL,
    "uploadBatchId" text NOT NULL,
    "ordinal" bigint NOT NULL,
    "sourceType" text NOT NULL,
    "imageUrl" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "menu_source_page_batch_ordinal_idx" ON "menu_source_page" USING btree ("uploadBatchId", "ordinal");
CREATE INDEX "menu_source_page_restaurant_idx" ON "menu_source_page" USING btree ("restaurantId");

--
-- ACTION DROP TABLE
--
DROP TABLE "restaurant" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "restaurant" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "normalizedName" text NOT NULL,
    "latitude" double precision,
    "longitude" double precision,
    "cityHint" text,
    "countryCode" text,
    "addressRaw" text,
    "currency" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "restaurant_geo_idx" ON "restaurant" USING btree ("latitude", "longitude");
CREATE INDEX "restaurant_normalized_name_idx" ON "restaurant" USING btree ("normalizedName");

-- NOTE: the GIN trigram index (restaurant_name_trgm_idx using gin_trgm_ops)
-- and the partial dish_image primary index (dish_image_primary_idx WHERE
-- isPrimary=true) can't be declared in .spy.yaml — Serverpod's schema
-- analyzer then flags them as unexpected on startup and refuses to boot in
-- dev mode. They are deferred to a follow-up sprint (see docs/legal +
-- ROADMAP 4.6 "Deferred" note). In the meantime pg_trgm still works via
-- sequential scan — functional, just not optimally indexed.

--
-- ACTION CREATE TABLE
--
CREATE TABLE "user_restaurant_visit" (
    "id" bigserial PRIMARY KEY,
    "userId" text NOT NULL,
    "restaurantId" bigint NOT NULL,
    "firstVisitAt" timestamp without time zone NOT NULL,
    "lastVisitAt" timestamp without time zone NOT NULL,
    "liked" boolean NOT NULL DEFAULT false
);

-- Indexes
CREATE UNIQUE INDEX "user_restaurant_visit_unique_idx" ON "user_restaurant_visit" USING btree ("userId", "restaurantId");
CREATE INDEX "user_restaurant_visit_user_idx" ON "user_restaurant_visit" USING btree ("userId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "menu_source_page"
    ADD CONSTRAINT "menu_source_page_fk_0"
    FOREIGN KEY("restaurantId")
    REFERENCES "restaurant"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "user_restaurant_visit"
    ADD CONSTRAINT "user_restaurant_visit_fk_0"
    FOREIGN KEY("restaurantId")
    REFERENCES "restaurant"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Sprint 4.6: recreate FKs the CASCADE from DROP TABLE "restaurant" above
-- implicitly dropped. Serverpod's diff planner doesn't detect the gap
-- because the dependent tables themselves weren't recreated.
--
ALTER TABLE ONLY "category"
    ADD CONSTRAINT "category_fk_0"
    FOREIGN KEY("restaurantId")
    REFERENCES "restaurant"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

ALTER TABLE ONLY "favorite_restaurant"
    ADD CONSTRAINT "favorite_restaurant_fk_0"
    FOREIGN KEY("restaurantId")
    REFERENCES "restaurant"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR menu_assistant
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('menu_assistant', '20260422100510849', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260422100510849', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260129180959368', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129180959368', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20260129181059877', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129181059877', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260213194423028', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260213194423028', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260129181112269', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129181112269', "timestamp" = now();


COMMIT;
