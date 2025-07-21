import { reset, seed } from 'drizzle-seed'
import { db } from './connection.ts'
import { schema } from './schema/index.ts'
import postgres from 'postgres'
const sql = postgres()

await reset(db, schema)

await seed(db, schema).refine(f =>{
    return{
        rooms: {
            count: 20,
            columns: {
                name: f.companyName(),
                description: f.loremIpsum(),
            },
        },
        questions: {
            count: 20,
        }
    }
})

await sql.end()

// biome-ignore lint/suspicious/noConsole: only used in dev
console.log('Database seeded')