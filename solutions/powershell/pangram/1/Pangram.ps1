Function Invoke-Panagram() {
    <#
    .SYNOPSIS
    Determine if a sentence is a pangram.
    
    .DESCRIPTION
    A pangram is a sentence using every letter of the alphabet at least once.
    
    .PARAMETER Sentence
    The sentence to check
    
    .EXAMPLE
    Invoke-Panagram -Sentence "The quick brown fox jumps over the lazy dog"
    
    Returns: $true
    #>
    [CmdletBinding()]
    Param(
        [string]$Sentence
    )

    # Convertir en minuscules et ne garder que les lettres de 'a' à 'z'
    $uniqueLetters = [System.Collections.Generic.HashSet[char]]::new()

    foreach ($char in $Sentence.ToLower().ToCharArray()) {
        if ($char -ge 'a' -and $char -le 'z') {
            [void]$uniqueLetters.Add($char)
        }
    }

    # Un pangramme doit contenir les 26 lettres uniques de l'alphabet anglais
    return $uniqueLetters.Count -eq 26
}