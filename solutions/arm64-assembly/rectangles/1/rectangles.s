.text
.globl rectangles

// int rectangles(const char **strings)
// x0 = strings (NULL-terminated array of strings)
rectangles:
        // Handle NULL or empty input
        cbz     x0, .L_zero_exit
        ldr     x1, [x0]
        cbz     x1, .L_zero_exit

        // Save callee-saved registers
        stp     fp, lr, [sp, #-80]!
        mov     fp, sp
        stp     x19, x20, [sp, #16]
        stp     x21, x22, [sp, #32]
        stp     x23, x24, [sp, #48]
        stp     x25, x26, [sp, #64]

        mov     x19, x0             // x19 = strings pointer

        // 1. Calculate row count (num_rows)
        mov     x20, #0
.L_count_rows:
        ldr     x0, [x19, x20, lsl #3]
        cbz     x0, .L_rows_done
        add     x20, x20, #1
        b       .L_count_rows
.L_rows_done:
        cmp     x20, #2
        blt     .L_epilogue_zero

        // 2. Calculate column count (num_cols) from first row
        ldr     x0, [x19]
        bl      strlen
        mov     x21, x0             // x21 = num_cols
        cmp     x21, #2
        blt     .L_epilogue_zero

        mov     x22, #0             // x22 = rectangle_count = 0

        // Iteration: r1 from 0 to num_rows - 2
        mov     x23, #0             // r1 = 0
.L_r1_loop:
        sub     x0, x20, #1
        cmp     x23, x0
        bge     .L_done

        ldr     x24, [x19, x23, lsl #3] // ptr_r1 = strings[r1]

        // Iteration: c1 from 0 to num_cols - 2
        mov     x25, #0             // c1 = 0
.L_c1_loop:
        sub     x0, x21, #1
        cmp     x25, x0
        bge     .L_next_r1

        // Top-left corner must be '+'
        ldrb    w0, [x24, x25]
        cmp     w0, #'+'
        bne     .L_next_c1

        // Iteration: c2 from c1 + 1 to num_cols - 1
        add     x26, x25, #1        // c2 = c1 + 1
.L_c2_loop:
        cmp     x26, x21
        bge     .L_next_c1

        // Check top edge character at (r1, c2)
        ldrb    w0, [x24, x26]
        cmp     w0, #'+'
        beq     .L_top_edge_ok
        cmp     w0, #'-'
        bne     .L_next_c1          // Top edge broken -> break c2 loop early

        b       .L_next_c2          // Not a corner '+' yet, continue checking c2

.L_top_edge_ok:
        // Top-right corner is '+'. Now search down for r2 from r1 + 1 to num_rows - 1
        add     x27, x23, #1        // r2 = r1 + 1
.L_r2_loop:
        cmp     x27, x20
        bge     .L_next_c2

        ldr     x28, [x19, x27, lsl #3] // ptr_r2 = strings[r2]

        // Check left edge at (r2, c1)
        ldrb    w0, [x28, x25]
        cmp     w0, #'+'
        beq     .L_left_char_ok
        cmp     w0, #'|'
        bne     .L_next_c2          // Left edge broken -> break r2 loop early
.L_left_char_ok:

        // Check right edge at (r2, c2)
        ldrb    w0, [x28, x26]
        cmp     w0, #'+'
        beq     .L_right_char_ok
        cmp     w0, #'|'
        bne     .L_next_c2          // Right edge broken -> break r2 loop early
.L_right_char_ok:

        // Bottom-left and Bottom-right must both be '+'
        ldrb    w0, [x28, x25]
        cmp     w0, #'+'
        bne     .L_next_r2

        ldrb    w1, [x28, x26]
        cmp     w1, #'+'
        bne     .L_next_r2

        // Verify bottom edge between c1 + 1 and c2 - 1
        add     x0, x25, #1         // c = c1 + 1
.L_check_bottom:
        cmp     x0, x26
        bge     .L_valid_rectangle

        ldrb    w1, [x28, x0]
        cmp     w1, #'+'
        beq     .L_next_bottom_c
        cmp     w1, #'-'
        bne     .L_next_r2          // Bottom edge broken

.L_next_bottom_c:
        add     x0, x0, #1
        b       .L_check_bottom

.L_valid_rectangle:
        add     x22, x22, #1        // Increment rectangle count!

.L_next_r2:
        add     x27, x27, #1
        b       .L_r2_loop

.L_next_c2:
        add     x26, x26, #1
        b       .L_c2_loop

.L_next_c1:
        add     x25, x25, #1
        b       .L_c1_loop

.L_next_r1:
        add     x23, x23, #1
        b       .L_r1_loop

.L_done:
        mov     w0, w22             // Return total count

.L_epilogue:
        ldp     x25, x26, [sp, #64]
        ldp     x23, x24, [sp, #48]
        ldp     x21, x22, [sp, #32]
        ldp     x19, x20, [sp, #16]
        ldp     fp, lr, [sp], #80
        ret

.L_epilogue_zero:
        mov     w0, #0
        b       .L_epilogue

.L_zero_exit:
        mov     w0, #0
        ret