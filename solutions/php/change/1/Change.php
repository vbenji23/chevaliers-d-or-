<?php

declare(strict_types=1);

function findFewestCoins(array $coins, int $amount): array
{
    if ($amount === 0) {
        return [];
    }

    if ($amount < 0) {
        throw new InvalidArgumentException("Cannot make change for negative value");
    }

    if (empty($coins) || $amount < min($coins)) {
        throw new InvalidArgumentException("No coins small enough to make change");
    }

    // $minCoins[$i] stockera la liste optimale de pièces pour obtenir la somme $i
    $minCoins = array_fill(0, $amount + 1, null);
    $minCoins[0] = [];

    for ($i = 1; $i <= $amount; $i++) {
        foreach ($coins as $coin) {
            if ($i < $coin) {
                continue;
            }

            $previousAmount = $i - $coin;
            if ($minCoins[$previousAmount] !== null) {
                $candidate = array_merge($minCoins[$previousAmount], [$coin]);

                if ($minCoins[$i] === null || count($candidate) < count($minCoins[$i])) {
                    $minCoins[$i] = $candidate;
                }
            }
        }
    }

    if ($minCoins[$amount] === null) {
        throw new InvalidArgumentException("No combination can add up to target");
    }

    sort($minCoins[$amount]);

    return $minCoins[$amount];
}
