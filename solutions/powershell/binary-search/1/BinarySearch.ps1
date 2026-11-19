Function Invoke-BinarySearch() {
    <#
    .SYNOPSIS
    Perform a binary search on a sorted array.

    .DESCRIPTION
    Take an array of integers and a search value and return the index of the value in the array.

    .PARAMETER Array
    The array to search.

    .PARAMETER Value
    The value to search for.

    .EXAMPLE
    Invoke-BinarySearch -Array @(1, 2, 3, 4, 5) -Value 3
    #>
    [CmdletBinding()]
    Param(
        [Int64[]]$Array,
        [Int64]$Value
    )

    $left = 0
    $right = $Array.Count - 1

    while ($left -le $right) {
        # Calcul de l'index du milieu (pour éviter un dépassement de capacité avec de très grands tableaux)
        $mid = $left + [Math]::Floor(($right - $left) / 2)

        if ($Array[$mid] -eq $Value) {
            return $mid
        }
        elseif ($Array[$mid] -lt $Value) {
            $left = $mid + 1
        }
        else {
            $right = $mid - 1
        }
    }

    # Si la valeur n'est pas trouvée, lever une exception avec le message attendu
    throw "error: value not in array"
}
