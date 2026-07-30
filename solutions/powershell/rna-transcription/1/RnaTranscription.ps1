Function Invoke-RnaTranscription() {
    <#
    .SYNOPSIS
    Transcribe a DNA strand into RNA.

    .DESCRIPTION
    Given a DNA strand, return its RNA complement (per RNA transcription).

    .PARAMETER Strand
    The DNA strand to transcribe.

    .EXAMPLE
    Invoke-RnaTranscription -Strand "A"
    #>
    [CmdletBinding()]
    Param(
        [string]$Strand
    )

    if ([string]::IsNullOrEmpty($Strand)) {
        return ""
    }

    # Table de correspondance ADN -> ARN
    $transcriptionMap = @{
        'G' = 'C'
        'C' = 'G'
        'T' = 'A'
        'A' = 'U'
    }

    # Convertir chaque nucléotide selon la table
    $rnaChars = foreach ($char in $Strand.ToCharArray()) {
        $transcriptionMap[[string]$char]
    }

    return -join $rnaChars
}
