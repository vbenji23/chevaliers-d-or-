<?php

class LuckyNumbers
{
    /**
     * Reçoit deux tableaux de chiffres, les convertit en nombres et renvoie leur somme.
     */
    public function sumUp(array $digitsOfNumber1, array $digitsOfNumber2): int
    {
        $num1 = (int) implode('', $digitsOfNumber1);
        $num2 = (int) implode('', $digitsOfNumber2);

        return $num1 + $num2;
    }

    /**
     * Vérifie si un nombre est un palindrome (se lit de la même façon dans les deux sens).
     */
    public function isPalindrome(int $number): bool
    {
        $str = (string) $number;
        return $str === strrev($str);
    }

    /**
     * Valide la saisie d'un utilisateur.
     */
    public function validate(string $input): string
    {
        if ($input === '') {
            return 'Required field';
        }

        $number = (int) $input;

        if ($number <= 0) {
            return 'Must be a whole number larger than 0';
        }

        return '';
    }
}