// Petit serveur Express pour lancer le site en local
const express = require("express");
const path = require("path");

const app = express();
const PORT = process.env.PORT || 3000;
const RACINE = __dirname;

// Ne servir que les fichiers du site (pas server.js, package.json, .git…)
app.use("/css", express.static(path.join(RACINE, "css")));
app.use("/js", express.static(path.join(RACINE, "js")));

app.get(["/", "/index.html"], (req, res) => res.sendFile(path.join(RACINE, "index.html")));
app.get(["/chronologie", "/chronologie.html"], (req, res) =>
  res.sendFile(path.join(RACINE, "chronologie.html"))
);

// Page introuvable → retour à l'accueil
app.use((req, res) => res.redirect("/"));

app.listen(PORT, () => {
  console.log(`Sanctuaire ouvert sur http://localhost:${PORT}`);
});
