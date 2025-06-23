// AuthController.js
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const crypto = require('crypto');
const nodemailer = require('nodemailer');
// Remova a linha do knex, pois não estamos usando o banco de dados para este teste

class AuthController {
    // Método de login com dados fixos para teste
    async login(req, res) {
        const { email, password } = req.body;

        // Usuário fixo para teste
        const fixedUser = {
            email: 'luisfelicio23@gmail.com',
            password: await bcrypt.hash('luis2030', 10)  // Hash da senha fixa
        };

        try {
            // Verifica se o email corresponde ao usuário fixo
            if (email !== fixedUser.email) {
                return res.status(404).json({ message: 'Usuário não encontrado' });
            }

            // Compara a senha fornecida com a senha fixa hash
            const passwordMatch = await bcrypt.compare(password, fixedUser.password);
            if (!passwordMatch) {
                return res.status(400).json({ message: 'Senha inválida' });
            }

            // Gera um token JWT com informações fixas
            const token = jwt.sign(
                { id: 1, email: fixedUser.email }, // ID fictício
                process.env.JWT_SECRET,             // Chave secreta do .env
                { expiresIn: '1h' }
            );

            res.status(200).json({ token });
        } catch (error) {
            console.error(error);
            res.status(500).json({ message: 'Erro interno do servidor' });
        }
    }

    async requestPasswordReset(req, res) {
        const { email } = req.body;
        try {
            if (email !== 'testuser@example.com') {
                return res.status(404).json({ message: 'Usuário não encontrado' });
            }

            const resetToken = crypto.randomBytes(32).toString('hex');
            const resetTokenExpires = Date.now() + 15 * 60 * 1000; // Token válido por 15 minutos

            const transporter = nodemailer.createTransport({
                service: 'Gmail',
                auth: {
                    user: process.env.EMAIL_USER, // Email carregado do .env
                    pass: process.env.EMAIL_PASS  // Senha carregada do .env
                }
            });

            const mailOptions = {
                to: email,
                from: process.env.EMAIL_USER,
                subject: 'Redefinição de Senha',
                text: `Você está recebendo este e-mail porque solicitou a redefinição de senha para sua conta.\n\n` +
                      `Por favor, use o seguinte código de recuperação: ${resetToken}\n\n` +
                      `Este código é válido por 15 minutos.\n\n` +
                      `Se você não solicitou isso, por favor ignore este e-mail.\n`
            };

            await transporter.sendMail(mailOptions);

            res.status(200).json({ message: 'E-mail de recuperação enviado' });
        } catch (error) {
            console.error(error);
            res.status(500).json({ message: 'Erro interno do servidor' });
        }
    }

    async resetPassword(req, res) {
        const { resetToken, newPassword } = req.body;
        try {
            // Simulação de validação do token de reset para o usuário fixo
            if (resetToken !== 'token-de-teste') {
                return res.status(400).json({ message: 'Token inválido ou expirado' });
            }

            const hashedPassword = await bcrypt.hash(newPassword, 10); // Hash da nova senha

            res.status(200).json({ message: 'Senha alterada com sucesso' });
        } catch (error) {
            console.error(error);
            res.status(500).json({ message: 'Erro interno do servidor' });
        }
    }
}

module.exports = new AuthController();
