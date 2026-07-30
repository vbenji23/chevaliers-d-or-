#!/usr/bin/env bash

# Greatest Common Divisor helper
gcd() {
    local a=$1 b=$2
    while (( b != 0 )); do
        local temp=$b
        b=$(( a % b ))
        a=$temp
    done
    echo "$a"
}

main() {
    if (( $# < 4 )); then
        echo "Error: Missing arguments" >&2
        exit 1
    fi

    local size_one=$1
    local size_two=$2
    local goal=$3
    local start_bucket=$4

    # 1. Validation checks
    if (( goal > size_one && goal > size_two )); then
        echo "invalid goal: goal larger than both buckets" >&2
        exit 1
    fi

    local g
    g=$(gcd "$size_one" "$size_two")
    if (( goal % g != 0 )); then
        echo "invalid goal: goal is not divisible by GCD" >&2
        exit 1
    fi

    # 2. Initial Action (Step 1): Fill the starting bucket
    local init_b1=0 init_b2=0
    if [[ "$start_bucket" == "one" ]]; then
        init_b1=$size_one
    else
        init_b2=$size_two
    fi

    # Check if the first action directly satisfies the goal
    if (( init_b1 == goal )); then
        echo "moves: 1, goalBucket: one, otherBucket: $init_b2"
        exit 0
    elif (( init_b2 == goal )); then
        echo "moves: 1, goalBucket: two, otherBucket: $init_b1"
        exit 0
    fi

    # 3. BFS Queue Setup
    # Forbidden state: Starting bucket empty and other bucket full
    local forbidden_b1 forbidden_b2
    if [[ "$start_bucket" == "one" ]]; then
        forbidden_b1=0
        forbidden_b2=$size_two
    else
        forbidden_b1=$size_one
        forbidden_b2=0
    fi

    # Queue format: "b1,b2,moves"
    local -a queue=("$init_b1,$init_b2,1")

    # Visited state tracking: visited["b1,b2"]=1
    local -A visited=()
    visited["$init_b1,$init_b2"]=1
    visited["$forbidden_b1,$forbidden_b2"]=1

    local head=0
    while (( head < ${#queue[@]} )); do
        local state="${queue[$head]}"
        (( head++ ))

        IFS=',' read -r b1 b2 moves <<< "$state"

        # Define 6 possible transitions
        local -a next_states=()

        # Action 1: Fill B1
        next_states+=("$size_one $b2")
        # Action 2: Fill B2
        next_states+=("$b1 $size_two")
        # Action 3: Empty B1
        next_states+=("0 $b2")
        # Action 4: Empty B2
        next_states+=("$b1 0")

        # Action 5: Pour B1 -> B2
        local pour12=$(( size_two - b2 < b1 ? size_two - b2 : b1 ))
        next_states+=("$(( b1 - pour12 )) $(( b2 + pour12 ))")

        # Action 6: Pour B2 -> B1
        local pour21=$(( size_one - b1 < b2 ? size_one - b1 : b2 ))
        next_states+=("$(( b1 + pour21 )) $(( b2 - pour21 ))")

        for ns in "${next_states[@]}"; do
            read -r nb1 nb2 <<< "$ns"
            local next_moves=$(( moves + 1 ))

            # Check win condition
            if (( nb1 == goal )); then
                echo "moves: $next_moves, goalBucket: one, otherBucket: $nb2"
                exit 0
            elif (( nb2 == goal )); then
                echo "moves: $next_moves, goalBucket: two, otherBucket: $nb1"
                exit 0
            fi

            # Check if state has already been visited or is forbidden
            if [[ -z "${visited["$nb1,$nb2"]}" ]]; then
                visited["$nb1,$nb2"]=1
                queue+=("$nb1,$nb2,$next_moves")
            fi
        done
    done

    echo "invalid goal" >&2
    exit 1
}

main "$@"