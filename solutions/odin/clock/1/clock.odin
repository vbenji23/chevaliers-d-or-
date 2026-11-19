package clock

import "core:fmt"

DAY_MINUTES :: 24 * 60

Clock :: struct {
	minutes: int,
}

// Calcule un modulo euclidien (positif) pour gérer correctement les valeurs négatives
normalize_minutes :: proc(total_minutes: int) -> int {
	m := total_minutes % DAY_MINUTES
	if m < 0 {
		m += DAY_MINUTES
	}
	return m
}

create_clock :: proc(hour, minute: int) -> Clock {
	total_minutes := hour * 60 + minute
	return Clock{minutes = normalize_minutes(total_minutes)}
}

to_string :: proc(clock: Clock) -> string {
	h := clock.minutes / 60
	m := clock.minutes % 60
	return fmt.aprintf("%02d:%02d", h, m)
}

add :: proc(clock: ^Clock, minutes: int) {
	clock.minutes = normalize_minutes(clock.minutes + minutes)
}

subtract :: proc(clock: ^Clock, minutes: int) {
	clock.minutes = normalize_minutes(clock.minutes - minutes)
}

equals :: proc(clock1, clock2: Clock) -> bool {
	return clock1.minutes == clock2.minutes
}