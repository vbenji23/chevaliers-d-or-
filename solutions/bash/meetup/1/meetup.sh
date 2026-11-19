#!/usr/bin/env bash

main() {
    local year=$1
    local month=$2
    local descriptor=$3
    local day_of_week=$4

    # Determine start and end day search range based on descriptor
    local start_day end_day
    case "$descriptor" in
        first)  start_day=1;  end_day=7 ;;
        second) start_day=8;  end_day=14 ;;
        teenth) start_day=13; end_day=19 ;;
        third)  start_day=15; end_day=21 ;;
        fourth) start_day=22; end_day=28 ;;
        last)
            # Find the last day of the given month using date -d
            local last_day_of_month
            last_day_of_month=$(date -d "$year-$month-01 + 1 month - 1 day" +"%d")
            # Remove leading zero for numeric comparison/arithmetic
            last_day_of_month=$((10#$last_day_of_month))
            start_day=$(( last_day_of_month - 6 ))
            end_day=$last_day_of_month
            ;;
        *)
            echo "Invalid descriptor" >&2
            exit 1
            ;;
    esac

    # Iterate through candidate days in the calculated range
    local day
    for (( day = start_day; day <= end_day; day++ )); do
        # Format candidate date as YYYY-MM-DD
        local candidate_date
        candidate_date=$(printf "%04d-%02d-%02d" "$year" "$month" "$day")

        # Check matching weekday name (e.g., Monday, Tuesday, ...)
        if [[ "$(date -d "$candidate_date" +"%A")" == "$day_of_week" ]]; then
            echo "$candidate_date"
            return 0
        fi
    done
}

main "$@"