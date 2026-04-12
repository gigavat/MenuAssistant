BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "dish_catalog" (
    "id" bigserial PRIMARY KEY,
    "normalizedName" text NOT NULL,
    "canonicalName" text NOT NULL,
    "cuisineType" text,
    "tags" json,
    "description" text,
    "spiceLevel" bigint,
    "enrichmentStatus" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "dish_catalog_normalized_name_idx" ON "dish_catalog" USING btree ("normalizedName");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "dish_image" (
    "id" bigserial PRIMARY KEY,
    "dishCatalogId" bigint NOT NULL,
    "imageUrl" text NOT NULL,
    "source" text NOT NULL,
    "sourceId" text,
    "attribution" text,
    "attributionUrl" text,
    "isPrimary" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "dish_image_dish_idx" ON "dish_image" USING btree ("dishCatalogId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "dish_provider_status" (
    "id" bigserial PRIMARY KEY,
    "dishCatalogId" bigint NOT NULL,
    "provider" text NOT NULL,
    "status" text NOT NULL,
    "lastAttemptedAt" timestamp without time zone,
    "nextRetryAt" timestamp without time zone,
    "attemptCount" bigint NOT NULL,
    "errorMessage" text,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "dish_provider_status_dish_provider_idx" ON "dish_provider_status" USING btree ("dishCatalogId", "provider");
CREATE INDEX "dish_provider_status_retry_idx" ON "dish_provider_status" USING btree ("status", "nextRetryAt");

--
-- ACTION DROP TABLE
--
DROP TABLE "menu_item" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "menu_item" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "descriptionRaw" text,
    "price" double precision NOT NULL,
    "tags" json,
    "imageUrl" text,
    "spicyLevel" bigint,
    "categoryId" bigint NOT NULL,
    "dishCatalogId" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "dish_image"
    ADD CONSTRAINT "dish_image_fk_0"
    FOREIGN KEY("dishCatalogId")
    REFERENCES "dish_catalog"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "dish_provider_status"
    ADD CONSTRAINT "dish_provider_status_fk_0"
    FOREIGN KEY("dishCatalogId")
    REFERENCES "dish_catalog"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "menu_item"
    ADD CONSTRAINT "menu_item_fk_0"
    FOREIGN KEY("categoryId")
    REFERENCES "category"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "menu_item"
    ADD CONSTRAINT "menu_item_fk_1"
    FOREIGN KEY("dishCatalogId")
    REFERENCES "dish_catalog"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR menu_assistant
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('menu_assistant', '20260412075609294', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260412075609294', "timestamp" = now();

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
