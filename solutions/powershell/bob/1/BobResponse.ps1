Function Get-BobResponse() {
    [CmdletBinding()]
    Param(
        [string]$HeyBob
    )

    # 1. Nettoyage des espaces au début et à la fin
    $trimmed = $HeyBob.Trim()

    # 2. Vérification du silence (chaine vide après Trim)
    if ([string]::IsNullOrWhiteSpace($trimmed)) {
        return "Fine. Be that way!"
    }

    # 3. Vérification s'il s'agit d'une question (se termine par '?')
    $isQuestion = $trimmed.EndsWith('?')

    # 4. Vérification si la phrase est criée :
    #    - Doit contenir au moins une lettre majuscule ou minuscule
    #    - Toutes les lettres doivent être en MAJUSCULES (aucun caractère minuscules)
    $hasLetters = $trimmed -match '[a-zA-ZÀ-ÿ]'
    $isYelling = $hasLetters -and ($trimmed -cmatch '^[^a-zà-ÿ]+$')

    # 5. Application de la logique des réponses
    if ($isYelling -and $isQuestion) {
        return "Calm down, I know what I'm doing!"
    }
    elseif ($isYelling) {
        return "Whoa, chill out!"
    }
    elseif ($isQuestion) {
        return "Sure."
    }
    else {
        return "Whatever."
    }
}