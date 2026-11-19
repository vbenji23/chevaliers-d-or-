Function Get-SpaceAge() {
    <#
    .SYNOPSIS
    Given an age in seconds, calculate how old someone would be on a planet in the solar system. (RIP Pluto)
    
    .DESCRIPTION
    The function takes a positive integer, and return a double (float) to show how old someone is on a specific planet.

    .PARAMETER Seconds
    The seconds of a person's age.

    .PARAMETER Planet
    The planet to calculate how old the person would be on it.
    Note: Since the planets in the solar system is a known shortlist, we can just validate the input with a set of values in the params.
    If no planet is specified, it should be default to Earth.
    
    .EXAMPLE
    Get-SpaceAge -Seconds 1000000000 -Planet Neptune
    Returns: 0.19
    #>
    [CmdletBinding()]
    Param(
        [double]$Seconds,
        
        [ValidateSet("Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune",
                     ErrorMessage = "Invalid planet: '{0}' is not a valid planet.")]
        [string]$Planet = "Earth"
    )

    # Durée d'une année terrestre en secondes (365.25 * 24 * 3600)
    $earthYearInSeconds = 31557600.0

    # Périodes orbitales des planètes exprimées en années terrestres
    $orbitalPeriods = @{
        "Mercury" = 0.2408467
        "Venus"   = 0.61519726
        "Earth"   = 1.0
        "Mars"    = 1.8808158
        "Jupiter" = 11.862615
        "Saturn"  = 29.447498
        "Uranus"  = 84.016846
        "Neptune" = 164.79132
    }

    # Calcul de l'âge sur la planète choisie
    $planetYearInSeconds = $earthYearInSeconds * $orbitalPeriods[$Planet]
    $age = $Seconds / $planetYearInSeconds

    # Arrondi à deux décimales
    return [Math]::Round($age, 2)
}