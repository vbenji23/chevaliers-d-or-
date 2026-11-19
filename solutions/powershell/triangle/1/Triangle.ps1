Enum Triangle {
    EQUILATERAL
    ISOSCELES
    SCALENE
}

Function Get-Triangle() {
    <#
    .SYNOPSIS
    Determine if a triangle is equilateral, isosceles, or scalene.

    .DESCRIPTION
    Given 3 sides of a triangle, return the type of that triangle if it is a valid triangle.
    
    .PARAMETER Sides
    The lengths of a triangle's sides.

    .EXAMPLE
    Get-Triangle -Sides @(1,2,3)
    Return: [Triangle]::SCALENE
    #>
    [CmdletBinding()]
    Param (
        [double[]]$Sides
    )

    # 1. Vérification que tous les côtés ont une longueur strictement positive (> 0)
    foreach ($side in $Sides) {
        if ($side -le 0) {
            throw "All side lengths must be positive."
        }
    }

    $a = $Sides[0]
    $b = $Sides[1]
    $c = $Sides[2]

    # 2. Vérification de l'inégalité triangulaire (a + b >= c, b + c >= a, a + c >= b)
    if (($a + $b -lt $c) -or ($b + $c -lt $a) -or ($a + $c -lt $b)) {
        throw "Side lengths violate triangle inequality."
    }

    # 3. Évaluation du type de triangle selon le nombre de côtés distincts
    $uniqueSides = ($Sides | Select-Object -Unique).Count

    switch ($uniqueSides) {
        1 { return [Triangle]::EQUILATERAL }
        2 { return [Triangle]::ISOSCELES }
        3 { return [Triangle]::SCALENE }
    }
}