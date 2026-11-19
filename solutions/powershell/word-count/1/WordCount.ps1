Function Get-WordCount() {
    <#
    .SYNOPSIS
    Given a phrase, count how many time each word appear.

    .DESCRIPTION
    Count how many time each word appear in a phrase. Number in string also counted as word, and words are case insensitive.

    .PARAMETER Phrase
    The phrase to count words.

    .EXAMPLE
    Get-WordCount -Phrase "Hello, welcome to exercism!"
    Return: @{ hello = 1; welcome = 1; to = 1; exercism = 1}
    #>
    [CmdletBinding()]
    Param(
        [string]$Phrase
    )

    $counts = @{}

    # 1. Remplacer les caractères de soulignement par des espaces pour traiter '_' comme un séparateur
    $cleanedPhrase = $Phrase -replace '_', ' '

    # 2. Extraire les mots (mots isolés ou mots avec apostrophe interne comme "can't")
    $matches = [regex]::Matches($cleanedPhrase.ToLower(), "\b[a-z0-9]+(?:'[a-z0-9]+)?\b")

    foreach ($match in $matches) {
        $word = $match.Value
        if ($counts.ContainsKey($word)) {
            $counts[$word]++
        } else {
            $counts[$word] = 1
        }
    }

    return $counts
}