.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    # Prologue
    li t0 1
    bge a1 t0 loop_start
    li a0 36
    j exit

loop_start:
    li t0 0
    mv t1 a0

loop_continue:
    beq t0 a1 loop_end
    lw t2 0(t1)
    bge t2 x0 next_loop
    sw x0 0(t1)

next_loop:
    addi t0 t0 1
    addi t1 t1 4
    j loop_continue

loop_end:
    # Epilogue
    jr ra
