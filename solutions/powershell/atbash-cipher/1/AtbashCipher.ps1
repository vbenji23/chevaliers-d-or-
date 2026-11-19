Function Convert-AtbashChar([char]$c) {
    if ($c -ge 'a' -and $c -le 'z') {
        # Inverse la position dans l'alphabet (a -> z, b -> y, etc.)
        return [char]([int][char]'z' - ([int]$c - [int][char]'a'))
    }
    elseif ($c -ge '0' -and $c -le '9') {
        # Les chiffres restent inchangés
        return $c
    }
    return $null
}

Function Invoke-Encode() {
    <#
    .SYNOPSIS
    Encode a string using the Atbash cipher.

    .DESCRIPTION
    The Atbash cipher is a simple substitution cipher that relies on transposing all the letters in the 
    alphabet such that the resulting alphabet is backwards. 
    The first letter is replaced with the last letter, the second with the second-last, and so on.

    .PARAMETER Phrase
    The string to encode.

    .EXAMPLE
    Invoke-Encode -Phrase "yes"
    #>
    [CmdletBinding()]
    Param(
        [string]$Phrase
    )
    
    $cleanLower = $Phrase.ToLower().ToCharArray()
    $encodedChars = [System.Collections.Generic.List[char]]::new()

    foreach ($char in $cleanLower) {
        $converted = Convert-AtbashChar $char
        if ($null -ne $converted) {
            $encodedChars.Add($converted)
        }
    }

    # Formatage du texte chiffré par blocs de 5 caractères
    $blocks = [System.Collections.Generic.List[string]]::new()
    for ($i = 0; $i -lt $encodedChars.Count; $i += 5) {
        $length = [System.Math]::Min(5, $encodedChars.Count - $i)
        $block = -join $encodedChars.GetRange($i, $length)
        $blocks.Add($block)
    }

    return $blocks -join ' '
}

Function Invoke-Decode(){
    <#
    .SYNOPSIS
    Decode a string using the Atbash cipher.

    .DESCRIPTION
    The Atbash cipher is a simple substitution cipher that relies on transposing all the letters in the 
    alphabet such that the resulting alphabet is backwards. 
    The first letter is replaced with the last letter, the second with the second-last, and so on.

    .PARAMETER Phrase
    The string to decode.

    .EXAMPLE
    Invoke-Decode -Phrase "yes"
    #>
    [CmdletBinding()]
    Param(
        [string]$Phrase
    )

    $cleanLower = $Phrase.ToLower().ToCharArray()
    $decodedChars = [System.Collections.Generic.List[char]]::new()

    foreach ($char in $cleanLower) {
        $converted = Convert-AtbashChar $char
        if ($null -ne $converted) {
            $decodedChars.Add($converted)
        }
    }

    return -join $decodedChars
}