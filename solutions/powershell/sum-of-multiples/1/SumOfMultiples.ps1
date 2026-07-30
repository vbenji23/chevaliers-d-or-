Function Get-SumOfMultiples {
    <#
    .SYNOPSIS
    Given a number, find the sum of all the unique multiples of particular numbers up to
    but not including that number.

    .DESCRIPTION
    If we list all the natural numbers below 20 that are multiples of 3 or 5,
    we get 3, 5, 6, 9, 10, 12, 15, and 18.

    .PARAMETER Multiples
    An array of the factors 

    .PARAMETER Limit
    The value BELOW which we test for

    .EXAMPLE
    Get-SumOfMultiples -Multiples @(3, 5) -Limit 10
    
    Returns 23
    #>
    [CmdletBinding()]
    Param(
        [int[]]$Multiples,
        [int]$Limit
    )

    # Filtrer les facteurs nuls ou négatifs pour éviter les boucles infinies
    $validMultiples = $Multiples | Where-Object { $_ -gt 0 }

    # S'il n'y a aucun facteur valide ou si la limite est <= 1, la somme est 0
    if (-not $validMultiples -or $Limit -le 1) {
        return 0
    }

    # Utiliser un HashSet pour garantir l'unicité des multiples
    $uniqueMultiples = [System.Collections.Generic.HashSet[int]]::new()

    foreach ($factor in $validMultiples) {
        for ($i = $factor; $i -lt $Limit; $i += $factor) {
            [void]$uniqueMultiples.Add($i)
        }
    }

    # Calculer la somme
    $sum = 0
    foreach ($num in $uniqueMultiples) {
        $sum += $num
    }

    return $sum
}