#!/usr/bin/env bash

main() {
    local target_char="$1"

    # Get ASCII index of target character and 'A'
    LC_ALL=C printf -v target_code "%d" "'$target_char"
    LC_ALL=C printf -v a_code "%d" "'A"

    local max_index=$(( target_code - a_code ))

    # Helper function to generate spaces
    make_spaces() {
        local count="$1"
        if (( count > 0 )); then
            printf "%*s" "$count" ""
        fi
    }

    # Generate a single row for character index i (0 for 'A', 1 for 'B', etc.)
    render_row() {
        local i="$1"
        
        # Convert index back to character
        local char
        printf -v char "\\$(printf '%03o' $(( a_code + i )))"

        local outer_spaces=$(( max_index - i ))
        local outer
        outer=$(make_spaces "$outer_spaces")

        if (( i == 0 )); then
            printf "%sA%s\n" "$outer" "$outer"
        else
            local inner_spaces=$(( 2 * i - 1 ))
            local inner
            inner=$(make_spaces "$inner_spaces")
            printf "%s%s%s%s%s\n" "$outer" "$char" "$inner" "$char" "$outer"
        fi
    }

    # Top half (including the widest middle row)
    for (( i = 0; i <= max_index; i++ )); do
        render_row "$i"
    done

    # Bottom half (mirroring top half)
    for (( i = max_index - 1; i >= 0; i-- )); do
        render_row "$i"
    done
}

main "$@"