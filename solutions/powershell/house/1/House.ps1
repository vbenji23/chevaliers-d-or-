Function Get-Rhyme() {
    <#
    .SYNOPSIS
    Recite the nursery rhyme 'This is the House that Jack Built'.

    .DESCRIPTION
    Given the start verse and the end verse, return a string reciting the rhyme from that range.

    .PARAMETER Start
    The start verse.

    .PARAMETER End
    The end verse.

    .EXAMPLE
    Get-Rhyme -Start 1 -End 2
    #>
    [CmdletBinding()]
    Param(
        [int]$Start,
        [int]$End
    )

    # Décomposition de chaque partie (sujet/action) dans l'ordre inverse
    $parts = @(
        @{ Subject = "house that Jack built."; Action = "" },
        @{ Subject = "malt"; Action = "that lay in the " },
        @{ Subject = "rat"; Action = "that ate the " },
        @{ Subject = "cat"; Action = "that killed the " },
        @{ Subject = "dog"; Action = "that worried the " },
        @{ Subject = "cow with the crumpled horn"; Action = "that tossed the " },
        @{ Subject = "maiden all forlorn"; Action = "that milked the " },
        @{ Subject = "man all tattered and torn"; Action = "that kissed the " },
        @{ Subject = "priest all shaven and shorn"; Action = "that married the " },
        @{ Subject = "rooster that crowed in the morn"; Action = "that woke the " },
        @{ Subject = "farmer sowing his corn"; Action = "that kept the " },
        @{ Subject = "horse and the hound and the horn"; Action = "that belonged to the " }
    )

    $verses = [System.Collections.Generic.List[string]]::new()

    for ($n = $Start; $n -le $End; $n++) {
        # Construction du couplet $n
        $currentVerse = "This is the " + $parts[$n - 1].Subject

        for ($i = $n - 1; $i -gt 0; $i--) {
            $currentVerse += " " + $parts[$i].Action + $parts[$i - 1].Subject
        }

        $verses.Add($currentVerse)
    }

    return $verses -join "`n"
}