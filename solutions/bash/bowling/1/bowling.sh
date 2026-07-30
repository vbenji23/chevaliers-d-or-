#!/usr/bin/env bash

fail() {
    echo "$1" >&2
    exit 1
}

main() {
    local -a rolls=("$@")
    local -i total_rolls=${#rolls[@]}
    local -i roll_idx=0
    local -i frame
    local -i score=0

    # Process 10 frames
    for (( frame = 1; frame <= 10; frame++ )); do
        if (( roll_idx >= total_rolls )); then
            fail "Score cannot be taken until the end of the game"
        fi

        local -i r1=${rolls[roll_idx]}

        if (( r1 < 0 )); then
            fail "Negative roll is invalid"
        elif (( r1 > 10 )); then
            fail "Pin count exceeds pins on the lane"
        fi

        # Frame 1 to 9 standard processing
        if (( frame < 10 )); then
            if (( r1 == 10 )); then
                # Strike
                if (( roll_idx + 1 >= total_rolls )); then
                    fail "Score cannot be taken until the end of the game"
                fi
                local -i r2=${rolls[roll_idx + 1]}
                if (( r2 < 0 )); then
                    fail "Negative roll is invalid"
                elif (( r2 > 10 )); then
                    fail "Pin count exceeds pins on the lane"
                fi

                if (( roll_idx + 2 >= total_rolls )); then
                    fail "Score cannot be taken until the end of the game"
                fi
                local -i r3=${rolls[roll_idx + 2]}
                if (( r3 < 0 )); then
                    fail "Negative roll is invalid"
                elif (( r3 > 10 )); then
                    fail "Pin count exceeds pins on the lane"
                fi

                if (( r2 < 10 && r2 + r3 > 10 )); then
                    fail "Pin count exceeds pins on the lane"
                fi

                score+=$(( 10 + r2 + r3 ))
                (( roll_idx++ ))
            else
                # Open frame or Spare
                if (( roll_idx + 1 >= total_rolls )); then
                    fail "Score cannot be taken until the end of the game"
                fi
                local -i r2=${rolls[roll_idx + 1]}

                if (( r2 < 0 )); then
                    fail "Negative roll is invalid"
                elif (( r2 > 10 )); then
                    fail "Pin count exceeds pins on the lane"
                fi

                if (( r1 + r2 > 10 )); then
                    fail "Pin count exceeds pins on the lane"
                fi

                if (( r1 + r2 == 10 )); then
                    # Spare
                    if (( roll_idx + 2 >= total_rolls )); then
                        fail "Score cannot be taken until the end of the game"
                    fi
                    local -i r3=${rolls[roll_idx + 2]}
                    if (( r3 < 0 )); then
                        fail "Negative roll is invalid"
                    elif (( r3 > 10 )); then
                        fail "Pin count exceeds pins on the lane"
                    fi
                    score+=$(( 10 + r3 ))
                else
                    # Open frame
                    score+=$(( r1 + r2 ))
                fi
                (( roll_idx += 2 ))
            fi
        else
            # 10th Frame
            if (( r1 == 10 )); then
                # Strike in 10th frame: requires 2 fill balls
                if (( roll_idx + 1 >= total_rolls )); then
                    fail "Score cannot be taken until the end of the game"
                fi
                local -i r2=${rolls[roll_idx + 1]}

                if (( r2 < 0 )); then
                    fail "Negative roll is invalid"
                elif (( r2 > 10 )); then
                    fail "Pin count exceeds pins on the lane"
                fi

                if (( roll_idx + 2 >= total_rolls )); then
                    fail "Score cannot be taken until the end of the game"
                fi
                local -i r3=${rolls[roll_idx + 2]}

                if (( r3 < 0 )); then
                    fail "Negative roll is invalid"
                elif (( r3 > 10 )); then
                    fail "Pin count exceeds pins on the lane"
                fi

                # Check if r2 + r3 exceed 10 pins when r2 is not a strike
                if (( r2 < 10 && r2 + r3 > 10 )); then
                    fail "Pin count exceeds pins on the lane"
                fi

                score+=$(( 10 + r2 + r3 ))
                (( roll_idx += 3 ))
            else
                # Non-strike 10th frame first roll
                if (( roll_idx + 1 >= total_rolls )); then
                    fail "Score cannot be taken until the end of the game"
                fi
                local -i r2=${rolls[roll_idx + 1]}

                if (( r2 < 0 )); then
                    fail "Negative roll is invalid"
                elif (( r2 > 10 )); then
                    fail "Pin count exceeds pins on the lane"
                fi

                if (( r1 + r2 > 10 )); then
                    fail "Pin count exceeds pins on the lane"
                fi

                if (( r1 + r2 == 10 )); then
                    # Spare in 10th frame: requires 1 fill ball
                    if (( roll_idx + 2 >= total_rolls )); then
                        fail "Score cannot be taken until the end of the game"
                    fi
                    local -i r3=${rolls[roll_idx + 2]}

                    if (( r3 < 0 )); then
                        fail "Negative roll is invalid"
                    elif (( r3 > 10 )); then
                        fail "Pin count exceeds pins on the lane"
                    fi

                    score+=$(( 10 + r3 ))
                    (( roll_idx += 3 ))
                else
                    # Open 10th frame
                    score+=$(( r1 + r2 ))
                    (( roll_idx += 2 ))
                fi
            fi
        fi
    done

    # Reject extra rolls after 10 frames + fill balls
    if (( roll_idx < total_rolls )); then
        fail "Cannot roll after game is over"
    fi

    echo "$score"
}

main "$@"