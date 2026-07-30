Function Invoke-Anagram() {
    <#
    .SYNOPSIS
    Determine if a word is an anagram of other words in a list.

    .DESCRIPTION
    An anagram is a word formed by rearranging the letters of another word, e.g., spar, formed from rasp.
    Given a word and a list of possible anagrams, find the anagrams in the list.

    .PARAMETER Subject
    The word to check

    .PARAMETER Candidates
    The list of possible anagrams

    .EXAMPLE
    Invoke-Anagram -Subject "listen" -Candidates @("enlists", "google", "inlets", "banana")
    #>
    [CmdletBinding()]
    Param(
        [string]$Subject,
        [string[]]$Candidates
    )

    # Fonction locale pour trier les caractères d'un mot
    function Get-SortedChars([string]$word) {
        $chars = $word.ToLower().ToCharArray()
        [Array]::Sort($chars)
        return -join $chars
    }

    $subjectLower = $Subject.ToLower()
    $subjectSorted = Get-SortedChars $Subject

    $result = [System.Collections.Generic.List[string]]::new()

    foreach ($candidate in $Candidates) {
        $candidateLower = $candidate.ToLower()

        # Un mot ne peut pas être son propre anagramme (même insensible à la casse)
        if ($candidateLower -eq $subjectLower) {
            continue
        }

        # Deux anagrammes doivent contenir exactement les mêmes lettres triées
        if ((Get-SortedChars $candidate) -eq $subjectSorted) {
            $result.Add($candidate)
        }
    }

    return ,$result.ToArray()
}
