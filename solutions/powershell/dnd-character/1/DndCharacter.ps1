<#
.SYNOPSIS
    Generate a DnD character with all the classic abilities by rolling 4 dice.

.DESCRIPTION
    A DnD character starts has, among other things, six abilities:
    strength, dexterity, constitution, intelligence, wisdom and charisma.
    These abilities score are determined randomly by throwing dice.
    Throw 4 six-sided dice and return the sum of the largest three.
    Your character's initial hitpoints are: 10 + your character's constitution modifier.
    You find your character's constitution modifier by this formula : (Constitution - 10) / 2 and then round down.

.EXAMPLE
    $character = [Character]::new()
    $character | Format-Table

    Strength Dexterity Constitution Intelligence Wisdom Charisma HitPoints
    -------- --------- ------------ ------------ ------ -------- ---------
           7        10           15            9     13       13        12
#>
Class Character {
    [int]$Strength
    [int]$Dexterity
    [int]$Constitution
    [int]$Intelligence
    [int]$Wisdom
    [int]$Charisma
    [int]$HitPoints

    Character() {
        $this.Strength     = $this.Ability()
        $this.Dexterity    = $this.Ability()
        $this.Constitution = $this.Ability()
        $this.Intelligence = $this.Ability()
        $this.Wisdom       = $this.Ability()
        $this.Charisma     = $this.Ability()

        $this.HitPoints    = 10 + [Character]::GetModifier($this.Constitution)
    }

    [int] Ability() {
        # Tire 4 dés à 6 faces (1 à 6)
        $dice = 1..4 | ForEach-Object { Get-Random -Minimum 1 -Maximum 7 }
        
        # Tri descendant, sélectionne les 3 plus grands et fait leur somme
        $sorted = $dice | Sort-Object -Descending
        return ($sorted[0] + $sorted[1] + $sorted[2])
    }

    static [int] GetModifier([int]$Score) {
        # Arrondi toujours vers le bas
        return [Math]::Floor(($Score - 10) / 2.0)
    }
}