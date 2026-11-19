<?php

declare(strict_types=1);

/**
 * Encode un texte en utilisant le chiffre Atbash (avec séparation par blocs de 5 caractères).
 */
function encode(string $text): string
{
    $transformed = substituteAtbash($text);
    
    // Découpe le texte transformé en blocs de 5 caractères
    $chunks = str_split($transformed, 5);
    
    return implode(' ', $chunks);
}

/**
 * Décode un texte chiffré avec Atbash.
 */
function decode(string $text): string
{
    return substituteAtbash($text);
}

/**
 * Fonction auxiliaire qui applique la substitution Atbash :
 * - Convertit en minuscules
 * - Conserve uniquement les lettres a-z et les chiffres 0-9
 * - Inverse les lettres (a <-> z)
 */
function substituteAtbash(string $text): string
{
    $text = strtolower($text);
    $result = '';

    for ($i = 0; $i < strlen($text); $i++) {
        $char = $text[$i];

        if (ctype_lower($char)) {
            // Substitution Atbash : 'a' (ASCII 97) + 'z' (ASCII 122) = 219
            $result .= chr(219 - ord($char));
        } elseif (ctype_digit($char)) {
            // Les chiffres restent inchangés
            $result .= $char;
        }
    }

    return $result;
}
