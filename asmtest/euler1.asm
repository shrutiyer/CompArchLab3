li $a0, 100
jal fizzbuzz
add $s0, $v0, $zero

li $v0, 10
syscall

# Sum the multiples of 3 and 5 up to $a0.
fizzbuzz:
li $t0, 0

fb_loop:
bne $a0, $zero, fb_continue
add $v0, $zero, $t0
jr $ra

fb_continue:
li $t7, 12
# ...push $ra, $a0
sub $sp, $sp, $t7
sw $a0, 8($sp)
sw $ra, 4($sp)
sw $t0, 0($sp)

# ...check for divisibility by 3 and 5
li $a1, 3
jal divBy
add $t2, $v0, $zero # 1 iff $a0 % 3 == 0
lw $a0, 8($sp)
li $a1, 5
jal divBy
add $t3, $v0, $zero # 1 iff $a0 % 5 == 0

add $t4, $t2, $t3 # 0 iff $a0 not divisible by 3 or 5
bne $t4, $zero, fb_else
li $t5, 0
j fb_end

fb_else: 
lw $a0, 8($sp)
add $t5, $zero, $a0

fb_end:
# ...load $ra, $a0
lw $a0, 8($sp)
lw $ra, 4($sp)
lw $t0, 0($sp)
li $t7, 12
add $sp, $sp, $t7

add $t0, $t0, $t5
li $t7, 1
sub $a0, $a0, $t7
j fb_loop


# Returns 1 iff $a0 % $a1 == 0
divBy:
sub $t1, $zero, $a1

db_begin:
bne $a0, $zero, db_continue
li $v0, 1 # $a0 is 0 -> divisible by $a1
jr $ra

db_continue:
slt $t0, $a0, $zero # 1 if $a0 < 0
bne $t0, $zero, db_end
add $a0, $a0, $t1
j db_begin

db_end:
li $v0, 0
jr $ra