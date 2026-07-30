package armstrong_numbers

import "core:math"

is_armstrong_number :: proc(n: u128) -> bool {
	// Le nombre 0 est un nombre d'Armstrong à 1 chiffre
	if n == 0 {
		return true
	}

	// 1. Compter le nombre de chiffres (p)
	num_digits: u32 = 0
	temp := n
	for temp > 0 {
		num_digits += 1
		temp /= 10
	}

	// 2. Calculer la somme de chaque chiffre élevé à la puissance num_digits
	sum: u128 = 0
	temp = n
	for temp > 0 {
		digit := temp % 10
		
		// Calcul de la puissance d'un entier
		powered_digit: u128 = 1
		for _ in 0 ..< num_digits {
			powered_digit *= digit
		}
		
		sum += powered_digit
		temp /= 10
	}

	// 3. Comparer la somme avec le nombre initial
	return sum == n
}