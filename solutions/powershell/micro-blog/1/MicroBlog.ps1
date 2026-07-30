Function Invoke-MicroBlog() {
    <#
    .SYNOPSIS
    Implement a function to make micro blog post that only of 5 or less characters.

    .DESCRIPTION
    Given a string, truncate it into a string of maximum 5 characters.

    .PARAMETER Post
    A string object contains Unicode text encoding: alphabets, symbols or even emojis.

    .EXAMPLE
    Invoke-MicroBlog -Post "Lightning"
    Returns: "Light"
    #>
    [CmdletBinding()]
    Param(
        [string]$Post
    )

    # StringInfo s'assure de découper par graphèmes (Text Elements), 
    # ce qui gère correctement les points de code Unicode sur 4 octets et les émojis (Surrogate Pairs).
    $stringInfo = [System.Globalization.StringInfo]::new($Post)

    if ($stringInfo.LengthInTextElements -le 5) {
        return $Post
    }

    return $stringInfo.SubstringByTextElements(0, 5)
}