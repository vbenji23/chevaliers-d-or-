Function Add-Gigasecond() {
    <#
    .SYNOPSIS
    Add a gigasecond to a date.

    .DESCRIPTION
    Take a moment and add a gigasecond to it.

    .PARAMETER Time
    A datetime object, to which a gigasecond will be added.

    .EXAMPLE
    Add-Gigasecond -Time (Get-Date)
    #>
    [CmdletBinding()]
    Param(
        [DateTime]$Time
    )

    # 1 Gigaseconde = 1 000 000 000 secondes (10^9)
    return $Time.AddSeconds(1e9)
}