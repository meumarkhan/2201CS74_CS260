.data
matrix1: .word 0 : 16 # storage for 16x16 matrix of words
matrix2: .word 0 : 16 # storage for 16x16 matrix of words
result: .word 0 : 16 # storage for 16x16 matrix of words

.text
	 li       $t0, 4       # $t0 = number of rows
         li       $t1, 4        # $t1 = number of columns
         
         
         move     $s0, $zero     # $s0 = row counter
         move     $s1, $zero     # $s1 = column counter
         move     $t2, $zero     # $t2 = the value to be stored
         
         loop1:    mult     $s0, $t1       # $s2 = row * #cols  (two-instruction sequence)
         mflo     $s2            # move multiply result from lo register to $s2
         add      $s2, $s2, $s1  # $s2 += column counter
         sll      $s2, $s2, 2    # $s2 *= 4 (shift left 2 bits) for byte offset
         sw       $t2, matrix1($s2) # store the value in matrix element
         addi     $t2, $t2, 1    # increment value to be stored
#  Loop control: If we increment past last column, reset column counter and increment row counter
#                If we increment past last row, we're finished.
         addi     $s1, $s1, 1    # increment column counter
         bne      $s1, $t1, loop1 # not at end of row so loop back
         move     $s1, $zero     # reset column counter
         addi     $s0, $s0, 1    # increment row counter
         bne      $s0, $t0, loop1 # not at end of matrix so loop back
        
         move     $s0, $zero     # $s0 = row counter
         move     $s1, $zero     # $s1 = column counter
         move     $t2, $zero     # $t2 = the value to be stored
         
                 loop2:    mult     $s0, $t1       # $s2 = row * #cols  (two-instruction sequence)
         mflo     $s2            # move multiply result from lo register to $s2
         add      $s2, $s2, $s1  # $s2 += column counter
         sll      $s2, $s2, 2    # $s2 *= 4 (shift left 2 bits) for byte offset
         sw       $t2, matrix2($s2) # store the value in matrix element
         addi     $t2, $t2, 1    # increment value to be stored
#  Loop control: If we increment past last column, reset column counter and increment row counter
#                If we increment past last row, we're finished.
         addi     $s1, $s1, 1    # increment column counter
         bne      $s1, $t1, loop2 # not at end of row so loop back
         move     $s1, $zero     # reset column counter
         addi     $s0, $s0, 1    # increment row counter
         bne      $s0, $t0, loop2 # not at end of matrix so loop back
         
         
         
         move     $s0, $zero     # $s0 = row counter
         move     $s1, $zero     # $s1 = column counter
         move     $t2, $zero     # $t2 = the value to be stored
         
         loop3:    mult     $s0, $t1       # $s2 = row * #cols  (two-instruction sequence)
         mflo     $s2            # move multiply result from lo register to $s2
         add      $s2, $s2, $s1  # $s2 += column counter
         sll      $s2, $s2, 2    # $s2 *= 4 (shift left 2 bits) for byte offset
         lw       $t3, matrix1($s2)
         lw       $t4,matrix2($s2)
         add      $t2,$t3,$t4
         sw       $t2, result($s2) # store the value in matrix element
         addi     $t2, $t2, 1    # increment value to be stored
#  Loop control: If we increment past last column, reset column counter and increment row counter
#                If we increment past last row, we're finished.
         addi     $s1, $s1, 1    # increment column counter
         bne      $s1, $t1, loop3 # not at end of row so loop back
         move     $s1, $zero     # reset column counter
         addi     $s0, $s0, 1    # increment row counter
         bne      $s0, $t0, loop3 # not at end of matrix so loop back