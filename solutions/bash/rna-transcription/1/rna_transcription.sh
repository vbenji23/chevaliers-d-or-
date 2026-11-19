#!/usr/bin/env bash

main() {
    local -r dna=$1

    # Check for invalid characters in the DNA strand
    if [[ -n "$dna" && "$dna" =~ [^GCTA] ]]; then
        echo "Invalid nucleotide detected." >&2
        return 1
    fi

    # Transcribe DNA to RNA: G->C, C->G, T->A, A->U
    echo "$dna" | tr 'GCTA' 'CGAU'
}

main "$@"