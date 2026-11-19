#!/usr/bin/env bash

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    echo "This library of functions should be sourced into another script" >&2
    exit 4
fi
bash_version=$((10 * BASH_VERSINFO[0] + BASH_VERSINFO[1]))
if (( bash_version < 43 )); then
    echo "This library requires at least bash version 4.3" >&2
    return 4
fi

# Append elements to the given list array variable passed by nameref.
list::append () {
    local -n __dest=$1
    shift
    __dest+=("$@")
}

# Return only list elements passing the given predicate function.
list::filter () {
    local __func=$1
    local -n __src=$2
    local -n __dest=$3

    __dest=()
    local item
    for item in "${__src[@]}"; do
        if "$__func" "$item"; then
            __dest+=("$item")
        fi
    done
}

# Transform list elements using the given function into a new list.
list::map () {
    local __func=$1
    local -n __src=$2
    local -n __dest=$3

    __dest=()
    local item
    for item in "${__src[@]}"; do
        __dest+=("$("$__func" "$item")")
    done
}

# Left-fold the list using function and initial value (acc, item).
list::foldl () {
    local __func=$1
    local __acc=$2
    local -n __src=$3

    local item
    for item in "${__src[@]}"; do
        __acc=$("$__func" "$__acc" "$item")
    done
    echo "$__acc"
}

# Right-fold the list using function and initial value (item, acc).
list::foldr () {
    local __func=$1
    local __acc=$2
    local -n __src=$3

    local -i i
    for (( i = ${#__src[@]} - 1; i >= 0; i-- )); do
        __acc=$("$__func" "${__src[i]}" "$__acc")
    done
    echo "$__acc"
}

# Return the list reversed in the destination array variable.
list::reverse () {
    local -n __src=$1
    local -n __dest=$2

    __dest=()
    local -i i
    for (( i = ${#__src[@]} - 1; i >= 0; i-- )); do
        __dest+=("${__src[i]}")
    done
}