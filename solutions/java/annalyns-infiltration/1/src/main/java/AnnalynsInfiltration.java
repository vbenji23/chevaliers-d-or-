class AnnalynsInfiltration {

    // 1. Attaque rapide : possible uniquement si le chevalier dort
    public static boolean canFastAttack(boolean knightIsAwake) {
        return !knightIsAwake;
    }

    // 2. Espionner : possible si au moins une personne est éveillée
    public static boolean canSpy(boolean knightIsAwake, boolean archerIsAwake, boolean prisonerIsAwake) {
        return knightIsAwake || archerIsAwake || prisonerIsAwake;
    }

    // 3. Signaler le prisonnier : le prisonnier doit être éveillé ET l'archer endormi
    public static boolean canSignalPrisoner(boolean archerIsAwake, boolean prisonerIsAwake) {
        return prisonerIsAwake && !archerIsAwake;
    }

    // 4. Libérer le prisonnier :
    // - Option A : Si le chien est présent, il faut juste que l'archer meure de peur / soit endormi (!archerIsAwake).
    // - Option B : Sans le chien, le prisonnier doit être éveillé ET le chevalier et l'archer doivent tous deux dormir.
    public static boolean canFreePrisoner(boolean knightIsAwake, boolean archerIsAwake, boolean prisonerIsAwake, boolean petDogIsPresent) {
        if (petDogIsPresent) {
            return !archerIsAwake;
        } else {
            return prisonerIsAwake && !knightIsAwake && !archerIsAwake;
        }
    }
}