const express = require('express');
const router = express.Router();
const AtividadeController = require('../controllers/AtividadeController');

//rota para criar uma nova atividade
router.post('/atividades', AtividadeController.create);

//rota para listar atividades de um aluno específico
router.get('/atividades/:userId', AtividadeController.listByUser);

module.exports = router;
