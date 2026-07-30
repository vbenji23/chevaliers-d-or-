<?php

declare(strict_types=1);

function brackets_match(string $input): bool
{
    $stack = [];
    
    // Correspondance entre les fermetures et leurs ouvertures associées
    $pairs = [
        ']' => '[',
        '}' => '{',
        ')' => '(',
    ];

    $length = strlen($input);

    for ($i = 0; $i < $length; $i++) {
        $char = $input[$i];

        // Si c'est un caractère d'ouverture, on l'ajoute à la pile
        if (in_array($char, ['[', '{', '('], true)) {
            $stack[] = $char;
        } 
        // Si c'est un caractère de fermeture
        elseif (isset($pairs[$char])) {
            // Si la pile est vide ou si l'ouverture dépilée ne correspond pas
            if (empty($stack) || array_pop($stack) !== $pairs[$char]) {
                return false;
            }
        }
    }

    // La chaîne est valide uniquement si tous les symboles ouverts ont été fermés
    return empty($stack);
}