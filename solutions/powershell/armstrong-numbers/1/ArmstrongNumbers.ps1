Function Invoke-ArmstrongNumbers() {
    <#
    .SYNOPSIS
    Determine if a number is an Armstrong number.

    .DESCRIPTION
    An Armstrong number is a number that is the sum of its own digits each raised to the power of the number of digits.

    .PARAMETER Number
    The number to check.

    .EXAMPLE
    Invoke-ArmstrongNumbers -Number 153
    #>
    [CmdletBinding()]
    Param(
        [Int64]$Number
    )

    # Convertir le nombre en chaîne de caractères pour extraire ses chiffres
    $digitsStr = $Number.ToString()
    $numDigits = $digitsStr.Length

    $sum = [Int64]0

    foreach ($char in $digitsStr.ToCharArray()) {
        # Convertir le caractère numérique en valeur entière (ex: '5' -> 5)
        $digit = [char]::GetNumericValue($char)
        $sum += [Math]::Pow($digit, $numDigits)
    }

    # Vérifier si la somme calculée est égale au nombre d'origine
    return $sum -eq $Number
}
