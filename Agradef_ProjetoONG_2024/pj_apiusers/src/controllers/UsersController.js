const User = require('../models/Users');
const bcrypt = require('bcryptjs');

class UsersController {
    async create(req, res) {
        let { name, email, password, role } = req.body;
        try {
            let salt = bcrypt.genSaltSync(10);
            let hashedPassword = bcrypt.hashSync(password, salt);
            let result = await User.new(name, email, hashedPassword, role);
            if (result === 200) {
                res.status(result).json({ message: 'Usuário cadastrado com sucesso' });
            } else {
                res.status(result).json({ message: 'Erro ao cadastrar o usuário' });
            }
        } catch (error) {
            console.error(error);
            res.status(500).json({ message: 'Erro interno do servidor' });
        }
    }

    async findAll() {
        try {
            let users = await knex.select(['name', 'email']).from('users');
            return users;
        } catch (error) {
            console.error(error);
            return 404;
        }
    }

    async listUsers(req, res) {
        let users = await this.findAll();
        if (users === 404) {
            res.status(404).json({ message: 'Erro ao buscar os usuários' });
        } else {
            res.status(200).json({ users });
        }
    }

    async listUser(req, res) {
        let id = req.params.id;
        try {
            let user = await User.findById(id);
            if (user === 404 || user === undefined) {
                res.status(404).json({ message: 'Usuário não encontrado' });
            } else {
                res.status(200).json({ user });
            }
        } catch (error) {
            console.error(error);
            res.status(500).json({ message: 'Erro interno do servidor' });
        }
    }

    async updateUser(req, res) {
        let id = req.params.id;
        let { name, email, password, role } = req.body;
        try {
            let updateData = {};
            if (name) updateData.name = name;
            if (email) updateData.email = email;
            if (password) {
                let salt = bcrypt.genSaltSync(10);
                updateData.password = bcrypt.hashSync(password, salt);
            }
            if (role) updateData.role = role;
            const result = await knex('users').where({ id }).update(updateData);
            if (result) {
                res.status(200).json({ message: 'Usuário atualizado com sucesso' });
            } else {
                res.status(404).json({ message: 'Usuário não encontrado' });
            }
        } catch (error) {
            console.error(error);
            res.status(500).json({ message: 'Erro interno do servidor' });
        }
    }

    async deleteUser(req, res) {
        let id = req.params.id;
        try {
            const result = await knex('users').where({ id }).del();
            if (result) {
                res.status(200).json({ message: 'Usuário deletado com sucesso' });
            } else {
                res.status(404).json({ message: 'Usuário não encontrado' });
            }
        } catch (error) {
            console.error(error);
            res.status(500).json({ message: 'Erro interno do servidor' });
        }
    }
}

module.exports = new UsersController();
