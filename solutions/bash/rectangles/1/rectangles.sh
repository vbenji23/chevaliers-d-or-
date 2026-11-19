#!/usr/bin/env bash

# Reads input lines from stdin or positional args if provided
read_grid() {
    grid=()
    if [[ $# -gt 0 ]]; then
        for arg in "$@"; do
            grid+=("$arg")
        done
    else
        while IFS= read -r line || [[ -n "$line" ]]; do
            grid+=("$line")
        done
    fi
}

main() {
    read_grid "$@"

    local rows=${#grid[@]}
    if (( rows == 0 )); then
        echo 0
        exit 0
    fi

    local cols=${#grid[0]}
    if (( cols == 0 )); then
        echo 0
        exit 0
    fi

    local count=0

    # Iterate over all possible top-left corners (r1, c1)
    for (( r1=0; r1<rows; r1++ )); do
        for (( c1=0; c1<cols; c1++ )); do
            # Top-left corner must be a '+'
            [[ "${grid[r1]:c1:1}" == "+" ]] || continue

            # Iterate over all possible top-right corners (r1, c2)
            for (( c2=c1+1; c2<cols; c2++ )); do
                local char_tr="${grid[r1]:c2:1}"

                # Top border must remain intact ('-' or '+')
                if [[ "$char_tr" != "-" && "$char_tr" != "+" ]]; then
                    break # Horizontal edge broken
                fi

                # Found a valid top-right corner
                if [[ "$char_tr" == "+" ]]; then

                    # Iterate over all possible bottom rows r2 > r1
                    for (( r2=r1+1; r2<rows; r2++ )); do
                        local char_bl="${grid[r2]:c1:1}"
                        local char_br="${grid[r2]:c2:1}"

                        # Check left edge: grid[r2][c1] must be '|' or '+'
                        if [[ "$char_bl" != "|" && "$char_bl" != "+" ]]; then
                            break # Left vertical edge broken
                        fi

                        # Check right edge: grid[r2][c2] must be '|' or '+'
                        if [[ "$char_br" != "|" && "$char_br" != "+" ]]; then
                            break # Right vertical edge broken
                        fi

                        # If both bottom corners are '+', check the bottom horizontal edge
                        if [[ "$char_bl" == "+" && "$char_br" == "+" ]]; then
                            local valid_bottom=1
                            for (( c=c1+1; c<c2; c++ )); do
                                local b_char="${grid[r2]:c:1}"
                                if [[ "$b_char" != "-" && "$b_char" != "+" ]]; then
                                    valid_bottom=0
                                    break
                                fi
                            done

                            if (( valid_bottom == 1 )); then
                                (( count++ ))
                            fi
                        fi
                    done

                fi
            done
        done
    done

    echo "$count"
}

main "$@"