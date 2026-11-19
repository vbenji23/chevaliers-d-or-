<?php

declare(strict_types=1);

function crypto_square(string $plaintext): string
{
    // 1. Normalisation : passer en minuscules et ne garder que les caractères alphanumériques
    $normalized = strtolower(preg_replace('/[^a-zA-Z0-9]/', '', $plaintext));
    $length = strlen($normalized);

    // Cas particulier : chaîne vide
    if ($length === 0) {
        return '';
    }

    // 2. Calcul du nombre de colonnes ($c) et de lignes ($r)
    $c = (int) ceil(sqrt($length));
    $r = (int) ceil($length / $c);

    // 3. Remplissage avec des espaces pour obtenir un rectangle parfait ($r x $c)
    $padded = str_pad($normalized, $r * $c, ' ');

    // Découpage en $r lignes de longueur $c
    $rows = str_split($padded, $c);

    // 4. Construction des $c blocs en lisant verticalement (colonne par colonne)
    $chunks = [];
    for ($col = 0; $col < $c; $col++) {
        $chunk = '';
        for ($row = 0; $row < $r; $row++) {
            $chunk .= $rows[$row][$col];
        }
        $chunks[] = $chunk;
    }

    // Assemblage des blocs avec un espace entre eux
    return implode(' ', $chunks);
}