// ============================================================
//  Activités : quiz, jeu de mémoire, « Quel Chevalier es-tu ? »
//  (utilise CHEVALIERS et symboleTexte définis dans data.js)
// ============================================================

const melanger = (tab) => {
  const t = [...tab];
  for (let i = t.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [t[i], t[j]] = [t[j], t[i]];
  }
  return t;
};

// Petit stockage local protégé (le navigateur peut le refuser)
const stock = {
  lire(cle) { try { return JSON.parse(localStorage.getItem(cle)); } catch { return null; } },
  ecrire(cle, val) { try { localStorage.setItem(cle, JSON.stringify(val)); } catch { /* ignoré */ } },
};

// ---------------------------------------------------------------
//  1. QUIZ
// ---------------------------------------------------------------
function genererQuestions() {
  const autres = (c, champ) => melanger(CHEVALIERS.filter((x) => x !== c)).slice(0, 3).map(champ);
  const q = [];

  for (const c of CHEVALIERS) {
    q.push({
      question: `Qui garde la Maison ${c.de} ${c.signe} ?`,
      bonne: c.nom,
      choix: [c.nom, ...autres(c, (x) => x.nom)],
      info: `${c.nom} est le gardien de la ${c.maison}ᵉ maison.`,
    });
    q.push({
      question: `À quel chevalier appartient la technique « ${c.techniques[0]} » ?`,
      bonne: c.nom,
      choix: [c.nom, ...autres(c, (x) => x.nom)],
      info: `« ${c.techniques[0]} » est la technique de ${c.nom}.`,
    });
    q.push({
      question: `Quel est le numéro de la Maison ${c.de} ${c.signe} ?`,
      bonne: String(c.maison),
      choix: [String(c.maison), ...autres(c, (x) => String(x.maison))],
      info: `C'est la ${c.maison}ᵉ des douze maisons.`,
    });
  }

  // Questions écrites à la main
  q.push(
    { question: "Combien de temps Athéna a-t-elle à vivre après avoir reçu la flèche d'or ?", bonne: "12 heures", choix: ["12 heures", "24 heures", "7 jours", "1 heure"], info: "Une flamme de l'horloge s'éteint à chaque heure." },
    { question: "Quel chevalier usurpe le trône du Grand Pope ?", bonne: "Saga", choix: ["Saga", "Shaka", "Aiolos", "Camus"], info: "Saga, chevalier des Gémeaux, a une seconde personnalité maléfique." },
    { question: "Quel Chevalier de Bronze est l'élève de Camus ?", bonne: "Hyoga", choix: ["Hyoga", "Shiryu", "Shun", "Seiya"], info: "Hyoga du Cygne a été formé par Camus du Verseau." },
    { question: "Quel chevalier peut réparer les armures ?", bonne: "Mû", choix: ["Mû", "Dohko", "Aldébaran", "Milo"], info: "Mû est le dernier héritier du peuple de Mu." },
    { question: "Combien de piqûres compte la Scarlet Needle avant Antarès ?", bonne: "14", choix: ["14", "12", "7", "15"], info: "Quatorze piqûres, puis le quinzième coup : Antarès." },
    { question: "Quel chevalier garde toujours les yeux fermés ?", bonne: "Shaka", choix: ["Shaka", "Camus", "Shura", "Aphrodite"], info: "Shaka contient ainsi son immense cosmos." },
  );
  return q;
}

