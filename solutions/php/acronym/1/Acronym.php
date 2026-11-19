<?php

declare(strict_types=1);

function acronym(string $text): string
{
    // Remplace les traits d'union et les apostrophes/caractères non alphabétiques par des espaces et supprime la ponctuation
    $cleanText = preg_replace('/[^\p{L}\p{N}\s-]/u', '', $text);
    $cleanText = str_replace('-', ' ', $cleanText);

    // Découpe en mots
    $words = preg_split('/\s+/', $cleanText, -1, PREG_SPLIT_NO_EMPTY);

    $acronym = '';
    foreach ($words as $word) {
        // Récupère la première lettre de chaque mot en majuscule (compatible UTF-8)
        $acronym .= mb_strtoupper(mb_substr($word, 0, 1));
    }

    return $acronym;
}