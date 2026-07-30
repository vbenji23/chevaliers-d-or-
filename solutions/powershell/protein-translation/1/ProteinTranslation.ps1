Function Invoke-ProteinTranslation() {
    <#
    .SYNOPSIS
    Translate RNA sequences into proteins.

    .DESCRIPTION
    Take an RNA sequence and convert it into codons and then into the name of the proteins in the form of a list.

    .PARAMETER Strand
    The RNA sequence to translate.

    .EXAMPLE
    Invoke-ProteinTranslation -Strand "AUG"
    #>
    [CmdletBinding()]
    Param(
        [string]$Strand
    )

    $codonMap = @{
        'AUG' = 'Methionine'
        'UUU' = 'Phenylalanine'
        'UUC' = 'Phenylalanine'
        'UUA' = 'Leucine'
        'UUG' = 'Leucine'
        'UCU' = 'Serine'
        'UCC' = 'Serine'
        'UCA' = 'Serine'
        'UCG' = 'Serine'
        'UAU' = 'Tyrosine'
        'UAC' = 'Tyrosine'
        'UGU' = 'Cysteine'
        'UGC' = 'Cysteine'
        'UGG' = 'Tryptophan'
        'UAA' = 'STOP'
        'UAG' = 'STOP'
        'UGA' = 'STOP'
    }

    $proteins = [System.Collections.Generic.List[string]]::new()

    for ($i = 0; $i -lt $Strand.Length; $i += 3) {
        # Si la séquence restante fait moins de 3 caractères, le codon est incomplet
        if ($i + 3 -gt $Strand.Length) {
            Throw "error: Invalid codon"
        }

        $codon = $Strand.Substring($i, 3)

        # Vérifie si le codon existe dans la table de correspondance
        if (-not $codonMap.ContainsKey($codon)) {
            Throw "error: Invalid codon"
        }

        $protein = $codonMap[$codon]

        # Si on rencontre un codon STOP, la traduction s'arrête immédiatement
        if ($protein -eq 'STOP') {
            break
        }

        $proteins.Add($protein)
    }

    return $proteins.ToArray()
}