Function Invoke-Isogram() {
    <#
    .SYNOPSIS
    Determine if a word or phrase is an isogram.
    
    .DESCRIPTION
    An isogram (also known as a "nonpattern word") is a word or phrase without a repeating letter,
    however spaces and hyphens are allowed to appear multiple times.
    
    .PARAMETER Phrase
    The phrase to check if it is an isogram.
    
    .EXAMPLE
    Invoke-Isogram -Phrase "isogram"
    
    Returns: $true
    #>
    [CmdletBinding()]
    Param(
        [string]$Phrase
    )

    $seenLetters = [System.Collections.Generic.HashSet[char]]::new()

    foreach ($char in $Phrase.ToLower().ToCharArray()) {
        # Ignorer les espaces et les traits d'union
        if ($char -eq ' ' -or $char -eq '-') {
            continue
        }

        # [char]::IsLetter s'assure que l'on vérifie bien les lettres (y compris Unicode)
        if ([char]::IsLetter($char)) {
            if (-not $seenLetters.Add($char)) {
                return $false
            }
        }
    }

    return $true
}