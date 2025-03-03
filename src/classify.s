.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
    addi sp sp -52
    sw ra 48(sp)
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp)
    sw s4 16(sp)
    sw s5 20(sp)
    sw s6 24(sp)
    sw s7 28(sp)
    sw s8 32(sp)
    sw s9 36(sp)
    sw s10 40(sp)
    sw s11 44(sp)

    mv s0 a0
    mv s1 a1
    li t0 5
    bne s0 t0 args_error
    lw s2 4(s1)
    lw s3 8(s1)
    lw s4 12(s1)
    lw s5 16(s1)
    mv s6 a2
    li s7 0
    li s8 0
    li s9 0
    li s10 0
    li s11 0


    # Read pretrained m0
    li a0 8
    jal malloc
    beq a0 x0 malloc_error
    mv s7 a0
    mv a0 s2
    mv a1 s7
    addi a2 s7 4
    jal read_matrix
    mv s2 a0

    # Read pretrained m1
    li a0 8
    jal malloc
    beq a0 x0 malloc_error
    mv s8 a0
    mv a0 s3
    mv a1 s8
    addi a2 s8 4
    jal read_matrix
    mv s3 a0

    # Read input matrix
    li a0 8
    jal malloc
    beq a0 x0 malloc_error
    mv s9 a0
    mv a0 s4
    mv a1 s9
    addi a2 s9 4
    jal read_matrix
    mv s4 a0

    # Compute h = matmul(m0, input)
    lw t0 0(s7)
    lw t1 4(s9)
    mul t2 t0 t1
    li t3 4
    mul t2 t2 t3
    mv a0 t2
    jal malloc
    beq a0 x0 malloc_error
    mv s10 a0
    mv a0 s2
    lw a1 0(s7)
    lw a2 4(s7)
    mv a3 s4
    lw a4 0(s9)
    lw a5 4(s9)
    mv a6 s10
    jal matmul

    # Compute h = relu(h)
    mv a0 s10
    lw t0 0(s7)
    lw t1 4(s9)
    mul a1 t0 t1
    jal relu

    # Compute o = matmul(m1, h)
    lw t0 0(s8)
    lw t1 4(s9)
    mul t2 t0 t1
    li t3 4
    mul t2 t2 t3
    mv a0 t2
    jal malloc
    beq a0 x0 malloc_error
    mv s11 a0
    mv a0 s3
    lw a1 0(s8)
    lw a2 4(s8)
    mv a3 s10
    lw a4 0(s7)
    lw a5 4(s9)
    mv a6 s11
    jal matmul


    # Write output matrix o
    mv a0 s5
    mv a1 s11
    lw a2 0(s8)
    lw a3 4(s9)
    jal write_matrix

    # Compute and return argmax(o)
    mv a0 s11
    lw t0 0(s8)
    lw t1 4(s9)
    mul a1 t0 t1
    jal argmax
    mv s0 a0

    # If enabled, print argmax(o) and newline
    bne s6 x0 cleanup_and_return
    jal print_int
    li a0 '\n'
    jal print_char
    mv a0 s0

    j cleanup_and_return

malloc_error:
    li a0 26
    j cleanup_and_exit

args_error:
    li a0 31
    j cleanup_and_exit

cleanup_and_exit:
    lw ra 48(sp)
    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw s4 16(sp)
    lw s5 20(sp)
    lw s6 24(sp)
    lw s7 28(sp)
    lw s8 32(sp)
    lw s9 36(sp)
    lw s10 40(sp)
    lw s11 44(sp)
    addi sp sp 52
    
    j exit
cleanup_and_return:
    lw ra 48(sp)
    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw s4 16(sp)
    lw s5 20(sp)
    lw s6 24(sp)
    lw s7 28(sp)
    lw s8 32(sp)
    lw s9 36(sp)
    lw s10 40(sp)
    lw s11 44(sp)
    addi sp sp 52

    jr ra
