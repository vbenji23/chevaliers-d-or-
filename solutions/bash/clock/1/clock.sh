#!/usr/bin/env bash

# Helper to validate if a string is an integer (positive or negative)
is_integer() {
    [[ $1 =~ ^-?[0-9]+$ ]]
}

# Normalizes total minutes into HH:MM formatted output within 00:00 to 23:59
format_clock() {
    local total_minutes=$1
    
    # Total minutes in a 24-hour day (24 * 60 = 1440)
    local day_minutes=1440
    
    # Handle negative modulo properly in bash arithmetic
    total_minutes=$(( (total_minutes % day_minutes + day_minutes) % day_minutes ))

    local hours=$(( total_minutes / 60 ))
    local minutes=$(( total_minutes % 60 ))

    printf "%02d:%02d\n" "$hours" "$minutes"
}

main() {
    local hours mins delta_op delta_val
    local total_minutes

    # Check argument count and forms:
    # 2 args:  h m
    # 4 args:  h m {+|-} delta
    # 5 args:  h1 m1 = h2 m2
    case $# in
        2)
            hours=$1
            mins=$2
            if ! is_integer "$hours" || ! is_integer "$mins"; then
                echo "invalid arguments" >&2
                return 1
            fi
            total_minutes=$(( hours * 60 + mins ))
            format_clock "$total_minutes"
            ;;

        4)
            hours=$1
            mins=$2
            delta_op=$3
            delta_val=$4

            if ! is_integer "$hours" || ! is_integer "$mins" || ! is_integer "$delta_val"; then
                echo "invalid arguments" >&2
                return 1
            fi

            total_minutes=$(( hours * 60 + mins ))
            case "$delta_op" in
                +) total_minutes=$(( total_minutes + delta_val )) ;;
                -) total_minutes=$(( total_minutes - delta_val )) ;;
                *)
                    echo "invalid arguments" >&2
                    return 1
                    ;;
            esac
            format_clock "$total_minutes"
            ;;

        5)
            local h1=$1 m1=$2 op=$3 h2=$4 m2=$5
            if [[ "$op" != "=" ]] || ! is_integer "$h1" || ! is_integer "$m1" || ! is_integer "$h2" || ! is_integer "$m2"; then
                echo "invalid arguments" >&2
                return 1
            fi

            local time1=$(( h1 * 60 + m1 ))
            local time2=$(( h2 * 60 + m2 ))

            local formatted1
            local formatted2
            formatted1=$(format_clock "$time1")
            formatted2=$(format_clock "$time2")

            if [[ "$formatted1" == "$formatted2" ]]; then
                echo "true"
            else
                echo "false"
            fi
            ;;

        *)
            echo "invalid arguments" >&2
            return 1
            ;;
    esac
}

main "$@"