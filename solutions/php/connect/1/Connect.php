<?php

declare(strict_types=1);

function winner(array $lines): ?string
{
    // Nettoyer les espaces d'indentation au début/fin de chaque ligne
    // et découper chaque ligne en jetons (pions/vides)
    $grid = [];
    foreach ($lines as $line) {
        $trimmed = trim($line);
        if ($trimmed === '') {
            continue;
        }
        $grid[] = explode(' ', $trimmed);
    }

    $height = count($grid);
    if ($height === 0) {
        return null;
    }
    $width = count($grid[0]);

    // 1. Vérifier si 'O' (white) a connecté le Haut et le Bas
    if (checkWinner($grid, 'O', $height, $width)) {
        return 'white';
    }

    // 2. Vérifier si 'X' (black) a connecté la Gauche et la Droite
    if (checkWinner($grid, 'X', $height, $width)) {
        return 'black';
    }

    return null;
}

function checkWinner(array $grid, string $player, int $height, int $width): bool
{
    $queue = [];
    $visited = [];

    // Initialiser la file d'attente BFS depuis le bord de départ
    if ($player === 'O') {
        // 'O' démarre sur la première ligne (r = 0)
        for ($c = 0; $c < $width; $c++) {
            if ($grid[0][$c] === 'O') {
                $queue[] = [0, $c];
                $visited["0,$c"] = true;
            }
        }
    } else {
        // 'X' démarre sur la première colonne (c = 0)
        for ($r = 0; $r < $height; $r++) {
            if ($grid[$r][0] === 'X') {
                $queue[] = [$r, 0];
                $visited["$r,0"] = true;
            }
        }
    }

    if (empty($queue)) {
        return false;
    }

    // Les 6 directions hexagonales dans la grille 2D
    $directions = [
        [-1,  0], // Haut
        [-1,  1], // Haut-droite
        [ 0, -1], // Gauche
        [ 0,  1], // Droite
        [ 1, -1], // Bas-gauche
        [ 1,  0], // Bas
    ];

    // Parcours en largeur (BFS)
    while (!empty($queue)) {
        [$r, $c] = array_shift($queue);

        // Condition de victoire : atteinte du bord opposé
        if ($player === 'O' && $r === $height - 1) {
            return true;
        }
        if ($player === 'X' && $c === $width - 1) {
            return true;
        }

        foreach ($directions as [$dr, $dc]) {
            $nr = $r + $dr;
            $nc = $c + $dc;

            if ($nr >= 0 && $nr < $height && $nc >= 0 && $nc < $width) {
                if ($grid[$nr][$nc] === $player && !isset($visited["$nr,$nc"])) {
                    $visited["$nr,$nc"] = true;
                    $queue[] = [$nr, $nc];
                }
            }
        }
    }

    return false;
}