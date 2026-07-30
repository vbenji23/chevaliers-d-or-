<?php

declare(strict_types=1);

function meetup_day(int $year, int $month, string $which, string $weekday): DateTimeImmutable
{
    // Déterminer le jour de départ (baseline) en fonction du mot-clé ($which)
    switch ($which) {
        case 'first':
            $startDay = 1;
            break;
        case 'second':
            $startDay = 8;
            break;
        case 'third':
            $startDay = 15;
            break;
        case 'fourth':
            $startDay = 22;
            break;
        case 'teenth':
            $startDay = 13;
            break;
        case 'last':
            // Pour 'last', on commence à partir du dernier jour du mois
            $startDay = (int) (new DateTimeImmutable("{$year}-{$month}-01"))->format('t');
            break;
        default:
            throw new InvalidArgumentException("Option non reconnue : {$which}");
    }

    $date = new DateTimeImmutable("{$year}-{$month}-{$startDay}");

    // Si on cherche le 'last', on recule jusqu'au bon jour de la semaine
    if ($which === 'last') {
        while ($date->format('l') !== $weekday) {
            $date = $date->modify('-1 day');
        }
    } else {
        // Sinon, on avance jusqu'au bon jour de la semaine
        while ($date->format('l') !== $weekday) {
            $date = $date->modify('+1 day');
        }
    }

    return $date;
}