Function Get-ResistorLabel() {
    <#
    .SYNOPSIS
    Implement a function to get the label of a resistor with three color-coded bands.

    .DESCRIPTION
    Given an array of colors from a resistor, decode their resistance values and return a string represent the resistor's label.

    .PARAMETER Colors
    The array represent the 3 colors from left to right.

    .EXAMPLE
    Get-ResistorLabel -Colors @("red", "white", "blue")
    Return: "29 megaohms"
     #>
    [CmdletBinding()]
    Param(
        [string[]]$Colors
    )

    # Carte de correspondance couleur -> valeur
    $colorMap = @{
        'black'  = 0
        'brown'  = 1
        'red'    = 2
        'orange' = 3
        'yellow' = 4
        'green'  = 5
        'blue'   = 6
        'violet' = 7
        'grey'   = 8
        'white'  = 9
    }

    # Récupération des indices des 3 premières couleurs (en minuscules pour être incensible à la casse)
    $digit1 = $colorMap[$Colors[0].ToLower()]
    $digit2 = $colorMap[$Colors[1].ToLower()]
    $zeros  = $colorMap[$Colors[2].ToLower()]

    # Calcul de la valeur brute en Ohms
    # Ex: ("red", "black", "red") -> (2 * 10 + 0) * 10^2 = 2000 ohms
    [double]$ohms = ($digit1 * 10 + $digit2) * [Math]::Pow(10, $zeros)

    # Détermination du préfixe métrique (gigaohms, megaohms, kiloohms, ohms)
    if ($ohms -ge 1e9) {
        $value = $ohms / 1e9
        $unit  = "gigaohms"
    }
    elseif ($ohms -ge 1e6) {
        $value = $ohms / 1e6
        $unit  = "megaohms"
    }
    elseif ($ohms -ge 1e3) {
        $value = $ohms / 1e3
        $unit  = "kiloohms"
    }
    else {
        $value = $ohms
        $unit  = "ohms"
    }

    return "$value $unit"
}