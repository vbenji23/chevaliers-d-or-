#!/usr/bin/env bash

main() {
    local planet="$1"
    local seconds="$2"
    local orbital_period

    # Map each planet to its orbital period in Earth years
    case "$planet" in
        Mercury) orbital_period="0.2408467" ;;
        Venus)   orbital_period="0.61519726" ;;
        Earth)   orbital_period="1.0" ;;
        Mars)    orbital_period="1.8808158" ;;
        Jupiter) orbital_period="11.862615" ;;
        Saturn)  orbital_period="29.447498" ;;
        Uranus)  orbital_period="84.016846" ;;
        Neptune) orbital_period="164.79132" ;;
        *)
            echo "not a planet" >&2
            return 1
            ;;
    esac

    # Calculate high-precision result with scale=6 in bc
    local raw_age
    raw_age=$(bc -l <<< "scale=6; $seconds / (31557600 * $orbital_period)")

    # Standard half-up rounding to 2 decimal places using printf
    printf "%.2f\n" "$raw_age"
}

main "$@"