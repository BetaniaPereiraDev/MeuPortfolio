const Atividade = require('../models/Atividade');

class AtividadeController {
    async create(req, res) {
        const { nome, descricao, data, userId } = req.body;

        try {
            const result = await Atividade.new(nome, descricao, data, userId);
            if (result === 200) {
                res.status(201).json({ message: 'Atividade criada com sucesso' });
            } else {
                res.status(400).json({ message: 'Erro ao criar a atividade' });
            }
        } catch (error) {
            console.error(error);
            res.status(500).json({ message: 'Erro interno do servidor' });
        }
    }

    async listByUser(req, res) {
        const userId = req.params.userId;
        try {
            const atividades = await Atividade.findByUserId(userId);
            if (atividades === undefined) {
                res.status(404).json({ message: 'Nenhuma atividade encontrada para esse aluno' });
            } else {
                res.status(200).json({ atividades });
            }
        } catch (error) {
            console.error(error);
            res.status(500).json({ message: 'Erro interno do servidor' });
        }
    }
}
module.exports = new AtividadeController();
