BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "category" ADD COLUMN "approvalStatus" text;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "menu_item" ADD COLUMN "approvalStatus" text;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "restaurant" ADD COLUMN "moderationStatus" text;
ALTER TABLE "restaurant" ADD COLUMN "updatedAt" timestamp without time zone;
CREATE INDEX "restaurant_moderation_status_idx" ON "restaurant" USING btree ("moderationStatus");

--
-- MIGRATION VERSION FOR menu_assistant
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('menu_assistant', '20260424111838105', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260424111838105', "timestamp" = now();

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
