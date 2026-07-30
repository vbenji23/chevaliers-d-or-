#!/usr/bin/env bash

# Defined in standard electronic color code order (0 to 9)
readonly COLORS=(
    "black"
    "brown"
    "red"
    "orange"
    "yellow"
    "green"
    "blue"
    "violet"
    "grey"
    "white"
)

main() {
    local -r command=$1
    local -r target_color=$2

    case "$command" in
        code)
            for i in "${!COLORS[@]}"; do
                if [[ "${COLORS[$i]}" == "$target_color" ]]; then
                    echo "$i"
                    return 0
                fi
            done
            ;;
        colors)
            printf '%s\n' "${COLORS[@]}"
            ;;
    esac
}

main "$@"