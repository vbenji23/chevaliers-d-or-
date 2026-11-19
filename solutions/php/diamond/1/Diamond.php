<?php

declare(strict_types=1);

function diamond(string $letter): array
{
    $maxIndex = ord($letter) - ord('A');
    $rows = [];

    // Construire la moitié supérieure (de 'A' jusqu'à la lettre demandée)
    for ($i = 0; $i <= $maxIndex; $i++) {
        $currentChar = chr(ord('A') + $i);
        $outerPadding = str_repeat(' ', $maxIndex - $i);

        if ($i === 0) {
            // Premier cas particulier : la lettre 'A' seule
            $rows[] = $outerPadding . 'A' . $outerPadding;
        } else {
            // Pour B, C, D... deux lettres séparées par des espaces intérieurs
            $innerPadding = str_repeat(' ', (2 * $i) - 1);
            $rows[] = $outerPadding . $currentChar . $innerPadding . $currentChar . $outerPadding;
        }
    }

    // Ajouter la moitié inférieure (symétrique à la partie supérieure sans doubler la ligne centrale)
    for ($i = $maxIndex - 1; $i >= 0; $i--) {
        $rows[] = $rows[$i];
    }

    return $rows;
}