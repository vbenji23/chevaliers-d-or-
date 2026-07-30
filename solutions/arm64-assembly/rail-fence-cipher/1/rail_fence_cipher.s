.text
.globl encode
.globl decode

// void encode(char *buffer, const char *msg, int rails)
// x0 = buffer, x1 = msg, w2 = rails
encode:
        stp     fp, lr, [sp, #-64]!
        mov     fp, sp
        stp     x19, x20, [sp, #16]
        stp     x21, x22, [sp, #32]
        stp     x23, x24, [sp, #48]

        mov     x19, x0             // x19 = buffer
        mov     x20, x1             // x20 = msg
        sxtw    x21, w2             // x21 = rails

        // Obtenir la longueur de la chaîne L
        mov     x0, x20
        bl      strlen
        mov     x22, x0             // x22 = L (longueur)

        cbz     x22, .L_encode_empty

        // Calculer la période P = 2 * (rails - 1)
        sub     x23, x21, #1
        lsl     x23, x23, #1        // x23 = P

        mov     x24, #0             // Out index dans buffer

        // Boucle externe : pour chaque rail r (0 à rails - 1)
        mov     x9, #0              // r = 0
.L_enc_rail_loop:
        cmp     x9, x21
        bge     .L_encode_done

        // Boucle interne : pour chaque position i (0 à L - 1)
        mov     x10, #0             // i = 0
.L_enc_char_loop:
        cmp     x10, x22
        bge     .L_enc_next_rail

        // Calculer m = i % P
        udiv    x11, x10, x23
        msub    x11, x11, x23, x10  // x11 = m

        // Calculer le rail effectif pour i:
        // si m < rails : rail = m
        // sinon        : rail = P - m
        cmp     x11, x21
        blt     .L_enc_use_m
        sub     x11, x23, x11
.L_enc_use_m:
        // Si le rail calculé correspond au rail courant r
        cmp     x11, x9
        bne     .L_enc_next_char

        // buffer[out_idx++] = msg[i]
        ldrb    w12, [x20, x10]
        strb    w12, [x19, x24]
        add     x24, x24, #1

.L_enc_next_char:
        add     x10, x10, #1
        b       .L_enc_char_loop

.L_enc_next_rail:
        add     x9, x9, #1
        b       .L_enc_rail_loop

.L_encode_done:
        strb    wzr, [x19, x24]     // Null-terminator '\0'

.L_encode_empty:
        ldp     x23, x24, [sp, #48]
        ldp     x21, x22, [sp, #32]
        ldp     x19, x20, [sp, #16]
        ldp     fp, lr, [sp], #64
        ret


// void decode(char *buffer, const char *msg, int rails)
// x0 = buffer, x1 = msg, w2 = rails
decode:
        stp     fp, lr, [sp, #-64]!
        mov     fp, sp
        stp     x19, x20, [sp, #16]
        stp     x21, x22, [sp, #32]
        stp     x23, x24, [sp, #48]

        mov     x19, x0             // x19 = buffer
        mov     x20, x1             // x20 = msg
        sxtw    x21, w2             // x21 = rails

        // Obtenir la longueur L
        mov     x0, x20
        bl      strlen
        mov     x22, x0             // x22 = L

        cbz     x22, .L_decode_empty

        // Calculer la période P = 2 * (rails - 1)
        sub     x23, x21, #1
        lsl     x23, x23, #1        // x23 = P

        // Réserver un tableau map d'indices sur la pile (L * 8 octets)
        lsl     x0, x22, #3
        add     x0, x0, #15
        and     x0, x0, #~15        // Alignement sur 16 octets
        sub     sp, sp, x0
        mov     x24, sp             // x24 = map array pointer

        mov     x12, #0             // Ciphertext index pos = 0

        // Construire la table de correspondance (map)
        mov     x9, #0              // r = 0
.L_dec_rail_loop:
        cmp     x9, x21
        bge     .L_dec_map_done

        mov     x10, #0             // i = 0
.L_dec_char_loop:
        cmp     x10, x22
        bge     .L_dec_next_rail

        // m = i % P
        udiv    x11, x10, x23
        msub    x11, x11, x23, x10

        cmp     x11, x21
        blt     .L_dec_use_m
        sub     x11, x23, x11
.L_dec_use_m:
        cmp     x11, x9
        bne     .L_dec_next_char

        // map[i] = pos++
        str     x12, [x24, x10, lsl #3]
        add     x12, x12, #1

.L_dec_next_char:
        add     x10, x10, #1
        b       .L_dec_char_loop

.L_dec_next_rail:
        add     x9, x9, #1
        b       .L_dec_rail_loop

.L_dec_map_done:
        // Reconstruire le message original : buffer[i] = msg[map[i]]
        mov     x10, #0             // i = 0
.L_dec_apply_loop:
        cmp     x10, x22
        bge     .L_dec_finish

        ldr     x11, [x24, x10, lsl #3] // x11 = map[i]
        ldrb    w12, [x20, x11]        // w12 = msg[map[i]]
        strb    w12, [x19, x10]        // buffer[i] = w12

        add     x10, x10, #1
        b       .L_dec_apply_loop

.L_dec_finish:
        strb    wzr, [x19, x22]        // Null-terminator '\0'
        mov     sp, fp                 // Restaurer la pile

.L_decode_empty:
        ldp     x23, x24, [sp, #48]
        ldp     x21, x22, [sp, #32]
        ldp     x19, x20, [sp, #16]
        ldp     fp, lr, [sp], #64
        ret