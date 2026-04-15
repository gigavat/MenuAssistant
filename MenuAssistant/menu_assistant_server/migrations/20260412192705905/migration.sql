BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "unsplash_local_photo" (
    "id" bigserial PRIMARY KEY,
    "unsplashId" text NOT NULL,
    "photoUrl" text NOT NULL,
    "thumbUrl" text,
    "authorName" text NOT NULL,
    "authorUrl" text,
    "description" text,
    "keywords" json,
    "dominantColor" text,
    "width" bigint,
    "height" bigint,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "unsplash_local_unsplash_id_idx" ON "unsplash_local_photo" USING btree ("unsplashId");
-- GIN index cannot be built on a `json` column (Serverpod 3.4 has no jsonb
-- column type). Skipped until Serverpod supports jsonb — the food-filtered
-- table is small enough (~5–10K rows) that sequential scan is acceptable.
-- CREATE INDEX "unsplash_local_keywords_gin_idx" ON "unsplash_local_photo" USING gin ("keywords");


--
-- MIGRATION VERSION FOR menu_assistant
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('menu_assistant', '20260412192705905', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260412192705905', "timestamp" = now();

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
