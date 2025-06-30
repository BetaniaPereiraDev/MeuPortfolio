const jwt = require('jsonwebtoken'); // verfica se o token jwt é valido

function verificarAutenticacao(req, res, next) {
    const token = req.headers['authorization'];

    if (!token) {
        return res.status(401).json({ message: 'acesso negado token nao fornecido.' });
    }

    jwt.verify(token, 'chave_secreta', (err, decoded) => {
        if (err) {
            return res.status(401).json({ message: 'token invalido' });
        }

        req.usuario = decoded;
        next();
    });
}

module.exports = verificarAutenticacao;
