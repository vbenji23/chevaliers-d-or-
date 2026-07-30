#!/usr/bin/env bash

main() {
    local -a grid=("$@")
    local -i rows=${#grid[@]}

    # Handle empty matrix
    if (( rows == 0 )); then
        exit 0
    fi

    local -i cols=${#grid[0]}

    # Iterate through every cell to compute the next generation
    local -i r c
    for (( r = 0; r < rows; r++ )); do
        local new_row=""
        for (( c = 0; c < cols; c++ )); do
            local -i neighbors=0
            local current_cell="${grid[r]:c:1}"

            # Count live neighbors in the 3x3 surrounding region
            local -i dr dc
            for (( dr = -1; dr <= 1; dr++ )); do
                for (( dc = -1; dc <= 1; dc++ )); do
                    # Skip the current cell itself
                    if (( dr == 0 && dc == 0 )); then
                        continue
                    fi

                    local -i nr=$(( r + dr ))
                    local -i nc=$(( c + dc ))

                    # Check grid boundaries
                    if (( nr >= 0 && nr < rows && nc >= 0 && nc < cols )); then
                        if [[ "${grid[nr]:nc:1}" == "1" ]]; then
                            (( neighbors++ ))
                        fi
                    fi
                done
            done

            # Apply Conway's Game of Life rules
            if [[ "$current_cell" == "1" ]]; then
                if (( neighbors == 2 || neighbors == 3 )); then
                    new_row+="1"
                else
                    new_row+="0"
                fi
            else
                if (( neighbors == 3 )); then
                    new_row+="1"
                else
                    new_row+="0"
                fi
            fi
        done

        echo "$new_row"
    done
}

main "$@"