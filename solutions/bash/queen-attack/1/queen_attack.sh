#!/usr/bin/env bash

error_exit() {
    echo "$1" >&2
    exit 1
}

# Helper function to validate coordinates: "row,col"
validate_position() {
    local pos="$1"
    IFS=',' read -r row col <<< "$pos"

    if (( row < 0 )); then
        error_exit "row not positive"
    fi
    if (( row > 7 )); then
        error_exit "row not on board"
    fi
    if (( col < 0 )); then
        error_exit "column not positive"
    fi
    if (( col > 7 )); then
        error_exit "column not on board"
    fi
}

main() {
    local w_pos="" b_pos=""

    # Parse command line options using getopts
    while getopts "w:b:" opt; do
        case "$opt" in
            w) w_pos="$OPTARG" ;;
            b) b_pos="$OPTARG" ;;
            *) error_exit "Invalid option" ;;
        esac
    done

    # Validate individual queen positions
    validate_position "$w_pos"
    validate_position "$b_pos"

    # Extract rows and columns
    local w_row w_col b_row b_col
    IFS=',' read -r w_row w_col <<< "$w_pos"
    IFS=',' read -r b_row b_col <<< "$b_pos"

    # Queens cannot share the exact same position
    if (( w_row == b_row && w_col == b_col )); then
        error_exit "same position"
    fi

    # Calculate absolute differences for row and column
    local d_row=$(( w_row > b_row ? w_row - b_row : b_row - w_row ))
    local d_col=$(( w_col > b_col ? w_col - b_col : b_col - w_col ))

    # Queens can attack if:
    # 1. Same row (d_row == 0)
    # 2. Same column (d_col == 0)
    # 3. Same diagonal (d_row == d_col)
    if (( w_row == b_row || w_col == b_col || d_row == d_col )); then
        echo "true"
    else
        echo "false"
    fi
}

main "$@"