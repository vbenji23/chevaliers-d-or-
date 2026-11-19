# Les Chevaliers d'Or ✦ Les Chevaliers du Zodiaque

Site de fan consacré aux douze Chevaliers d'Or du Sanctuaire, tirés de la série *Les Chevaliers du Zodiaque* (*Saint Seiya*).

🔗 **Démo en ligne :** https://vbenji23.github.io/Chevaliers-d-or-/

## ✨ Fonctionnalités

- **Accueil** : les 12 Chevaliers d'Or en cartes, avec recherche (nom, signe, technique) et filtre par élément.
- **Fiche détaillée** : clic sur une carte → histoire, techniques et rôle dans la Bataille du Sanctuaire.
- **Les Douze Maisons** : chronologie animée au défilement, avec l'horloge du Zodiaque dont les flammes s'éteignent maison après maison.
- **Quiz** : 10 questions tirées au hasard parmi plus de 50, avec correction, rang final (d'Apprenti à Grand Pope) et meilleur score enregistré.
- **Jeu de mémoire** : retrouve les paires de signes, 3 niveaux (4, 6 ou 12 paires), chrono, compteur de coups et record par niveau.
- **Quel Chevalier d'Or es-tu ?** : par ta date de naissance ou par un test de personnalité en 6 questions.
- Ciel étoilé animé (canvas), roue du zodiaque, design responsive (mobile) et respect du réglage « réduire les animations ».

## 🗂️ Structure

```
├── index.html          # Accueil + grille des chevaliers
├── chronologie.html    # Bataille des Douze Maisons
├── quiz.html           # Quiz
├── memoire.html        # Jeu de mémoire
├── ton-chevalier.html  # Quel Chevalier d'Or es-tu ?
├── css/style.css       # Styles communs
├── js/data.js          # Données des 12 chevaliers
├── js/main.js          # Étoiles, filtres, fenêtre de détail, chronologie
├── js/activites.js     # Quiz, mémoire, test de personnalité
├── server.js           # Serveur Express (optionnel)
└── package.json
```

## 🚀 Lancer le site

### Option 1 : ouvrir directement
Double-clique sur `index.html` : le site fonctionne sans serveur.

### Option 2 : avec Node.js
```bash
npm install
npm start
```
Puis ouvre http://localhost:3000

### Option 3 : GitHub Pages
Dans **Settings → Pages**, choisis la branche `main` et le dossier `/ (root)`.

## 🛠️ Technologies

HTML5, CSS3 (Grid, variables, animations), JavaScript vanilla (IntersectionObserver, `<dialog>`, Canvas), Node.js / Express.

---

*Site de fan non officiel. Les Chevaliers du Zodiaque (Saint Seiya) © Masami Kurumada / Toei Animation.*
