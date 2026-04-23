BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "admin_user" (
    "id" bigserial PRIMARY KEY,
    "email" text NOT NULL,
    "displayName" text,
    "role" text NOT NULL,
    "invitedAt" timestamp without time zone NOT NULL,
    "lastLoginAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "admin_user_email_idx" ON "admin_user" USING btree ("email");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "audit_log" (
    "id" bigserial PRIMARY KEY,
    "timestamp" timestamp without time zone NOT NULL,
    "actorEmail" text NOT NULL,
    "action" text NOT NULL,
    "objectType" text NOT NULL,
    "objectId" text NOT NULL,
    "diff" text NOT NULL,
    "ipAddress" text
);

-- Indexes
CREATE INDEX "audit_log_timestamp_idx" ON "audit_log" USING btree ("timestamp");
CREATE INDEX "audit_log_actor_idx" ON "audit_log" USING btree ("actorEmail");


--
-- MIGRATION VERSION FOR menu_assistant
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('menu_assistant', '20260423124039121', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260423124039121', "timestamp" = now();

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
