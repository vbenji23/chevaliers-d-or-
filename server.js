const express = require('express');
const path = require('path');
const app = express();

// Sert les fichiers statiques (HTML, CSS, JS) depuis ton dossier
app.use(express.static(path.join(__dirname, 'public')));

// Route principale
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// Démarrage du serveur
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Site dispo sur http://localhost:${PORT}`);
});
