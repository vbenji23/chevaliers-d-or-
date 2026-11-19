Function Invoke-PerfectNumbers() {
    <#
    .SYNOPSIS
    Determine if a number is perfect, abundant, or deficient based on Nicomachus' (60 - 120 CE) classification scheme for natural numbers.

    .DESCRIPTION
    Calculate the aliquot sum of a number: the sum of its positive divisors not including the number itself.
    Compare the sum to the original number.
    Determine the classification: perfect, abundant, or deficient.

    .PARAMETER Number
    The number to perform the classification on.

    .EXAMPLE
    Invoke-PerfectNumbers -Number 12
    #>
    [CmdletBinding()]
    Param(
        [Int64]$Number
    )

    # Validation de l'entrée : doit être un entier strictement positif
    if ($Number -le 0) {
        Throw "error: Classification is only possible for positive integers."
    }

    # Le nombre 1 n'a aucun diviseur propre (somme d'aliquotes = 0)
    if ($Number -eq 1) {
        return "deficient"
    }

    # Calcul de la somme des diviseurs propres (aliquot sum)
    [Int64]$aliquotSum = 1
    [Int64]$i = 2

    while ($i * $i -le $Number) {
        if ($Number % $i -eq 0) {
            $aliquotSum += $i
            $otherDivisor = $Number / $i
            if ($i -ne $otherDivisor) {
                $aliquotSum += $otherDivisor
            }
        }
        $i++
    }

    # Classification selon le schéma de Nicomaque
    if ($aliquotSum -eq $Number) {
        return "perfect"
    }
    elseif ($aliquotSum -gt $Number) {
        return "abundant"
    }
    else {
        return "deficient"
    }
}