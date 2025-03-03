.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:
start:
    addi sp sp -32 
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp)
    sw s4 16(sp)
    sw s5 20(sp)
    sw s6 24(sp)
    sw ra 28(sp)

    mv s0 a0
    mv s1 a1
    mv s2 a2
    mv s3 x0
        
    # save the file to s0
    mv a0 s0
    li a1 0
    jal fopen
    li t0 -1
    beq a0 t0 fopen_error
    mv s0 a0 
    
    # save rows in s1
    mv a0 s0
    mv a1 s1
    li a2 4
    jal fread
    li t0 4
    bne a0 t0 fread_error

    # save cols in s2
    mv a0 s0
    mv a1 s2
    li a2 4
    jal fread
    li t0 4
    bne a0 t0 fread_error

    # malloc space for matrix in s3
    lw t0 0(s1)
    lw t1 0(s2)
    mul t0 t0 t1
    li t1 4
    mul a0 t0 t1
    jal malloc
    beq a0 x0 malloc_error
    mv s3 a0

    # start read matrix
loop_start:
    mv s4 s3
    li s5 0
    lw t0 0(s1)
    lw t1 0(s2)
    mul s6 t0 t1

loop_continue:
    beq s5 s6 loop_end
    mv a0 s0
    mv a1 s4
    li a2 4
    jal fread
    li t0 4
    bne a0 t0 fread_error
    
    addi s4 s4 4
    addi s5 s5 1
    j loop_continue

malloc_error:
    li a0 26
    j exit
fopen_error:
    li a0 27
    j exit
fclose_error:
    li a0 28
    j exit
fread_error:
    li a0 29
    j exit


loop_end:
    # Epilogue
    # close file
    mv a0 s0
    jal fclose
    bne a0 x0 fclose_error

    mv a0 s3

    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw s4 16(sp)
    lw s5 20(sp)
    lw s6 24(sp)
    lw ra 28(sp)
    addi sp sp 32 

    jr ra
