package bob

import "core:strings"

response :: proc(input: string) -> string {
	// Supprimer les espaces blancs au début et à la fin (y compris saut de ligne, tabulations, etc.)
	trimmed := strings.trim_space(input)

	// 1. Vérifier si l'entrée est vide (silence)
	if len(trimmed) == 0 {
		return "Fine. Be that way!"
	}

	// 2. Vérifier si c'est une question (se termine par '?')
	is_question := strings.has_suffix(trimmed, "?")

	// 3. Vérifier si la phrase est criée (contient au moins une lettre et toutes les lettres sont en majuscules)
	has_letters := false
	is_yelling := true

	for r in trimmed {
		if (r >= 'a' && r <= 'z') || (r >= 'A' && r <= 'Z') {
			has_letters = true
			if r >= 'a' && r <= 'z' {
				is_yelling = false
			}
		}
	}
	// S'il n'y a aucune lettre dans la chaîne, ce n'est pas considéré comme "crier"
	is_yelling = has_letters && is_yelling

	// 4. Déterminer la réponse en fonction de la combinaison des critères
	switch {
	case is_yelling && is_question:
		return "Calm down, I know what I'm doing!"
	case is_yelling:
		return "Whoa, chill out!"
	case is_question:
		return "Sure."
	case:
		return "Whatever."
	}
}