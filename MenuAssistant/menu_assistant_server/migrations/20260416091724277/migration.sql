BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "curated_dish" (
    "id" bigserial PRIMARY KEY,
    "canonicalName" text NOT NULL,
    "displayName" text NOT NULL,
    "wikidataId" text,
    "cuisine" text,
    "countryCode" text,
    "courseType" text,
    "aliases" json,
    "tags" json,
    "primaryIngredients" json,
    "dietFlags" json,
    "description" text,
    "origin" text,
    "status" text NOT NULL,
    "approvedBy" text,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "curated_dish_canonical_idx" ON "curated_dish" USING btree ("canonicalName");
CREATE INDEX "curated_dish_wikidata_idx" ON "curated_dish" USING btree ("wikidataId");
CREATE INDEX "curated_dish_cuisine_idx" ON "curated_dish" USING btree ("cuisine");
CREATE INDEX "curated_dish_status_idx" ON "curated_dish" USING btree ("status");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "curated_dish_image" (
    "id" bigserial PRIMARY KEY,
    "curatedDishId" bigint NOT NULL,
    "imageUrl" text NOT NULL,
    "source" text NOT NULL,
    "sourceUrl" text,
    "license" text NOT NULL,
    "attribution" text,
    "attributionUrl" text,
    "qualityScore" bigint NOT NULL,
    "styleTags" json,
    "isPrimary" boolean NOT NULL,
    "width" bigint,
    "height" bigint,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "curated_dish_image_dish_idx" ON "curated_dish_image" USING btree ("curatedDishId");
CREATE INDEX "curated_dish_image_quality_idx" ON "curated_dish_image" USING btree ("qualityScore");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "dataset_version" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "version" text NOT NULL,
    "appliedAt" timestamp without time zone NOT NULL,
    "dishCount" bigint NOT NULL,
    "imageCount" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "dataset_version_name_idx" ON "dataset_version" USING btree ("name");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "dish_catalog" ADD COLUMN "curatedDishId" bigint;
--
-- ACTION CREATE TABLE
--
CREATE TABLE "dish_translation" (
    "id" bigserial PRIMARY KEY,
    "curatedDishId" bigint NOT NULL,
    "language" text NOT NULL,
    "name" text NOT NULL,
    "description" text NOT NULL,
    "source" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "dish_translation_lookup_idx" ON "dish_translation" USING btree ("curatedDishId", "language");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "curated_dish_image"
    ADD CONSTRAINT "curated_dish_image_fk_0"
    FOREIGN KEY("curatedDishId")
    REFERENCES "curated_dish"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "dish_catalog"
    ADD CONSTRAINT "dish_catalog_fk_0"
    FOREIGN KEY("curatedDishId")
    REFERENCES "curated_dish"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "dish_translation"
    ADD CONSTRAINT "dish_translation_fk_0"
    FOREIGN KEY("curatedDishId")
    REFERENCES "curated_dish"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR menu_assistant
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('menu_assistant', '20260416091724277', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260416091724277', "timestamp" = now();

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
