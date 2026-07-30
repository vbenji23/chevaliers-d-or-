// Meetup implementation in AArch64 (64-bit ARM assembly)

.equ FIRST, 1
.equ SECOND, 2
.equ THIRD, 3
.equ FOURTH, 4
.equ TEENTH, 5
.equ LAST, 6

.text
.globl meetup
.type meetup, %function

// Function Signature:
// void meetup(char *buffer, int year, int month, int week, int dayofweek)
//
// Arguments (AArch64 AAPCS):
//   x0 = buffer pointer
//   x1 = year
//   x2 = month
//   x3 = week
//   x4 = dayofweek (1=Monday, 2=Tuesday, ..., 7=Sunday)

meetup:
    stp     x29, x30, [sp, #-48]!
    mov     x29, sp
    stp     x19, x20, [sp, #16]
    stp     x21, x22, [sp, #32]

    mov     x19, x0             // buffer
    mov     x20, x1             // year
    mov     x21, x2             // month
    mov     x22, x4             // target weekday (1=Mon ... 7=Sun)

    // Determine starting day candidate (x25) based on week modifier (x3)
    cmp     w3, #FIRST
    b.eq    set_1
    cmp     w3, #SECOND
    b.eq    set_8
    cmp     w3, #THIRD
    b.eq    set_15
    cmp     w3, #FOURTH
    b.eq    set_22
    cmp     w3, #TEENTH
    b.eq    set_13

    // LAST week processing
    mov     x0, x20
    mov     x1, x21
    bl      days_in_month
    sub     x25, x0, #6
    b       find_day

set_1:  mov x25, #1;  b find_day
set_8:  mov x25, #8;  b find_day
set_15: mov x25, #15; b find_day
set_22: mov x25, #22; b find_day
set_13: mov x25, #13; b find_day

find_day:
day_loop:
    mov     x0, x20             // year
    mov     x1, x21             // month
    mov     x2, x25             // candidate day
    bl      get_day_of_week     // returns weekday (1=Mon ... 7=Sun) in x0

    cmp     x0, x22
    b.eq    format_output

    add     x25, x25, #1
    b       day_loop

format_output:
    mov     x0, x19             // buffer pointer

    // Write Year (4 digits)
    mov     x1, x20
    bl      write_4digits

    // Write '-'
    mov     w1, #45
    strb    w1, [x0], #1

    // Write Month (2 digits)
    mov     x1, x21
    bl      write_2digits

    // Write '-'
    mov     w1, #45
    strb    w1, [x0], #1

    // Write Day (2 digits)
    mov     x1, x25
    bl      write_2digits

    // Null terminator
    strb    wzr, [x0]

    // Restore registers and exit
    ldp     x19, x20, [sp, #16]
    ldp     x21, x22, [sp, #32]
    ldp     x29, x30, [sp], #48
    ret

// -------------------------------------------------------------------
// Helper: Get Day of Week (1=Monday ... 7=Sunday)
// Uses Sakamoto's Algorithm
// Inputs: x0 = year, x1 = month, x2 = day
// Output: x0 = weekday (1=Mon ... 7=Sun)
// -------------------------------------------------------------------
get_day_of_week:
    // Sakamoto Month Offsets table: [0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4]
    // If month < 3, year = year - 1
    cmp     w1, #3
    b.ge    sakamoto_calc
    sub     w0, w0, #1

sakamoto_calc:
    // Calculate: (y + y/4 - y/100 + y/400 + t[m-1] + d) % 7
    mov     x3, x0              // y

    // y / 4
    lsr     x4, x3, #2

    // y / 100
    mov     x5, #100
    sdiv    x5, x3, x5

    // y / 400
    mov     x6, #400
    sdiv    x6, x3, x6

    // Total year contribution
    add     x3, x3, x4
    sub     x3, x3, x5
    add     x3, x3, x6

    // Month offset lookup from table
    adrp    x4, month_table
    add     x4, x4, :lo12:month_table
    sub     w1, w1, #1          // m - 1 index
    ldrb    w4, [x4, x1]

    add     x3, x3, x4
    add     x3, x3, x2          // + day

    // Modulo 7 (0=Sun, 1=Mon, 2=Tue, 3=Wed, 4=Thu, 5=Fri, 6=Sat)
    mov     x4, #7
    sdiv    x5, x3, x4
    msub    x3, x5, x4, x3      // x3 = day % 7

    // Convert (0=Sun..6=Sat) to (1=Mon..7=Sun)
    // Map: 0->7, 1->1, 2->2, 3->3, 4->4, 5->5, 6->6
    cbz     w3, map_sunday
    mov     w0, w3
    ret

map_sunday:
    mov     w0, #7
    ret

.align 2
month_table:
    .byte 0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4

// -------------------------------------------------------------------
// Helper: Days in month
// Inputs: x0 = year, x1 = month
// Output: x0 = days count
// -------------------------------------------------------------------
days_in_month:
    cmp     w1, #4
    b.eq    d30
    cmp     w1, #6
    b.eq    d30
    cmp     w1, #9
    b.eq    d30
    cmp     w1, #11
    b.eq    d30

    cmp     w1, #2
    b.eq    c_leap

    mov     x0, #31
    ret

d30:
    mov     x0, #30
    ret

c_leap:
    mov     x2, #400
    sdiv    x3, x0, x2
    msub    x3, x3, x2, x0
    cbz     x3, is_l

    mov     x2, #100
    sdiv    x3, x0, x2
    msub    x3, x3, x2, x0
    cbz     x3, no_l

    mov     x2, #4
    sdiv    x3, x0, x2
    msub    x3, x3, x2, x0
    cbz     x3, is_l

no_l:
    mov     x0, #28
    ret
is_l:
    mov     x0, #29
    ret

// -------------------------------------------------------------------
// Formatting Helpers
// -------------------------------------------------------------------
write_4digits:
    stp     x29, x30, [sp, #-16]!
    mov     x2, x1

    mov     x3, #1000
    sdiv    x4, x2, x3
    msub    x2, x4, x3, x2
    add     w4, w4, #'0'
    strb    w4, [x0], #1

    mov     x3, #100
    sdiv    x4, x2, x3
    msub    x2, x4, x3, x2
    add     w4, w4, #'0'
    strb    w4, [x0], #1

    mov     x1, x2
    bl      write_2digits

    ldp     x29, x30, [sp], #16
    ret

write_2digits:
    mov     x2, #10
    sdiv    x3, x1, x2
    msub    x1, x3, x2, x1
    add     w3, w3, #'0'
    add     w1, w1, #'0'
    strb    w3, [x0], #1
    strb    w1, [x0], #1
    ret