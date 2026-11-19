Function Get-SquareRoot() {
    <#
    .SYNOPSIS
    Given a natural radicand, return its square root.
    
    .DESCRIPTION
    The function takes a positive integer and return its square root value.

    .PARAMETER Radicand
    The number to get its square root.
    
    .EXAMPLE
    Get-SquareRoot -Radicand 25
    Retuns: 5
    #>
    [CmdletBinding()]
    Param(
        [int]$Radicand
    )

    if ($Radicand -le 0) {
        return 0
    }

    $low = 1
    $high = $Radicand

    while ($low -le $high) {
        $mid = [math]::Floor(($low + $high) / 2)
        $square = $mid * $mid

        if ($square -eq $Radicand) {
            return $mid
        } elseif ($square -lt $Radicand) {
            $low = $mid + 1
        } else {
            $high = $mid - 1
        }
    }

    return $high
}