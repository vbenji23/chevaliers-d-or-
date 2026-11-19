Enum Sublist {
    EQUAL
    UNEQUAL
    SUBLIST
    SUPERLIST
}

Function Invoke-Sublist() {
    <#
    .SYNOPSIS
    Determine the relationship of two arrays.

    .DESCRIPTION
    Given two arrays, determine the relationship of the first array relating to the second array.
    There are four possible categories: EQUAL, UNEQUAL, SUBLIST and SUPERLIST.
    Note: This exercise use Enum values for return.
    
    .PARAMETER Data1
    The first array

    .PARAMETER Data2
    The second array

    .EXAMPLE
    Invoke-Sublist -Data1 @(1,2,3) -Data2 @(1,2,3)
    Return: [Sublist]::EQUAL

    Invoke-Sublist -Data1 @(1,2) -Data2 @(1,2,3)
    Return: [Sublist]::SUBLIST
    #>
    [CmdletBinding()]
    Param (
        [object[]]$Data1,
        [object[]]$Data2
    )

    # Convertit $null en tableau vide pour la cohérence
    if ($null -eq $Data1) { $Data1 = @() }
    if ($null -eq $Data2) { $Data2 = @() }

    $len1 = $Data1.Count
    $len2 = $Data2.Count

    # Fonction auxiliaire pour vérifier si $sub est une sous-séquence contiguë de $main
    Function Test-IsSublist([object[]]$sub, [object[]]$main) {
        $subLen = $sub.Count
        $mainLen = $main.Count

        # Un tableau vide est une sous-liste de n'importe quel tableau
        if ($subLen -eq 0) { return $true }
        if ($subLen -gt $mainLen) { return $false }

        # Recherche de la sous-séquence
        $maxOffset = $mainLen - $subLen
        for ($i = 0; $i -le $maxOffset; $i++) {
            $match = $true
            for ($j = 0; $j -lt $subLen; $j++) {
                if ($sub[$j] -cne $main[$i + $j]) {
                    $match = $false
                    break
                }
            }
            if ($match) { return $true }
        }
        return $false
    }

    # Cas 1 : Longueurs égales
    if ($len1 -eq $len2) {
        if (Test-IsSublist $Data1 $Data2) {
            return [Sublist]::EQUAL
        }
        return [Sublist]::UNEQUAL
    }

    # Cas 2 : Data1 est plus petit que Data2 (Sublist potentielle)
    if ($len1 -lt $len2) {
        if (Test-IsSublist $Data1 $Data2) {
            return [Sublist]::SUBLIST
        }
        return [Sublist]::UNEQUAL
    }

    # Cas 3 : Data1 est plus grand que Data2 (Superlist potentielle)
    if ($len1 -gt $len2) {
        if (Test-IsSublist $Data2 $Data1) {
            return [Sublist]::SUPERLIST
        }
        return [Sublist]::UNEQUAL
    }
}