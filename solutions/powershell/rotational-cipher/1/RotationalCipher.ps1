Function Invoke-RotationalCipher() {
    <#
    .SYNOPSIS
    Rotate a string by a given number of places.

    .DESCRIPTION
    Create an implementation of the rotational cipher, also sometimes called the Caesar cipher.
    
    .PARAMETER Text
    The text to rotate    

    .PARAMETER Shift
    The number of places to shift the text

    .EXAMPLE
    Invoke-RotationalCipher -Text "A" -Shift 1
    #>
    [CmdletBinding()]
    Param(
        [string]$Text, 
        [int]$Shift
    )
    
    $result = [System.Text.StringBuilder]::new()

    foreach ($char in $Text.ToCharArray()) {
        if ($char -ge 'a' -and $char -le 'z') {
            # Minuscules : décalage cyclique (0 à 25) par rapport à 'a'
            $shifted = [char](([int][char]$char - [int][char]'a' + $Shift) % 26 + [int][char]'a')
            [void]$result.Append($shifted)
        }
        elseif ($char -ge 'A' -and $char -le 'Z') {
            # Majuscules : décalage cyclique (0 à 25) par rapport à 'A'
            $shifted = [char](([int][char]$char - [int][char]'A' + $Shift) % 26 + [int][char]'A')
            [void]$result.Append($shifted)
        }
        else {
            # Chiffres, espaces et ponctuation restent intacts
            [void]$result.Append($char)
        }
    }

    return $result.ToString()
}