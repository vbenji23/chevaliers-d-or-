<?php

class Form
{
    public function blanks(int $length): string
    {
        return str_repeat(' ', $length);
    }

    public function letters(string $word): array
    {
        return mb_str_split($word);
    }

    public function checkLength(string $word, int $max_length): bool
    {
        return mb_strlen($word) <= $max_length;
    }

    public function formatAddress(Address $address): string
    {
        $formattedStreet = mb_strtoupper($address->street);
        $formattedPostalCode = mb_strtoupper($address->postal_code);
        $formattedCity = mb_strtoupper($address->city);

        return "{$formattedStreet}\n{$formattedPostalCode} {$formattedCity}";
    }
}