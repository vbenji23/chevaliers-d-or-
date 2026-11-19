Function Get-ColorCodeValue() {
    <#
    .SYNOPSIS
    Translate a list of colors to their corresponding color code values.

    .DESCRIPTION
    Given 2 colors, take the first one and times it by 10 and add the second color to it.

    .PARAMETER Colors
    The colors to translate to their corresponding color codes.

    .EXAMPLE
    Get-ColorCodeValue -Colors @("black", "brown")
    #>
    [CmdletBinding()]
    Param(
        [string[]]$Colors
    )

    # Définition de l'ordre des couleurs (l'index correspond à la valeur)
    $colorMap = @(
        'black',
        'brown',
        'red',
        'orange',
        'yellow',
        'green',
        'blue',
        'violet',
        'grey',
        'white'
    )

    # Récupération des deux premières couleurs (en ignorant les suivantes)
    $firstColorIndex  = $colorMap.IndexOf($Colors[0].ToLower())
    $secondColorIndex = $colorMap.IndexOf($Colors[1].ToLower())

    # Calcul du code à deux chiffres
    return ($firstColorIndex * 10) + $secondColorIndex
}