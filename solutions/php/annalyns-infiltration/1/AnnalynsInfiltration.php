<?php

class AnnalynsInfiltration
{
    /**
     * Attaque rapide : possible uniquement si le chevalier dort.
     */
    public function canFastAttack($is_knight_awake)
    {
        return !$is_knight_awake;
    }

    /**
     * Espionner : possible si au moins un des trois personnages est réveillé.
     */
    public function canSpy(
        $is_knight_awake,
        $is_archer_awake,
        $is_prisoner_awake
    ) {
        return $is_knight_awake || $is_archer_awake || $is_prisoner_awake;
    }

    /**
     * Signaler le prisonnier : possible si le prisonnier est réveillé ET l'archer dort.
     */
    public function canSignal(
        $is_archer_awake,
        $is_prisoner_awake
    ) {
        return $is_prisoner_awake && !$is_archer_awake;
    }

    /**
     * Libérer le prisonnier :
     * - Avec le chien : possible si l'archer dort.
     * - Sans le chien : possible si le prisonnier est réveillé ET que le chevalier et l'archer dorment.
     */
    public function canLiberate(
        $is_knight_awake,
        $is_archer_awake,
        $is_prisoner_awake,
        $is_dog_present
    ) {
        if ($is_dog_present) {
            return !$is_archer_awake;
        }

        return $is_prisoner_awake && !$is_knight_awake && !$is_archer_awake;
    }
}