function quiz() {
  const zone = document.getElementById("quiz");
  if (!zone) return;
  const NB = 10;
  let questions, index, score;

  function demarrer() {
    questions = melanger(genererQuestions()).slice(0, NB);
    index = 0;
    score = 0;
    afficherQuestion();
  }

  function afficherQuestion() {
    const q = questions[index];
    zone.innerHTML = `
      <div class="quiz__progression"><span style="width:${(index / NB) * 100}%"></span></div>
      <p class="quiz__compteur">Question ${index + 1} / ${NB} · Score : ${score}</p>
      <h3 class="quiz__question">${q.question}</h3>
      <div class="quiz__choix"></div>
      <p class="quiz__info" aria-live="polite"></p>`;
    const boite = zone.querySelector(".quiz__choix");
    for (const choix of melanger(q.choix)) {
      const b = document.createElement("button");
      b.className = "choix";
      b.type = "button";
      b.textContent = choix;
      b.addEventListener("click", () => repondre(b, choix));
      boite.appendChild(b);
    }
  }

  function repondre(bouton, choix) {
    const q = questions[index];
    const boutons = zone.querySelectorAll(".choix");
    boutons.forEach((b) => {
      b.disabled = true;
      if (b.textContent === q.bonne) b.classList.add("choix--bon");
    });
    const juste = choix === q.bonne;
    if (juste) score++;
    else bouton.classList.add("choix--faux");
    zone.querySelector(".quiz__info").textContent = (juste ? "✔ Bonne réponse ! " : "✘ Raté. ") + q.info;

    const suivant = document.createElement("button");
    suivant.className = "btn";
    suivant.textContent = index + 1 < NB ? "Question suivante" : "Voir mon résultat";
    suivant.addEventListener("click", () => {
      index++;
      index < NB ? afficherQuestion() : resultat();
    });
    zone.appendChild(suivant);
    suivant.focus();
  }

  function resultat() {
    const record = Math.max(score, stock.lire("quiz-record") || 0);
    stock.ecrire("quiz-record", record);
    const rangs = [
      [10, "Grand Pope", "Parfait ! Le Sanctuaire t'appartient."],
      [8, "Chevalier d'Or", "Ton cosmos a atteint le septième sens."],
      [6, "Chevalier d'Argent", "Solide, mais les douze maisons te résistent encore."],
      [3, "Chevalier de Bronze", "Tu as du cœur… il te manque l'entraînement."],
      [0, "Apprenti", "Retourne t'entraîner sur l'île d'Andromède !"],
    ];
    const [, titre, phrase] = rangs.find(([min]) => score >= min);
    zone.innerHTML = `
      <div class="resultat">
        <p class="hero__sur-titre">Ton rang</p>
        <h3>${titre}</h3>
        <p class="resultat__score">${score} / ${NB}</p>
        <p>${phrase}</p>
        <p class="quiz__compteur">Meilleur score : ${record} / ${NB}</p>
        <button class="btn" type="button">Rejouer</button>
      </div>`;
    zone.querySelector("button").addEventListener("click", demarrer);
  }

  demarrer();
}

