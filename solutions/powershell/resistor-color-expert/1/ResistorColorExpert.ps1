Function Get-ResistorLabel() {
    [CmdletBinding()]
    Param(
        [string[]]$Colors
    )

    # Standard color-to-digit map
    $colorMap = @{
        'black'  = 0
        'brown'  = 1
        'red'    = 2
        'orange' = 3
        'yellow' = 4
        'green'  = 5
        'blue'   = 6
        'violet' = 7
        'grey'   = 8
        'white'  = 9
    }

    # Tolerance map
    $toleranceMap = @{
        'grey'   = '0.05%'
        'violet' = '0.1%'
        'blue'   = '0.25%'
        'green'  = '0.5%'
        'brown'  = '1%'
        'red'    = '2%'
        'gold'   = '5%'
        'silver' = '10%'
    }

    # Single band case (0 ohms)
    if ($Colors.Count -eq 1 -and $Colors[0] -eq 'black') {
        return "0 ohms"
    }

    # Identify bands based on array length
    if ($Colors.Count -eq 4) {
        $digits = "$($colorMap[$Colors[0]])$($colorMap[$Colors[1]])"
        $multiplierExp = $colorMap[$Colors[2]]
        $toleranceColor = $Colors[3]
    }
    elseif ($Colors.Count -eq 5) {
        $digits = "$($colorMap[$Colors[0]])$($colorMap[$Colors[1]])$($colorMap[$Colors[2]])"
        $multiplierExp = $colorMap[$Colors[3]]
        $toleranceColor = $Colors[4]
    }
    else {
        throw "Invalid color array length."
    }

    # Calculate full resistance value in ohms
    [double]$rawOhms = [double]$digits * [Math]::Pow(10, $multiplierExp)

    # Format the resistance value with proper metric prefix
    if ($rawOhms -ge 1e9) {
        $formattedValue = $rawOhms / 1e9
        $unit = "gigaohms"
    }
    elseif ($rawOhms -ge 1e6) {
        $formattedValue = $rawOhms / 1e6
        $unit = "megaohms"
    }
    elseif ($rawOhms -ge 1e3) {
        $formattedValue = $rawOhms / 1e3
        $unit = "kiloohms"
    }
    else {
        $formattedValue = $rawOhms
        $unit = "ohms"
    }

    # Build and return the formatted label
    $tolerance = $toleranceMap[$toleranceColor]
    return "$formattedValue $unit ±$tolerance"
}