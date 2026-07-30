#!/usr/bin/env bash

# Exit with error message
die() {
    echo "$1" >&2
    exit 1
}

# Recursively build the tree JSON structure from preorder and inorder arrays
build_tree() {
    local -a pre=($1)
    local -a in=($2)

    # Base case: empty tree
    if (( ${#pre[@]} == 0 )); then
        echo "{}"
        return
    fi

    local root="${pre[0]}"
    
    # Find root index in inorder array
    local root_idx=-1
    local i
    for (( i=0; i<${#in[@]}; i++ )); do
        if [[ "${in[i]}" == "$root" ]]; then
            root_idx=$i
            break
        fi
    done

    # Split inorder into left and right subtrees
    local -a left_in=("${in[@]:0:root_idx}")
    local -a right_in=("${in[@]:root_idx+1}")

    local left_len=${#left_in[@]}

    # Split preorder into left and right subtrees
    local -a left_pre=("${pre[@]:1:left_len}")
    local -a right_pre=("${pre[@]:1+left_len}")

    # Recursive calls
    local left_json right_json
    left_json=$(build_tree "${left_pre[*]}" "${left_in[*]}")
    right_json=$(build_tree "${right_pre[*]}" "${right_in[*]}")

    # Construct current node JSON
    cat <<EOF
{
  "v": "$root",
  "l": $left_json,
  "r": $right_json
}
EOF
}

main() {
    local pre_str="${1:-}"
    local in_str="${2:-}"

    # Convert inputs to arrays
    local -a preorder=($pre_str)
    local -a inorder=($in_str)

    # 1. Validation: Traversals must have the same length
    if (( ${#preorder[@]} != ${#inorder[@]} )); then
        die "traversals must have the same length"
    fi

    # Return empty tree if input is empty
    if (( ${#preorder[@]} == 0 )); then
        echo "{}"
        exit 0
    fi

    # 2. Validation: Check for duplicates in preorder
    local -A seen=()
    local item
    for item in "${preorder[@]}"; do
        if [[ -n "${seen[$item]+x}" ]]; then
            die "traversals must contain unique items"
        fi
        seen["$item"]=1
    done

    # 3. Validation: Check for duplicates in inorder
    seen=()
    for item in "${inorder[@]}"; do
        if [[ -n "${seen[$item]+x}" ]]; then
            die "traversals must contain unique items"
        fi
        seen["$item"]=1
    done

    # 4. Validation: Traversals must contain the exact same elements
    local -a sorted_pre sorted_in
    readarray -t sorted_pre < <(printf '%s\n' "${preorder[@]}" | sort)
    readarray -t sorted_in < <(printf '%s\n' "${inorder[@]}" | sort)

    if [[ "${sorted_pre[*]}" != "${sorted_in[*]}" ]]; then
        die "traversals must have the same elements"
    fi

    # Reconstruct and print tree JSON
    build_tree "${preorder[*]}" "${inorder[*]}"
}

main "$@"