// ---------------------------------------------------------------
//  2. JEU DE MÉMOIRE
// ---------------------------------------------------------------
function memoire() {
  const plateau = document.getElementById("memoire");
  if (!plateau) return;
  const elCoups = document.getElementById("coups");
  const elTemps = document.getElementById("temps");
  const elPaires = document.getElementById("paires");
  const elRecord = document.getElementById("record");
  const elMessage = document.getElementById("message-memoire");
  const selectNiveau = document.getElementById("niveau");

  let retournees, trouvees, coups, secondes, chrono, bloque, nbPaires;

  function demarrer() {
    nbPaires = Number(selectNiveau.value);
    clearInterval(chrono);
    chrono = null;
    retournees = [];
    trouvees = 0;
    coups = 0;
    secondes = 0;
    bloque = false;
    elMessage.textContent = "";
    majStats();

    const choisis = melanger(CHEVALIERS).slice(0, nbPaires);
    const cartes = melanger([...choisis, ...choisis]);
    plateau.innerHTML = "";
    plateau.style.setProperty("--colonnes", nbPaires <= 6 ? 4 : 6);
    for (const c of cartes) {
      const carte = document.createElement("button");
      carte.type = "button";
      carte.className = "memo";
      carte.dataset.id = c.id;
      carte.setAttribute("aria-label", "Carte cachée");
      carte.innerHTML = `
        <span class="memo__face memo__dos" aria-hidden="true">✦</span>
        <span class="memo__face memo__avant"><b>${symboleTexte(c.symbole)}</b><small>${c.nom}</small></span>`;
      carte.addEventListener("click", () => retourner(carte, c));
      plateau.appendChild(carte);
    }
  }

  function majStats() {
    elCoups.textContent = coups;
    elTemps.textContent = `${secondes}s`;
    elPaires.textContent = `${trouvees} / ${nbPaires}`;
    const r = stock.lire(`memoire-record-${nbPaires}`);
    elRecord.textContent = r ? `${r.coups} coups · ${r.secondes}s` : "—";
  }

  function retourner(carte, c) {
    if (bloque || carte.classList.contains("retournee")) return;
    if (!chrono) chrono = setInterval(() => { secondes++; majStats(); }, 1000);

    carte.classList.add("retournee");
    carte.setAttribute("aria-label", `${c.nom}, ${c.signe}`);
    retournees.push(carte);
    if (retournees.length < 2) return;

    coups++;
    const [a, b] = retournees;
    if (a.dataset.id === b.dataset.id) {
      a.classList.add("trouvee");
      b.classList.add("trouvee");
      retournees = [];
      trouvees++;
      elMessage.textContent = `Paire trouvée : ${c.nom} ${c.de} ${c.signe} !`;
      if (trouvees === nbPaires) victoire();
    } else {
      bloque = true;
      setTimeout(() => {
        for (const x of [a, b]) {
          x.classList.remove("retournee");
          x.setAttribute("aria-label", "Carte cachée");
        }
        retournees = [];
        bloque = false;
      }, 900);
    }
    majStats();
  }

  function victoire() {
    clearInterval(chrono);
    const cle = `memoire-record-${nbPaires}`;
    const ancien = stock.lire(cle);
    const nouveau = !ancien || coups < ancien.coups || (coups === ancien.coups && secondes < ancien.secondes);
    if (nouveau) stock.ecrire(cle, { coups, secondes });
    majStats();
    elMessage.textContent = `Victoire en ${coups} coups et ${secondes}s !` + (nouveau ? " ★ Nouveau record !" : "");
  }

  document.getElementById("rejouer").addEventListener("click", demarrer);
  selectNiveau.addEventListener("change", demarrer);
  demarrer();
}

// ---------------------------------------------------------------
//  3. QUEL CHEVALIER D'OR ES-TU ?
// ---------------------------------------------------------------
// Dates du zodiaque : [mois, jour] de début de chaque signe
const DATES_SIGNES = [
  ["capricorne", 1, 1], ["verseau", 1, 20], ["poissons", 2, 19], ["belier", 3, 21],
  ["taureau", 4, 20], ["gemeaux", 5, 21], ["cancer", 6, 21], ["lion", 7, 23],
  ["vierge", 8, 23], ["balance", 9, 23], ["scorpion", 10, 23], ["sagittaire", 11, 22],
  ["capricorne", 12, 22],
];

function signeDepuisDate(mois, jour) {
  let id = "capricorne";
  for (const [s, m, j] of DATES_SIGNES) {
    if (mois > m || (mois === m && jour >= j)) id = s;
  }
  return CHEVALIERS.find((c) => c.id === id);
}

