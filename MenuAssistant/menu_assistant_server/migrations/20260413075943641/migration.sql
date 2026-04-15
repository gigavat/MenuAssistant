BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "llm_usage" (
    "id" bigserial PRIMARY KEY,
    "model" text NOT NULL,
    "operation" text NOT NULL,
    "inputTokens" bigint NOT NULL,
    "outputTokens" bigint NOT NULL,
    "cacheCreationTokens" bigint NOT NULL,
    "cacheReadTokens" bigint NOT NULL,
    "estimatedCostUsd" double precision NOT NULL,
    "restaurantId" bigint,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "llm_usage_created_at_idx" ON "llm_usage" USING btree ("createdAt");
CREATE INDEX "llm_usage_model_operation_idx" ON "llm_usage" USING btree ("model", "operation");

--
-- ACTION ALTER TABLE
--
-- Index was never actually created because Serverpod 3.4 stores List<String>
-- as `json` (not `jsonb`), and GIN doesn't work on `json`. We manually
-- commented out the CREATE INDEX in migration 20260412192705905, so this
-- DROP needs IF EXISTS to stay idempotent.
DROP INDEX IF EXISTS "unsplash_local_keywords_gin_idx";

--
-- MIGRATION VERSION FOR menu_assistant
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('menu_assistant', '20260413075943641', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260413075943641', "timestamp" = now();

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
