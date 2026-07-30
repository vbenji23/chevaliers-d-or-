#!/usr/bin/env bash

main() {
    local rna="$1"
    local proteins=()
    local i codon amino_acid

    for (( i = 0; i < ${#rna}; i += 3 )); do
        codon="${rna:i:3}"

        # If codon length is less than 3, the RNA sequence is incomplete/invalid
        if (( ${#codon} < 3 )); then
            echo "Invalid codon" >&2
            return 1
        fi

        case "$codon" in
            AUG)
                amino_acid="Methionine"
                ;;
            UUU | UUC)
                amino_acid="Phenylalanine"
                ;;
            UUA | UUG)
                amino_acid="Leucine"
                ;;
            UCU | UCC | UCA | UCG)
                amino_acid="Serine"
                ;;
            UAU | UAC)
                amino_acid="Tyrosine"
                ;;
            UGU | UGC)
                amino_acid="Cysteine"
                ;;
            UGG)
                amino_acid="Tryptophan"
                ;;
            UAA | UAG | UGA)
                # STOP codon encountered: terminate translation immediately
                break
                ;;
            *)
                echo "Invalid codon" >&2
                return 1
                ;;
        esac

        proteins+=("$amino_acid")
    done

    # Output space-separated proteins
    echo "${proteins[*]}"
}

main "$@"