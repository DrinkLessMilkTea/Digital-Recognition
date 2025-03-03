.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the number of elements to use is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
    li t0 1
    bge a2 t0 enough_ele
    li a0 36
    j exit

enough_ele:
    bge a3 t0 legal_stripe_1 
    li a0 37
    j exit

legal_stripe_1:
    bge a4 t0 loop_start 
    li a0 37
    j exit

loop_start:
    li t0 4
    mul t3 a3 t0
    mul t4 a4 t0
    li t0 0
    li t1 0
    mv t5 a0
    mv t6 a1

loop_continue:
    beq t0 a2 loop_end
    lw a5 0(t5)
    lw a6 0(t6)
    mul a7 a5 a6
    add t1 t1 a7
    
    addi t0 t0 1
    add t5 t5 t3
    add t6 t6 t4
    j loop_continue

loop_end:
    mv a0 t1
    jr ra
