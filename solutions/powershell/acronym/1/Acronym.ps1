Function Get-Acronym() {
    <#
    .SYNOPSIS
    Get the acronym of a phrase.

    .DESCRIPTION
    Given a phrase, return the string acronym of that phrase.
    "As Soon As Possible" => "ASAP"
    
    .PARAMETER Phrase
    The phrase to get the acronym from.
    
    .EXAMPLE
    Get-Acronym -Phrase "As Soon As Possible"
    #>
    [CmdletBinding()]
    Param (
        [string]$Phrase
    )

    # 1. Remplace les tirets et tirets bas par un espace pour séparer les mots
    $sanitized = $Phrase -replace '[-_]', ' '

    # 2. Supprime toutes les autres ponctuations (garde uniquement lettres, chiffres et espaces)
    $cleanText = $sanitized -replace '[^\w\s]', ''

    # 3. Découpe la phrase en mots en ignorant les espaces consécutifs
    $words = $cleanText -split '\s+' | Where-Object { $_ -ne '' }

    # 4. Extrait la première lettre de chaque mot et la met en majuscule
    $acronymLetters = foreach ($word in $words) {
        $word[0].ToString().ToUpper()
    }

    return -join $acronymLetters
}