.equ INVALID_NUMBER, -1

.text
.globl steps

# int steps(int64_t number)
# Register mapping:
#   x0 : input number (n)
#   w1 : step counter
#   x2 : scratch register for bitwise checks and arithmetic
steps:
        // Rule 1: Return INVALID_NUMBER if number <= 0
        cmp     x0, #1
        blt     .L_invalid

        // Initialize step counter to 0
        mov     w1, #0

.L_loop:
        // Base case: if n == 1, we are done
        cmp     x0, #1
        beq     .L_done

        // Check if n is even (n & 1 == 0)
        tst     x0, #1
        beq     .L_even

        // Odd branch: n = 3 * n + 1
        // x2 = n * 2 + n (which is 3 * n)
        add     x2, x0, x0, lsl #1
        add     x0, x2, #1
        b       .L_next

.L_even:
        // Even branch: n = n / 2 (logical shift right by 1)
        lsr     x0, x0, #1

.L_next:
        // Increment step count and repeat loop
        add     w1, w1, #1
        b       .L_loop

.L_done:
        // Return step count in w0 / x0
        mov     w0, w1
        ret

.L_invalid:
        // Return INVALID_NUMBER (-1)
        mov     w0, INVALID_NUMBER
        ret