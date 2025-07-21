import { fastifyCors } from '@fastify/cors'
import { fastify } from 'fastify'
import {
    serializerCompiler,
    validatorCompiler,
    type ZodTypeProvider
} from 'fastify-type-provider-zod';
import { env } from './env.ts';
import { getRoomsRoute } from './http/routes/get-rooms.ts';
import { createRoomRoute } from './http/routes/create-room.ts';

const app = fastify().withTypeProvider<ZodTypeProvider>()

app.register(fastifyCors,{
    origin: true,

})

app.setSerializerCompiler(serializerCompiler)
app.setValidatorCompiler(validatorCompiler)

app.get('/health', () =>{
    return 'OK'
})

app.register(getRoomsRoute)
app.register(createRoomRoute)


app.listen({port: env.PORT})