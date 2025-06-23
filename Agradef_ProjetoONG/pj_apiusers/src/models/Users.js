const knex = require('../data/conection');
const bcrypt = require('bcrypt');

class User {
    async new(name, email, password, role) {
        try {
            const hashedPassword = await bcrypt.hash(password, 10);

            await knex.insert({
                name: name,
                email: email,
                password: hashedPassword,
                role: role
            }).table('users');
           
            return 200;
        } catch (error) {
            console.log(error);
            return 404;
        }
    }

    async findById(id) {
        try {
            let user = await knex.select(['name', 'email']).where({ id: id }).table('users');
            if (user.length > 0) {
                return user;
            } else {
                return undefined;
            }
        } catch (error) {
            console.log(error);
            return 404;
        }
    }

    async findByEmail(email) {
        try {
            let user = await knex.select(['id', 'name', 'email', 'password', 'role']).where({ email: email }).table('users');
            if (user.length > 0) {
                return user[0];
            } else {
                return undefined;
            }
        } catch (error) {
            console.log(error);
            return undefined;
        }
    }

    async updatePassword(id, newPassword) {
        try {
            const hashedPassword = await bcrypt.hash(newPassword, 10);
            await knex.update({ password: hashedPassword }).where({ id: id }).table('users');
            return true;
        } catch (error) {
            console.log(error);
            return false;
        }
    }
}

module.exports = new User();
