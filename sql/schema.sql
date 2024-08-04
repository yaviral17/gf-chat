CREATE TABLE IF NOT EXISTS "users" (
  "id" varchar PRIMARY KEY NOT NULL,
  "first_name" varchar NOT NULL,
  "last_name" varchar NOT NULL,
  "email" varchar UNIQUE NOT NULL,
  "phone" varchar UNIQUE,
  "created_at" timestamp DEFAULT (now())
);

CREATE TABLE IF NOT EXISTS "messages" (
  "id" varchar PRIMARY KEY NOT NULL,
  "sender" varchar NOT NULL,
  "receiver" varchar NOT NULL,
  "room_id" varchar,
  "body" varchar DEFAULT '',
  "created_at" timestamp DEFAULT (now())
);

CREATE TABLE IF NOT EXISTS "rooms" (
  "id" varchar PRIMARY KEY NOT NULL,
  "room_name" varchar NOT NULL,
  "created_at" timestamp DEFAULT (now())
);

CREATE TABLE IF NOT EXISTS "room_memberships" (
  "id" varchar PRIMARY KEY,
  "user_id" varchar NOT NULL,
  "room_id" varchar NOT NULL,
  "joined_at" timestamp DEFAULT (now()),
  "left_at" timestamp
);

ALTER TABLE "messages" ADD FOREIGN KEY ("sender") REFERENCES "users" ("id");

ALTER TABLE "messages" ADD FOREIGN KEY ("receiver") REFERENCES "users" ("id");

ALTER TABLE "messages" ADD FOREIGN KEY ("room_id") REFERENCES "rooms" ("id");

ALTER TABLE "room_memberships" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "room_memberships" ADD FOREIGN KEY ("room_id") REFERENCES "rooms" ("id");


