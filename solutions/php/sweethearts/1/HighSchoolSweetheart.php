<?php

class HighSchoolSweetheart
{
    /**
     * Nettoie les espaces superflus et renvoie le premier caractère du nom.
     */
    public function firstLetter(string $name): string
    {
        $trimmed = trim($name);
        return $trimmed[0];
    }

    /**
     * Renvoie la première lettre du nom en majuscule, suivie d'un point.
     */
    public function initial(string $name): string
    {
        $first = $this->firstLetter($name);
        return strtoupper($first) . '.';
    }

    /**
     * Prend un prénom et un nom séparés par un espace et renvoie les initiales (ex: "J. D.").
     */
    public function initials(string $name): string
    {
        $parts = explode(' ', $name);
        $firstInitial = $this->initial($parts[0]);
        $lastInitial = $this->initial($parts[1]);

        return $firstInitial . ' ' . $lastInitial;
    }

    /**
     * Génère le dessin ASCII du cœur avec les initiales des deux amoureux.
     */
    public function pair(string $sweetheart_a, string $sweetheart_b): string
    {
        $initialsA = $this->initials($sweetheart_a);
        $initialsB = $this->initials($sweetheart_b);

        return <<<HEART
     ******       ******
   **      **   **      **
 **         ** **         **
**            *            **
**                         **
**     $initialsA  +  $initialsB     **
 **                       **
   **                   **
     **               **
       **           **
         **       **
           **   **
             ***
              *
HEART;
    }
}