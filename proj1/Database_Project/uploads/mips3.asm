.data
matrix1:    .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16    # Matrix 1: 4x4 matrix
matrix2:    .word 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32    # Matrix 2: 4x4 matrix
result:     .space 64              # Result matrix: 4x4 matrix

.text
main:
    # Matrix dimensions
    li $t0, 4      # Number of rows in matrix1
    li $t1, 4      # Number of columns in matrix1 / Number of rows in matrix2
    li $t2, 4      # Number of columns in matrix2

    # Load matrix1 address into $s0
    la $s0, matrix1
    # Load matrix2 address into $s1
    la $s1, matrix2
    # Load result matrix address into $s2
    la $s2, result

    # Loop through each element of the result matrix
    li $t3, 0      # Initialize row index to 0

row_loop:
    li $t4, 0      # Initialize column index to 0

col_loop:
    # Initialize result for this element to 0
    li $s3, 0

    # Loop to calculate dot product for current result element
    li $s4, 0      # Initialize loop counter
inner_loop:
    # Calculate element address in matrix1: (current row * #columns + loop counter) * 4
    mul $s5, $t3, $t1    # current row * #columns
    add $s5, $s5, $s4    # (current row * #columns) + loop counter
    sll $s5, $s5, 2      # Multiply by 4 to get byte offset
    add $s5, $s0, $s5    # Add matrix1 base address to get element address

    # Calculate element address in matrix2: (loop counter * #columns + current column) * 4
    mul $s6, $s4, $t2    # loop counter * #columns
    add $s6, $s6, $t4    # (loop counter * #columns) + current column
    sll $s6, $s6, 2      # Multiply by 4 to get byte offset
    add $s6, $s1, $s6    # Add matrix2 base address to get element address

    # Load elements from matrix1 and matrix2
    lw $s7, 0($s5)       # Load element from matrix1
    lw $v0, 0($s6)       # Load element from matrix2 (using v0)

    # Multiply and accumulate
    mul $v1, $s7, $v0
    add $s3, $s3, $v1

    # Increment loop counter
    addi $s4, $s4, 1
    # Check loop condition
    blt $s4, $t1, inner_loop

    # Store result in the result matrix
    # Calculate element address in result matrix: (current row * #columns + current column) * 4
    mul $t5, $t3, $t2    # current row * #columns
    add $t5, $t5, $t4    # (current row * #columns) + current column
    sll $t5, $t5, 2      # Multiply by 4 to get byte offset
    add $t5, $s2, $t5    # Add result matrix base address to get element address
    sw $s3, 0($t5)       # Store the result

    # Move to the next column
    addi $t4, $t4, 1

    # Check if column loop should continue
    blt $t4, $t2, col_loop

    # Reset column index and increment row index
    addi $t3, $t3, 1

    # Check if row loop should continue
    blt $t3, $t0, row_loop

    # Exit program
    li $v0, 10      # Exit system call
    syscall