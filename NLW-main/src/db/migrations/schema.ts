import { pgTable, uuid, text, timestamp } from "drizzle-orm/pg-core"
import { sql } from "drizzle-orm"



export const rooms = pgTable("rooms", {
	id: uuid().defaultRandom().primaryKey().notNull(),
	name: text().notNull(),
	description: text(),
	createdAt: timestamp("created_at", { mode: 'string' }).defaultNow().notNull(),
});
