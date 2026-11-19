#!/usr/bin/env bash

# Refactored Markdown to HTML converter.

parse_inline_formatting() {
    local text="$1"
    # Replace __text__ with <strong>text</strong>
    text=$(sed -E 's/__([^_]+)__/<strong>\1<\/strong>/g' <<< "$text")
    # Replace _text_ with <em>text</em>
    text=$(sed -E 's/_([^_]+)_/<em>\1<\/em>/g' <<< "$text")
    echo "$text"
}

main() {
    local file="${1:-}"
    [[ -f "$file" ]] || exit 1

    local html=""
    local in_list=false

    while IFS= read -r line || [[ -n "$line" ]]; do
        # 1. Unordered List Items: Lines starting with '* '
        if [[ "$line" =~ ^\*\ (.*) ]]; then
            if ! $in_list; then
                html+="<ul>"
                in_list=true
            fi
            local item_content
            item_content=$(parse_inline_formatting "${BASH_REMATCH[1]}")
            html+="<li>${item_content}</li>"

        # 2. Non-list lines: Close list block if currently inside one
        else
            if $in_list; then
                html+="</ul>"
                in_list=false
            fi

            # Check for headers (# to ######)
            if [[ "$line" =~ ^(#{1,6})\ (.*) ]]; then
                local header_level=${#BASH_REMATCH[1]}
                local header_content
                header_content=$(parse_inline_formatting "${BASH_REMATCH[2]}")
                html+="<h${header_level}>${header_content}</h${header_level}>"

            # Fallback: Normal Paragraph
            else
                local paragraph_content
                paragraph_content=$(parse_inline_formatting "$line")
                html+="<p>${paragraph_content}</p>"
            fi
        fi
    done < "$file"

    # Close list tag if file ends while inside a list
    if $in_list; then
        html+="</ul>"
    fi

    echo "$html"
}

main "$@"