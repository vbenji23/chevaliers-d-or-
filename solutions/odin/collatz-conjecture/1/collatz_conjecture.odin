package collatz_conjecture

// Returns the number of steps to get to a value of 1.
steps :: proc(start: int) -> (result: int, ok: bool) {
	// La conjecture de Collatz n'est définie que pour les entiers strictement positifs (> 0)
	if start <= 0 {
		return 0, false
	}

	n := start
	count := 0

	for n > 1 {
		if n % 2 == 0 {
			n /= 2
		} else {
			n = 3 * n + 1
		}
		count += 1
	}

	return count, true
}