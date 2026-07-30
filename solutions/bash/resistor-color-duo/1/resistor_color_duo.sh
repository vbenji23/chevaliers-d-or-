#!/usr/bin/env bash

# Lookup function to convert a color string into its numeric value
color_code() {
    case "$1" in
        black)  echo 0 ;;
        brown)  echo 1 ;;
        red)    echo 2 ;;
        orange) echo 3 ;;
        yellow) echo 4 ;;
        green)  echo 5 ;;
        blue)   echo 6 ;;
        violet) echo 7 ;;
        grey)   echo 8 ;;
        white)  echo 9 ;;
        *)
            echo "invalid color" >&2
            return 1
            ;;
    esac
}

main() {
    local first_color=$1
    local second_color=$2

    # Get codes for the first two colors
    local digit1
    local digit2

    digit1=$(color_code "$first_color") || exit 1
    digit2=$(color_code "$second_color") || exit 1

    # Combine digits into a number and print (arithmetic format removes leading zero)
    echo $(( digit1 * 10 + digit2 ))
}

main "$@"