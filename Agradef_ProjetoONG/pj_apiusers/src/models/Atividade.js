const knex = require('../data/conection');

class Atividade {
    async new(nome, descricao, data, userId) {
        try {
            await knex.insert({
                nome: nome,
                descricao: descricao,
                data: data,
                userId: userId
            }).table('atividades');

            return 200;
        } catch (error) {
            console.log(error);
            return 404;
        }
    }

    async findByUserId(userId) {
        try {
            let atividades = await knex.select(['nome', 'descricao', 'data']).where({ userId: userId }).table('atividades');
            if (atividades.length > 0) {
                return atividades;
            } else {
                return undefined;
            }
        } catch (error) {
            console.log(error);
            return 404;
        }
    }
}

module.exports = new Atividade();
