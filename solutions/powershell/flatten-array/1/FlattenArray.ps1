Function Invoke-FlattenArray() {
    <#
    .SYNOPSIS
    Take a nested array and return a single flattened array with all values except null.

    .DESCRIPTION
    Given an array, flatten it and keep all values except null.

    .PARAMETER Array
    The nested array to be flattened.

    .EXAMPLE
    Invoke-FlattenArray -Array @(1, @(2, 3, $null, 4), @($null), 5)
    Return: @(1, 2, 3, 4, 5)
    #>
    [CmdletBinding()]
    Param(
        [System.Object[]]$Array
    )

    $result = [System.Collections.Generic.List[Object]]::new()

    Function Flatten-Item ($item) {
        if ($null -eq $item) {
            return
        }
        if ($item -is [System.Collections.IEnumerable] -and $item -isnot [string]) {
            foreach ($subItem in $item) {
                Flatten-Item $subItem
            }
        }
        else {
            $result.Add($item)
        }
    }

    foreach ($element in $Array) {
        Flatten-Item $element
    }

    return @($result)
}