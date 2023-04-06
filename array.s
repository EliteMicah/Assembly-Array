.data                                               # data segment
msg1:
.string "\nInitializing array with: 1, 1, 2, 3 "    # Array Msg
msg2:
.string "\nAdding the values together...\n"         # Adding Array Msg
sumMsg:
.string "\nSum of the array is: "                   # Sum Output message
array:
    .long 1, 1, 2, 3                                # initialize the array with the four values

.bss                        # uninitialized variables segment    
	.lcomm sum, 32
	 movl $0, sum

.text                       # code segment
.global main
main:

# Output the first two messages
    movq $4, %rax           # sys_write    
    movq $1, %rbx           # $1 is stdout    
    movq $msg1, %rcx        # output msg1
    movq $0x24, %rdx        # length of the message    
    int  $0x80              # system interrupt to kernel 

    movq $4, %rax           # sys_write    
    movq $1, %rbx           # $1 is stdout    
    movq $msg2, %rcx        # output msg2
    movq $0x20, %rdx        # length of the message    
    int  $0x80              # system interrupt to kernel

# Setting up Loop
    movl $0, %eax           # initialize sum to zero
    movl $0, %ecx           # initialize loop counter to zero

myLoop:
    cmp $4, %ecx            # check if loop counter is equal to four
    je loopDone             # if so, jump to end of loop
    movl array(,%ecx,4), %ebx   # get current array element and store in ebx
    addl %ebx, %eax         # add current array element to sum
    incl %ecx               # increment loop counter
    jmp myLoop              # jump back to start of loop

loopDone:
    movl %eax, %ebx         # move sum to ebx for ASCII conversion
    add $0x30, %bl          # convert most significant digit to ASCII
    movb %bl, sum           # store most significant digit

# Output the sum
    movq $4, %rax           # sys_write    
    movq $1, %rbx           # $1 is stdout    
    movq $sumMsg, %rcx      # output sumMsg
    movq $0x16, %rdx        # length of the message    
    int  $0x80              # system interrupt to kernel

    movq $4, %rax           # sys_write    
    movq $1, %rbx           # $1 is stdout    
    movq $sum, %rcx         # output sum
    movq $0x1, %rdx         # length of the message    
    int  $0x80              # system interrupt to kernel 

# Exit with return 0
	movl $1, %eax           # exit(0) - $1 is sys_exit    
	movl $0, %ebx           # 0 is return value    
	int  $0x80              # system interrupt to kernel    
	ret
