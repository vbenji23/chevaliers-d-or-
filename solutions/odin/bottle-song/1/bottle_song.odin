package bottle_song

import "core:fmt"
import "core:strings"

NUMBERS_LOWER := [11]string{
	"no", "one", "two", "three", "four",
	"five", "six", "seven", "eight", "nine", "ten",
}

NUMBERS_CAP := [11]string{
	"No", "One", "Two", "Three", "Four",
	"Five", "Six", "Seven", "Eight", "Nine", "Ten",
}

recite :: proc(start_bottles, take_down: int) -> []string {
	lines := make([dynamic]string)

	current := start_bottles
	for i in 0 ..< take_down {
		// Une ligne vide sépare deux strophes consécutives
		if i > 0 {
			append(&lines, strings.clone(""))
		}

		next := current - 1

		num_current_cap := NUMBERS_CAP[current]
		num_next_lower := NUMBERS_LOWER[next]

		// Gestion du pluriel ("bottle" vs "bottles")
		bottle_current := current == 1 ? "bottle" : "bottles"
		bottle_next := next == 1 ? "bottle" : "bottles"

		// Lignes 1 & 2
		line1_2 := fmt.aprintf("%s green %s hanging on the wall,", num_current_cap, bottle_current)
		append(&lines, line1_2)
		append(&lines, strings.clone(line1_2))

		// Ligne 3
		append(&lines, strings.clone("And if one green bottle should accidentally fall,"))

		// Ligne 4
		line4 := fmt.aprintf("There'll be %s green %s hanging on the wall.", num_next_lower, bottle_next)
		append(&lines, line4)

		current -= 1
	}

	return lines[:]
}