<?php

declare(strict_types=1);

function steps(int $number): int
{
    if ($number <= 0) {
        throw new InvalidArgumentException("Only positive integers are allowed");
    }

    $stepCount = 0;

    while ($number > 1) {
        if ($number % 2 === 0) {
            $number = $number / 2;
        } else {
            $number = ($number * 3) + 1;
        }
        $stepCount++;
    }

    return $stepCount;
}