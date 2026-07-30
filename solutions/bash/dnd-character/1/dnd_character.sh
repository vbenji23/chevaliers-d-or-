#!/usr/bin/env bash

# Calculate constitution modifier: (score - 10) / 2 rounded down
modifier() {
    local score=$1
    local diff=$(( score - 10 ))
    
    # In Bash integer division, negative numbers round towards zero instead of down.
    # To floor division for negative numbers, subtract 1 before dividing if odd.
    if (( diff < 0 && diff % 2 != 0 )); then
        echo $(( (diff - 1) / 2 ))
    else
        echo $(( diff / 2 ))
    fi
}

# Roll 4 d6 dice, discard the lowest, and return the sum of the top 3
roll_ability() {
    local min=7 sum=0 roll
    for _ in {1..4}; do
        roll=$(( RANDOM % 6 + 1 ))
        sum=$(( sum + roll ))
        if (( roll < min )); then
            min=$roll
        fi
    done
    echo $(( sum - min ))
}

# Generate character statistics and hitpoints
generate() {
    local strength dexterity constitution intelligence wisdom charisma hitpoints
    local const_mod

    strength=$(roll_ability)
    dexterity=$(roll_ability)
    constitution=$(roll_ability)
    intelligence=$(roll_ability)
    wisdom=$(roll_ability)
    charisma=$(roll_ability)

    const_mod=$(modifier "$constitution")
    hitpoints=$(( 10 + const_mod ))

    echo "strength $strength"
    echo "dexterity $dexterity"
    echo "constitution $constitution"
    echo "intelligence $intelligence"
    echo "wisdom $wisdom"
    echo "charisma $charisma"
    echo "hitpoints $hitpoints"
}

main() {
    case $1 in
        modifier)
            modifier "$2"
            ;;
        generate)
            generate
            ;;
        *)
            echo "Usage: dnd_character.sh {modifier <score>|generate}" >&2
            exit 1
            ;;
    esac
}

main "$@"