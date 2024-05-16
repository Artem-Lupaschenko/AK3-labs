.syntax unified
.cpu cortex-m4
.thumb
#define a #3
#define b #4
#define c #5

.global vtable_kernel
.global __kernel_reset__

.type vtable_kernel, %object
.type __kernel_reset__, %function

.section .interrupt_vector
vtable_kernel:
    .word __stack_start
    .word __kernel_reset__+1
    .size vtable_kernel, .-vtable_kernel

.section .rodata
    data: .asciz "kernel started!\n"
    final: .asciz "Value in register #3: "

.section .text
__kernel_reset__:
    ldr r0, =data
    bl dbgput_line

    // Load constants a, b, and c into registers r0, r1, and r2 respectively
    mov r0, a
    mov r1, b
    mov r2, c

    // Calculate a * b
    mul r3, r0, r1

    // Compare a * b with 10
    cmp r3, #10
    bge greater_than_or_equal_10

less_than_10:
    // Calculate (a & b) * c
    and r3, r0, r1   // a & b
    mul r3, r3, r2   // (a & b) * c
    b end            // Branch to the end of the function

greater_than_or_equal_10:
    // Calculate (a | b) * c
    orr r3, r0, r1   // a | b
    mul r3, r3, r2   // (a | b) * c

end:
    // Display the result
    ldr r0, =final
    bl dbgput
    mov r0, r3
    bl dbgput_num
