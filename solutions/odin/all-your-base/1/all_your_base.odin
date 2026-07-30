package all_your_base

Error :: enum {
	None,
	Invalid_Input_Digit,
	Input_Base_Too_Small,
	Output_Base_Too_Small,
	Unimplemented,
}

rebase :: proc(input_base: int, digits: []int, output_base: int) -> ([]int, Error) {
	// Validation des bases d'entrée et de sortie
	if input_base < 2 {
		return nil, .Input_Base_Too_Small
	}
	if output_base < 2 {
		return nil, .Output_Base_Too_Small
	}

	// 1. Conversion de la séquence de chiffres en valeur décimale
	decimal_value := 0
	for d in digits {
		if d < 0 || d >= input_base {
			return nil, .Invalid_Input_Digit
		}
		decimal_value = decimal_value * input_base + d
	}

	// Cas particulier : si le nombre total vaut 0 (ou si le tableau est vide)
	if decimal_value == 0 {
		result := make([]int, 1)
		result[0] = 0
		return result, .None
	}

	// 2. Conversion de la valeur décimale vers la nouvelle base
	// On stocke d'abord les chiffres générés dans une liste dynamique (slice modifiable)
	out_digits := make([dynamic]int)
	defer delete(out_digits)

	val := decimal_value
	for val > 0 {
		append(&out_digits, val % output_base)
		val /= output_base
	}

	// Les chiffres sont générés du moins significatif au plus significatif,
	// il faut donc inverser le tableau.
	n := len(out_digits)
	result := make([]int, n)
	for i in 0 ..< n {
		result[i] = out_digits[n - 1 - i]
	}

	return result, .None
}