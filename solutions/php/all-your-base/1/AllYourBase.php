<?php

declare(strict_types=1);

function rebase(int $fromBase, array $digits, int $toBase): array
{
    if ($fromBase < 2) {
        throw new InvalidArgumentException('input base must be >= 2');
    }

    if ($toBase < 2) {
        throw new InvalidArgumentException('output base must be >= 2');
    }

    $decimalValue = 0;

    foreach ($digits as $digit) {
        if ($digit < 0 || $digit >= $fromBase) {
            throw new InvalidArgumentException('all digits must satisfy 0 <= d < input base');
        }

        $decimalValue = $decimalValue * $fromBase + $digit;
    }

    if ($decimalValue === 0) {
        return [0];
    }

    $resultDigits = [];

    while ($decimalValue > 0) {
        array_unshift($resultDigits, $decimalValue % $toBase);
        $decimalValue = intdiv($decimalValue, $toBase);
    }

    return $resultDigits;
}