const QUESTIONS_PERSO = [
  {
    q: "Un ami est en danger. Que fais-tu ?",
    r: [
      ["Je fonce sans réfléchir", ["lion", "taureau"]],
      ["Je prépare un plan infaillible", ["gemeaux", "verseau"]],
      ["Je le protège avec mon propre corps", ["belier", "balance"]],
      ["Je fais payer ceux qui l'ont attaqué", ["scorpion", "cancer"]],
    ],
  },
  {
    q: "Ton arme préférée ?",
    r: [
      ["Mes poings, rien d'autre", ["taureau", "lion"]],
      ["Une lame tranchante", ["capricorne", "balance"]],
      ["La glace et le froid", ["verseau", "scorpion"]],
      ["Les roses et la beauté", ["poissons", "vierge"]],
    ],
  },
  {
    q: "Ton plus grand défaut ?",
    r: [
      ["L'orgueil", ["poissons", "cancer"]],
      ["Je suis trop sérieux", ["capricorne", "verseau"]],
      ["Je m'emporte vite", ["lion", "scorpion"]],
      ["Je garde trop de secrets", ["gemeaux", "vierge"]],
    ],
  },
  {
    q: "Où te sens-tu le mieux ?",
    r: [
      ["Au sommet d'une montagne", ["balance", "belier"]],
      ["Dans la neige de Sibérie", ["verseau"]],
      ["En méditation, en silence", ["vierge", "belier"]],
      ["Au cœur de la bataille", ["sagittaire", "taureau", "lion"]],
    ],
  },
  {
    q: "Ce qui compte le plus pour toi ?",
    r: [
      ["La justice", ["sagittaire", "lion", "capricorne"]],
      ["La puissance", ["gemeaux", "cancer"]],
      ["La sagesse", ["vierge", "balance"]],
      ["L'honneur", ["scorpion", "taureau", "sagittaire"]],
    ],
  },
  {
    q: "Comment tes amis te décrivent-ils ?",
    r: [
      ["Calme et bienveillant", ["belier", "balance"]],
      ["Mystérieux", ["gemeaux", "poissons", "vierge"]],
      ["Loyal jusqu'au bout", ["sagittaire", "capricorne", "lion"]],
      ["Froid mais juste", ["verseau", "scorpion"]],
    ],
  },
];

function afficherFiche(cible, c, intro) {
  cible.innerHTML = `
    <div class="fiche">
      <span class="fiche__symbole" aria-hidden="true">${symboleTexte(c.symbole)}</span>
      <p class="hero__sur-titre">${intro}</p>
      <h3>${c.nom}</h3>
      <p class="detail__alias">${c.alias} — Maison ${c.de} ${c.signe}</p>
      <p>${c.description}</p>
      <ul class="fiche__tech">${c.techniques.map((t) => `<li class="carte__tech">${t}</li>`).join("")}</ul>
    </div>`;
}

function quelChevalier() {
  const formDate = document.getElementById("form-date");
  if (!formDate) return;

  // --- Par date de naissance ---
  const resDate = document.getElementById("resultat-date");
  formDate.addEventListener("submit", (e) => {
    e.preventDefault();
    const valeur = document.getElementById("naissance").value;
    if (!valeur) return;
    const [, mois, jour] = valeur.split("-").map(Number);
    afficherFiche(resDate, signeDepuisDate(mois, jour), "Ton signe te place sous la protection de");
  });

  // --- Test de personnalité ---
  const zone = document.getElementById("test");
  let etape, points;

  function demarrer() {
    etape = 0;
    points = Object.fromEntries(CHEVALIERS.map((c) => [c.id, 0]));
    poser();
  }

  function poser() {
    const { q, r } = QUESTIONS_PERSO[etape];
    zone.innerHTML = `
      <div class="quiz__progression"><span style="width:${(etape / QUESTIONS_PERSO.length) * 100}%"></span></div>
      <p class="quiz__compteur">Question ${etape + 1} / ${QUESTIONS_PERSO.length}</p>
      <h3 class="quiz__question">${q}</h3>
      <div class="quiz__choix"></div>`;
    const boite = zone.querySelector(".quiz__choix");
    for (const [texte, ids] of melanger(r)) {
      const b = document.createElement("button");
      b.className = "choix";
      b.type = "button";
      b.textContent = texte;
      b.addEventListener("click", () => {
        ids.forEach((id) => (points[id] += 1));
        etape++;
        etape < QUESTIONS_PERSO.length ? poser() : finir();
      });
      boite.appendChild(b);
    }
  }

  function finir() {
    const max = Math.max(...Object.values(points));
    const gagnants = CHEVALIERS.filter((c) => points[c.id] === max);
    const elu = gagnants[Math.floor(Math.random() * gagnants.length)];
    afficherFiche(zone, elu, "Ton âme résonne avec le cosmos de");
    const b = document.createElement("button");
    b.className = "btn";
    b.textContent = "Refaire le test";
    b.addEventListener("click", demarrer);
    zone.querySelector(".fiche").appendChild(b);
  }

  demarrer();
}

document.addEventListener("DOMContentLoaded", () => {
  quiz();
  memoire();
  quelChevalier();
});
