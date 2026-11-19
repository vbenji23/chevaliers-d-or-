public class Lasagna {
    
    // 1. Renvoie le temps total prévu au four (40 minutes)
    public int expectedMinutesInOven() {
        return 40;
    }

    // 2. Calcule le temps restant au four
    public int remainingMinutesInOven(int actualMinutesInOven) {
        return expectedMinutesInOven() - actualMinutesInOven;
    }

    // 3. Calcule le temps de préparation (2 minutes par couche)
    public int preparationTimeInMinutes(int numberOfLayers) {
        return numberOfLayers * 2;
    }

    // 4. Calcule le temps total passé sur la lasagne (préparation + cuisson actuelle)
    public int totalTimeInMinutes(int numberOfLayers, int actualMinutesInOven) {
        return preparationTimeInMinutes(numberOfLayers) + actualMinutesInOven;
    }
}