<?php

declare(strict_types=1);

function detectAnagrams(string $word, array $anagrams): array
{
    $normalizedWord = mb_strtolower($word);
    $sortedWord = sortLetters($normalizedWord);

    $matches = [];

    foreach ($anagrams as $candidate) {
        $normalizedCandidate = mb_strtolower($candidate);

        // Un mot n'est pas son propre anagramme
        if ($normalizedCandidate === $normalizedWord) {
            continue;
        }

        // Si les lettres triées sont identiques, c'est un anagramme
        if (sortLetters($normalizedCandidate) === $sortedWord) {
            $matches[] = $candidate;
        }
    }

    return $matches;
}

/**
 * Fonction auxiliaire pour trier les lettres d'une chaîne UTF-8.
 */
function sortLetters(string $str): string
{
    $letters = mb_str_split($str);
    sort($letters);
    return implode('', $letters);
}