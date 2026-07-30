Function Invoke-Diamond() {
    <#
    .SYNOPSIS
    Given a letter, output a diamond shape.

    .DESCRIPTION
    Take a letter of the alphabet, return a string in a diamond shape starting with 'A', with the supplied letter at the widest point.
    The output should use only capitalized letters, however the input should be case-insensitive.

    .PARAMETER Letter
    The letter used to decide the shape of the diamond.

    .EXAMPLE
    Invoke-Diamond -Letter D
    Return:
    @"
       A   
      B B  
     C   C 
    D     D
     C   C 
      B B  
       A   
    "@ 
    #>
    [CmdletBinding()]
    Param(
        [char]$Letter
    )

    $targetChar = [char]::ToUpper($Letter)
    $maxIndex = [int]$targetChar - [int][char]'A'

    # Si la lettre est 'A', le test attend la chaîne "A`n"
    if ($maxIndex -eq 0) {
        return "A`n"
    }

    # Séquence d'indices : de 0 à maxIndex, puis de (maxIndex-1) jusqu'à 0
    $indices = 0..$maxIndex + ($maxIndex - 1)..0

    $rows = foreach ($i in $indices) {
        $char = [char]([int][char]'A' + $i)
        $outerPadding = ' ' * ($maxIndex - $i)

        if ($i -eq 0) {
            "$outerPadding$char$outerPadding"
        } else {
            $innerPadding = ' ' * (2 * $i - 1)
            "$outerPadding$char$innerPadding$char$outerPadding"
        }
    }

    return $rows -join "`r`n"
}