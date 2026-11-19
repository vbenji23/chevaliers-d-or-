// ---------- Ciel étoilé (toutes les pages) ----------
function cielEtoile() {
  const canvas = document.getElementById("etoiles");
  if (!canvas) return;
  const ctx = canvas.getContext("2d");
  const calme = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
  let etoiles = [];

  function redimensionner() {
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
    const nombre = Math.floor((canvas.width * canvas.height) / 6000);
    etoiles = Array.from({ length: nombre }, () => ({
      x: Math.random() * canvas.width,
      y: Math.random() * canvas.height,
      r: Math.random() * 1.3 + 0.2,
      phase: Math.random() * Math.PI * 2,
      vitesse: Math.random() * 0.02 + 0.005,
    }));
  }

  function dessiner() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    for (const e of etoiles) {
      e.phase += e.vitesse;
      ctx.globalAlpha = 0.35 + Math.sin(e.phase) * 0.35;
      ctx.fillStyle = e.r > 1.2 ? "#f5d97a" : "#ffffff";
      ctx.beginPath();
      ctx.arc(e.x, e.y, e.r, 0, Math.PI * 2);
      ctx.fill();
    }
    if (!calme) requestAnimationFrame(dessiner);
  }

  window.addEventListener("resize", redimensionner);
  redimensionner();
  dessiner();
}

// ---------- Roue du zodiaque (accueil) ----------
function roueZodiaque() {
  const roue = document.querySelector(".roue");
  if (!roue) return;
  CHEVALIERS.forEach((c, i) => {
    const span = document.createElement("span");
    span.textContent = symboleTexte(c.symbole);
    span.style.setProperty("--a", `${i * 30}deg`);
    span.setAttribute("aria-hidden", "true");
    roue.appendChild(span);
  });
}

// ---------- Grille des chevaliers + filtres + détail (accueil) ----------
function grilleChevaliers() {
  const grille = document.getElementById("grille");
  if (!grille) return;
  const recherche = document.getElementById("recherche");
  const boutons = document.querySelectorAll(".filtre");
  const dialog = document.getElementById("detail");
  let element = "Tous";

  function afficher() {
    const texte = recherche.value.trim().toLowerCase();
    const liste = CHEVALIERS.filter((c) => {
      const okElement = element === "Tous" || c.element === element;
      const okTexte = [c.nom, c.signe, ...c.techniques].join(" ").toLowerCase().includes(texte);
      return okElement && okTexte;
    });

    grille.innerHTML = "";
    if (liste.length === 0) {
      grille.innerHTML = '<p class="vide">Aucun chevalier ne correspond.</p>';
      return;
    }
    for (const c of liste) {
      const carte = document.createElement("button");
      carte.className = "carte";
      carte.type = "button";
      carte.innerHTML = `
        <span class="carte__symbole" aria-hidden="true">${symboleTexte(c.symbole)}</span>
        <span class="carte__maison">Maison ${c.maison} · ${c.element}</span>
        <h3>${c.nom}</h3>
        <p class="carte__signe">Chevalier d'Or ${c.de} ${c.signe}</p>
        <span class="carte__tech">${c.techniques[0]}</span>`;
      carte.addEventListener("click", () => ouvrir(c));
      grille.appendChild(carte);
    }
  }

  function ouvrir(c) {
    dialog.querySelector(".detail__symbole").textContent = symboleTexte(c.symbole);
    dialog.querySelector("h3").textContent = c.nom;
    dialog.querySelector(".detail__alias").textContent = `${c.alias} — Maison ${c.de} ${c.signe}`;
    dialog.querySelector(".detail__description").textContent = c.description;
    dialog.querySelector(".detail__combat").textContent = c.combat;
    const ul = dialog.querySelector("ul");
    ul.innerHTML = "";
    for (const t of c.techniques) {
      const li = document.createElement("li");
      li.className = "carte__tech";
      li.textContent = t;
      ul.appendChild(li);
    }
    dialog.showModal();
  }

  dialog.querySelector(".fermer").addEventListener("click", () => dialog.close());
  // Clic en dehors de la fenêtre = fermer
  dialog.addEventListener("click", (e) => { if (e.target === dialog) dialog.close(); });

  recherche.addEventListener("input", afficher);
  boutons.forEach((b) =>
    b.addEventListener("click", () => {
      element = b.dataset.element;
      boutons.forEach((x) => x.setAttribute("aria-pressed", x === b));
      afficher();
    })
  );

  afficher();
}

// ---------- Chronologie (page chronologie) ----------
function chronologie() {
  const frise = document.getElementById("frise");
  if (!frise) return;

  const etapes = [
    ...CHEVALIERS.map((c) => ({
      pastille: symboleTexte(c.symbole),
      titre: `Maison ${c.maison} — ${c.signe} · ${c.nom}`,
      texte: c.combat,
    })),
    {
      pastille: "★",
      titre: "Le Palais du Grand Pope",
      texte: "Seiya affronte Saga, démasqué. Grâce à l'armure du Sagittaire et au bouclier d'Athéna, la flèche est retirée juste à temps : Athéna est sauvée.",
      final: true,
    },
  ];

  etapes.forEach((e, i) => {
    const li = document.createElement("li");
    li.className = "etape" + (e.final ? " etape--final" : "");
    li.dataset.index = i;
    li.innerHTML = `
      <div class="etape__pastille" aria-hidden="true">${e.pastille}</div>
      <div class="etape__carte"><h3>${e.titre}</h3><p>${e.texte}</p></div>`;
    frise.appendChild(li);
  });

  // L'horloge des 12 heures s'allume au fil du défilement
  const cadran = document.querySelector(".horloge__cadran");
  const legende = document.querySelector(".horloge p");
  for (let i = 0; i < 12; i++) cadran.appendChild(document.createElement("span"));
  const flammes = cadran.querySelectorAll("span");
  let maxVue = -1;

  function majHorloge() {
    // Une flamme s'éteint à chaque maison franchie
    const restantes = 12 - Math.max(0, Math.min(maxVue, 12));
    flammes.forEach((f, i) => f.classList.toggle("allume", i >= 12 - restantes));
    legende.textContent = restantes > 0
      ? `${restantes} flamme${restantes > 1 ? "s" : ""} encore allumée${restantes > 1 ? "s" : ""} sur l'horloge du Zodiaque`
      : "La dernière flamme s'éteint… mais Athéna est sauvée.";
  }

  const observateur = new IntersectionObserver(
    (entrees) => {
      for (const en of entrees) {
        if (!en.isIntersecting) continue;
        en.target.classList.add("visible");
        maxVue = Math.max(maxVue, Number(en.target.dataset.index));
        majHorloge();
      }
    },
    { threshold: 0.4 }
  );
  frise.querySelectorAll(".etape").forEach((li) => observateur.observe(li));
  majHorloge();
}

document.addEventListener("DOMContentLoaded", () => {
  cielEtoile();
  roueZodiaque();
  grilleChevaliers();
  chronologie();
});
