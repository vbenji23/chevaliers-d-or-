#!/usr/bin/env bash

main() {
    local flag_n=false
    local flag_l=false
    local flag_i=false
    local flag_v=false
    local flag_x=false

    # Parse options using getopts
    local opt
    while getopts "nlivx" opt; do
        case "$opt" in
            n) flag_n=true ;;
            l) flag_l=true ;;
            i) flag_i=true ;;
            v) flag_v=true ;;
            x) flag_x=true ;;
            *) exit 1 ;;
        esac
    done
    shift $((OPTIND - 1))

    # Pattern and file list extraction
    local pattern="$1"
    shift
    local -a files=("$@")
    local multiple_files=false
    if (( ${#files[@]} > 1 )); then
        multiple_files=true
    fi

    # Enable case-insensitive matching if -i flag is provided
    if $flag_i; then
        shopt -s nocasematch
    fi

    for file in "${files[@]}"; do
        [[ -f "$file" ]] || continue

        local line_num=0
        while IFS= read -r line || [[ -n "$line" ]]; do
            (( line_num++ ))
            local is_match=false

            if $flag_x; then
                if [[ "$line" == "$pattern" ]]; then
                    is_match=true
                fi
            else
                if [[ "$line" == *"$pattern"* ]]; then
                    is_match=true
                fi
            fi

            # Invert match logic for -v
            if $flag_v; then
                if $is_match; then
                    is_match=false
                else
                    is_match=true
                fi
            fi

            if $is_match; then
                # If -l is set, output the file name and stop reading this file
                if $flag_l; then
                    echo "$file"
                    break
                fi

                # Construct line output
                local output=""
                if $multiple_files; then
                    output="${file}:"
                fi

                if $flag_n; then
                    output="${output}${line_num}:"
                fi

                output="${output}${line}"
                echo "$output"
            fi
        done < "$file"
    done
}

main "$@"