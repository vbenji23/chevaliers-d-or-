.text
.globl drinks_water
.globl owns_zebra

# char drinks_water(void)
# Returns 'N' (Norwegian)
drinks_water:
        mov     w0, #'N'
        ret

# char owns_zebra(void)
# Returns 'J' (Japanese)
owns_zebra:
        mov     w0, #'J'
        ret