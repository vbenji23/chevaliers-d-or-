<?php

declare(strict_types=1);

function transform(array $input): array
{
    $result = [];

    foreach ($input as $score => $letters) {
        foreach ($letters as $letter) {
            $result[strtolower($letter)] = (int) $score;
        }
    }

    // Optionnel : tri des clés par ordre alphabétique si nécessaire
    ksort($result);

    return $result;
}