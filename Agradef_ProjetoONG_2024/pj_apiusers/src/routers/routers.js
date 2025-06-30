const express = require('express');
const router = express.Router();
const UsersController = require('../controllers/UsersController'); 
const AuthController = require('../controllers/AuthController');
const verificarAutenticacao = require('../middleware/authMiddleware');  

// Rota para criar um novo usuário
router.post('/api/user', UsersController.create);

// Rota para login 
router.post('/api/login', AuthController.login);

// Rota para solicitar recuperação de senha
router.post('/api/password-reset/request', AuthController.requestPasswordReset); 

// Rota para redefinir senha
router.post('/api/password-reset', AuthController.resetPassword); 

// Rota para listar todos os usuários (protegida)
router.get('/api/users', verificarAutenticacao, UsersController.listUsers);

// Rota para listar um usuário específico pelo ID (protegida)
router.get('/api/user/:id', verificarAutenticacao, UsersController.listUser);

// Rota para atualizar um usuário específico pelo ID (protegida)
router.put('/api/user/:id', verificarAutenticacao, UsersController.updateUser);

// Rota para deletar um usuário específico pelo ID (protegida)
router.delete('/api/user/:id', verificarAutenticacao, UsersController.deleteUser);

module.exports = router;
