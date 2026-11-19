#!/usr/bin/env bash

main() {
    local category="$1"
    shift
    local -a dice=("$@")

    # Count frequencies of each die value (1..6)
    local -a counts=(0 0 0 0 0 0 0)
    local -i sum=0

    for die in "${dice[@]}"; do
        (( counts[die]++ ))
        (( sum += die ))
    done

    # Helper function to check for digit count matching category
    count_single() {
        local -i target=$1
        echo $(( counts[target] * target ))
    }

    case "$category" in
        "ones")   count_single 1 ;;
        "twos")   count_single 2 ;;
        "threes") count_single 3 ;;
        "fours")  count_single 4 ;;
        "fives")  count_single 5 ;;
        "sixes")  count_single 6 ;;

        "full house")
            # Must have exactly one value with count 3 and another with count 2
            local has_three=false has_two=false
            for c in "${counts[@]}"; do
                (( c == 3 )) && has_three=true
                (( c == 2 )) && has_two=true
            done
            if $has_three && $has_two; then
                echo "$sum"
            else
                echo "0"
            fi
            ;;

        "four of a kind")
            # Find face value showing at least 4 times
            local -i target_face=0
            for val in {1..6}; do
                if (( counts[val] >= 4 )); then
                    target_face=$val
                    break
                fi
            done
            if (( target_face > 0 )); then
                echo $(( target_face * 4 ))
            else
                echo "0"
            fi
            ;;

        "little straight")
            # Must have exactly one of each: 1, 2, 3, 4, 5
            if (( counts[1] == 1 && counts[2] == 1 && counts[3] == 1 && counts[4] == 1 && counts[5] == 1 )); then
                echo "30"
            else
                echo "0"
            fi
            ;;

        "big straight")
            # Must have exactly one of each: 2, 3, 4, 5, 6
            if (( counts[2] == 1 && counts[3] == 1 && counts[4] == 1 && counts[5] == 1 && counts[6] == 1 )); then
                echo "30"
            else
                echo "0"
            fi
            ;;

        "choice")
            echo "$sum"
            ;;

        "yacht")
            # All 5 dice must show the same value
            local is_yacht=false
            for c in "${counts[@]}"; do
                (( c == 5 )) && is_yacht=true
            done
            if $is_yacht; then
                echo "50"
            else
                echo "0"
            fi
            ;;

        *)
            echo "0"
            ;;
    esac
}

main "$@"