Function Invoke-Etl() {
    <#
    .SYNOPSIS
    Transforms a set of legacy Lexiconia data stored as letters per score to a set of data stored score per letter.

    .DESCRIPTION
    Take a hash table and take the values as keys and the keys as values.

    .PARAMETER Legacy
    The legacy data to transform.

    .EXAMPLE
    Invoke-Etl -Legacy @{1 = @("A")}
    #>
    [CmdletBinding()]
    Param(
        [object]$Legacy
    )

    $result = [ordered]@{}

    foreach ($score in $Legacy.Keys) {
        $letters = $Legacy[$score]
        
        foreach ($letter in $letters) {
            # Convertit chaque lettre en minuscule et lui assigne la valeur du score (convertie en int)
            $lowerLetter = $letter.ToLower()
            $result[$lowerLetter] = [int]$score
        }
    }

    return $result
}