<?php

class Lasagna
{
    /**
     * Retourne le temps de cuisson total attendu au four (40 minutes).
     */
    public function expectedCookTime()
    {
        return 40;
    }

    /**
     * Calcule le temps de cuisson restant au four.
     */
    public function remainingCookTime($elapsed_minutes)
    {
        return $this->expectedCookTime() - $elapsed_minutes;
    }

    /**
     * Calcule le temps de préparation en minutes (2 minutes par couche).
     */
    public function totalPreparationTime($layers_to_prep)
    {
        return $layers_to_prep * 2;
    }

    /**
     * Calcule le temps total écoulé (temps de préparation + temps de cuisson actuel).
     */
    public function totalElapsedTime($layers_to_prep, $elapsed_minutes)
    {
        return $this->totalPreparationTime($layers_to_prep) + $elapsed_minutes;
    }

    /**
     * Alerte pour signaler que la lasagne est prête.
     */
    public function alarm()
    {
        return "Ding!";
    }
}