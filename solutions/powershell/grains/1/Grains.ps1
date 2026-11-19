Function Get-GrainSquare() {
    <#
    .SYNOPSIS
    Get the number of grains on a square.

    .DESCRIPTION
    Given a number, return the number of grains on that square.
    
    .PARAMETER Number
    Which square to get the number of grains.
    
    .EXAMPLE
    Get-GrainSquare -Number 2
    #>
    [CmdletBinding()]
    Param(
        [BigInt]$Number
    )

    if ($Number -lt 1 -or $Number -gt 64) {
        Throw "square must be between 1 and 64"
    }

    # Sur la case N, le nombre de grains est 2^(N-1)
    return [System.Numerics.BigInteger]::Pow(2, [int]$Number - 1)
}

Function Get-GrainTotal() {
    <#
    .SYNOPSIS
    Get the total number of grains.

    .DESCRIPTION
    Return the total number of grains on the board.

    .EXAMPLE
    Get-GrainTotal
    #>
    
    # La somme des grains sur un échiquier de 64 cases est 2^64 - 1
    return [System.Numerics.BigInteger]::Pow(2, 64) - 1
}