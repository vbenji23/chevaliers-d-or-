// Données des 12 Chevaliers d'Or — partagées par toutes les pages
const CHEVALIERS = [
  {
    id: "belier", maison: 1, signe: "Bélier", de: "du", symbole: "♈", element: "Feu",
    nom: "Mû", alias: "Le forgeron des armures",
    techniques: ["Crystal Wall", "Starlight Extinction", "Stardust Revolution"],
    description: "Dernier héritier du peuple de Mu, il est le seul capable de réparer les armures sacrées. Il vit en retrait à Jamir, loin du Sanctuaire corrompu.",
    combat: "Mû laisse passer les Chevaliers de Bronze sans combattre et répare leurs armures. Il les prévient : les onze maisons suivantes ne seront pas aussi clémentes."
  },
  {
    id: "taureau", maison: 2, signe: "Taureau", de: "du", symbole: "♉", element: "Terre",
    nom: "Aldébaran", alias: "Le colosse",
    techniques: ["Great Horn"],
    description: "Géant à la force colossale, il combat bras croisés et frappe à une vitesse que l'œil ne peut suivre.",
    combat: "Seiya affronte Aldébaran et parvient à briser une corne de son casque. Impressionné par sa volonté, le gardien laisse passer les Bronzes."
  },
  {
    id: "gemeaux", maison: 3, signe: "Gémeaux", de: "des", symbole: "♊", element: "Air",
    nom: "Saga", alias: "Le dieu et le démon",
    techniques: ["Galaxian Explosion", "Another Dimension", "Genrō Maō Ken"],
    description: "Considéré comme un être d'une bonté divine, Saga porte en lui une seconde personnalité maléfique qui a usurpé le trône du Grand Pope.",
    combat: "Le temple semble vide, mais un labyrinthe d'illusions piège les Bronzes. Hyoga est projeté dans une autre dimension tandis qu'Andromède cherche la sortie."
  },
  {
    id: "cancer", maison: 4, signe: "Cancer", de: "du", symbole: "♋", element: "Eau",
    nom: "Masque de Mort", alias: "Le seigneur des enfers",
    techniques: ["Sekishiki Meikai Ha"],
    description: "Cruel et sans scrupules, il orne les murs de son temple des visages de ses victimes et peut envoyer les âmes au bord du monde des morts.",
    combat: "Shiryu affronte Masque de Mort jusqu'au puits des enfers. L'armure du Cancer, refusant de servir un homme aussi injuste, abandonne son porteur."
  },
  {
    id: "lion", maison: 5, signe: "Lion", de: "du", symbole: "♌", element: "Feu",
    nom: "Aiolia", alias: "Le lion loyal",
    techniques: ["Lightning Plasma", "Lightning Bolt"],
    description: "Frère cadet d'Aiolos, longtemps méprisé à cause de la prétendue trahison de son aîné. Droit et fougueux.",
    combat: "Manipulé par le Genrō Maō Ken du Grand Pope, Aiolia attaque Seiya. Le sacrifice de Cassios lui rend sa lucidité."
  },
  {
    id: "vierge", maison: 6, signe: "Vierge", de: "de la", symbole: "♍", element: "Terre",
    nom: "Shaka", alias: "L'homme le plus proche des dieux",
    techniques: ["Tenbu Hōrin", "Tenma Kōfuku", "Rikudō Rinne"],
    description: "Réincarnation de Bouddha, il garde les yeux fermés pour contenir son cosmos. Les ouvrir libère une puissance redoutable.",
    combat: "Shaka écrase les Bronzes jusqu'à l'arrivée d'Ikki du Phénix. Leur duel mène les deux chevaliers au bord de la disparition."
  },
  {
    id: "balance", maison: 7, signe: "Balance", de: "de la", symbole: "♎", element: "Air",
    nom: "Dohko", alias: "Le Vieux Maître",
    techniques: ["Rozan Hyaku Ryū Ha", "Les douze armes de la Balance"],
    description: "Maître de Shiryu, il veille depuis plus de deux siècles sur les Cinq Pics de Rozan. Seule son armure peut autoriser l'usage des armes.",
    combat: "Le temple est vide : Hyoga y est retrouvé prisonnier d'un cercueil de glace. Shun l'en libère grâce à son cosmos, au péril de sa vie."
  },
  {
    id: "scorpion", maison: 8, signe: "Scorpion", de: "du", symbole: "♏", element: "Eau",
    nom: "Milo", alias: "L'aiguille écarlate",
    techniques: ["Scarlet Needle", "Antarès"],
    description: "Fier et honorable, il frappe quinze points correspondant aux étoiles du Scorpion avant de porter le coup fatal, Antarès.",
    combat: "Hyoga résiste aux quatorze piqûres de Milo. Touché par sa détermination, Milo lui épargne le coup final et soigne ses blessures."
  },
  {
    id: "sagittaire", maison: 9, signe: "Sagittaire", de: "du", symbole: "♐", element: "Feu",
    nom: "Aiolos", alias: "Le héros oublié",
    techniques: ["Atomic Thunderbolt", "La flèche d'or"],
    description: "Accusé de trahison, il est mort treize ans plus tôt en sauvant le bébé Athéna. Son armure a guidé les Bronzes depuis le début.",
    combat: "Pas de combat : les Bronzes découvrent le testament d'Aiolos gravé dans la pierre. « Je vous confie Athéna. »"
  },
  {
    id: "capricorne", maison: 10, signe: "Capricorne", de: "du", symbole: "♑", element: "Terre",
    nom: "Shura", alias: "Le plus fidèle",
    techniques: ["Excalibur", "Jumping Stone"],
    description: "Son bras droit est une lame capable de tout trancher, Excalibur, héritée selon la légende d'Athéna elle-même.",
    combat: "Shiryu sacrifie tout dans l'Ultime Dragon. Comprenant son erreur, Shura lui confie Excalibur avant de disparaître."
  },
  {
    id: "verseau", maison: 11, signe: "Verseau", de: "du", symbole: "♒", element: "Air",
    nom: "Camus", alias: "Le magicien de l'eau et de la glace",
    techniques: ["Diamond Dust", "Aurora Execution", "Freezing Coffin"],
    description: "Maître de Hyoga, d'une froideur absolue en apparence. Il peut atteindre le zéro absolu.",
    combat: "Hyoga dépasse son maître en atteignant à son tour le zéro absolu. Les deux chevaliers tombent ; seul l'élève survivra."
  },
  {
    id: "poissons", maison: 12, signe: "Poissons", de: "des", symbole: "♓", element: "Eau",
    nom: "Aphrodite", alias: "La beauté mortelle",
    techniques: ["Royal Demon Rose", "Piranhan Rose", "Bloody Rose"],
    description: "Le plus beau des Chevaliers d'Or. Un tapis de roses empoisonnées protège l'escalier qui mène au Grand Pope.",
    combat: "Shun affronte Aphrodite et déploie la Tempête Nébulaire. Les deux tombent, mais la route vers le Pope est ouverte."
  }
];

// Les signes du zodiaque sont forcés en texte (pas en emoji)
const symboleTexte = (s) => s + "︎";
