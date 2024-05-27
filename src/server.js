const express = require('express');
const app = express();
const PORT = 3030;

// Servindo arquivos estáticos da pasta public
app.use(express.static('public'));

app.listen(PORT, () => {
    console.log(`Servidor rodando em http://localhost:${PORT}`);
});