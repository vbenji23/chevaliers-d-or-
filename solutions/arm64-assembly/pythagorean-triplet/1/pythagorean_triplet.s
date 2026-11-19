.text
.globl triplets_with_sum

// size_t triplets_with_sum(uint64_t n, uint64_t *a, uint64_t *b, uint64_t *c)
// x0 = n
// x1 = array_a
// x2 = array_b
// x3 = array_c
triplets_with_sum:
        // Save callee-saved registers
        stp     fp, lr, [sp, #-64]!
        mov     fp, sp
        stp     x19, x20, [sp, #16]
        stp     x21, x22, [sp, #32]
        stp     x23, x24, [sp, #48]

        mov     x19, x0             // x19 = N
        mov     x20, x1             // x20 = ptr_a
        mov     x21, x2             // x21 = ptr_b
        mov     x22, x3             // x22 = ptr_c

        mov     x23, #0             // x23 = count = 0

        // If N < 12, no triplet can exist (smallest is 3 + 4 + 5 = 12)
        cmp     x19, #12
        blt     .L_done

        // Calculate maximum bound for a: max_a = (N - 3) / 3
        sub     x0, x19, #3
        mov     x1, #3
        udiv    x24, x0, x1         // x24 = max_a

        mov     x9, #1              // x9 = a = 1
.L_loop_a:
        cmp     x9, x24
        bgt     .L_done

        // Numerator: num = N * (N - 2 * a)
        lsl     x0, x9, #1          // 2 * a
        sub     x0, x19, x0         // N - 2 * a
        mul     x10, x19, x0        // x10 = num = N * (N - 2 * a)

        // Denominator: den = 2 * (N - a)
        sub     x0, x19, x9         // N - a
        lsl     x11, x0, #1         // x11 = den = 2 * (N - a)

        // Check if num % den == 0
        udiv    x12, x10, x11       // x12 = b = num / den
        msub    x13, x12, x11, x10  // x13 = remainder = num - (b * den)

        cbnz    x13, .L_next_a      // Remainder != 0 -> b is not integer

        // Ensure b > a
        cmp     x12, x9
        ble     .L_next_a

        // Compute c = N - a - b
        sub     x0, x19, x9         // N - a
        sub     x14, x0, x12        // x14 = c = N - a - b

        // Store triplet into output buffers
        str     x9,  [x20, x23, lsl #3] // a[count] = a
        str     x12, [x21, x23, lsl #3] // b[count] = b
        str     x14, [x22, x23, lsl #3] // c[count] = c

        add     x23, x23, #1        // count++

.L_next_a:
        add     x9, x9, #1
        b       .L_loop_a

.L_done:
        mov     x0, x23             // Return count

        ldp     x23, x24, [sp, #48]
        ldp     x21, x22, [sp, #32]
        ldp     x19, x20, [sp, #16]
        ldp     fp, lr, [sp], #64
        ret