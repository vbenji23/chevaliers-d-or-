<?php

class PizzaPi
{
    /**
     * Calcule la quantité de pâte nécessaire en grammes.
     * Formule : pizzas * ((persons * 20) + 200)
     */
    public function calculateDoughRequirement(int $pizzas, int $persons): int
    {
        return $pizzas * (($persons * 20) + 200);
    }

    /**
     * Calcule le nombre de boîtes de sauce nécessaires (125 mL par pizza).
     * On utilise ceil() pour s'assurer d'avoir assez de boîtes (arrondi au supérieur).
     */
    public function calculateSauceRequirement(int $pizzas, int $sauceCanVolume): int
    {
        $saucePerPizza = 125;
        return (int) ceil(($pizzas * $saucePerPizza) / $sauceCanVolume);
    }

    /**
     * Calcule le nombre de pizzas couvertes par un cube de fromage.
     * Formule : (cheese_dimension³) / (thickness * PI * diameter)
     * On utilise floor() pour arrondir à l'entier inférieur.
     */
    public function calculateCheeseCubeCoverage(float $cheeseDimension, float $thickness, float $diameter): int
    {
        $pizzas = ($cheeseDimension ** 3) / ($thickness * M_PI * $diameter);
        return (int) floor($pizzas);
    }

    /**
     * Calcule le nombre de parts de pizza restantes.
     * Chaque pizza est découpée en 8 parts.
     */
    public function calculateLeftOverSlices(int $pizzas, int $friends): int
    {
        $totalSlices = $pizzas * 8;
        return $totalSlices % $friends;
    }
}