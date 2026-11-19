Function Test-Isbn() {
    <#
    .SYNOPSIS
    Determine if an ISBN is valid or not.
    
    .DESCRIPTION
    Given a string the function should check if the provided string is a valid ISBN-10.
    
    .PARAMETER Isbn
    The ISBN to check
    
    .EXAMPLE
    Test-Isbn -Isbn "3-598-21508-8"
    
    Returns: $true
    #>
    [CmdletBinding()]
    Param(
        [string]$Isbn
    )

    # 1. Retirer les tirets de la chaîne
    $clean = $Isbn -replace '-', ''

    # 2. Vérifier que la longueur nettoyée soit exactement de 10 caractères
    if ($clean.Length -ne 10) {
        return $false
    }

    # 3. Vérifier la validité du format avec une expression régulière :
    #    9 chiffres suivis d'un chiffre ou d'un 'X' (ou 'x')
    if ($clean -notmatch '^\d{9}[\dX]$') {
        return $false
    }

    # 4. Calculer la somme pondérée
    $sum = 0
    for ($i = 0; $i -lt 10; $i++) {
        $char = $clean[$i]
        $weight = 10 - $i

        if ($char -eq 'X' -or $char -eq 'x') {
            $val = 10
        } else {
            $val = [int]::Parse($char.ToString())
        }

        $sum += $val * $weight
    }

    # 5. Vérifier si le résultat est divisible par 11
    return ($sum % 11 -eq 0)
}
