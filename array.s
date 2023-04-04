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
    
# Initialization
    movl $0, %eax           # set the sum to zero
    movl $0, %ecx           # initialize loop counter to zero
loop:
    cmpl $4, %ecx           # check if loop counter is equal to array size
    je end                  # if it is, exit the loop
    movl array(%ecx), %edx  # load the current array element
    addl %edx, %eax         # add the current element to the sum
    incl %ecx               # increment the loop counter
    jmp loop                # jump back to the start of the loop
end:
    pushl %eax              # push the sum onto the stack
    call display_sum        # call the display_sum function
    addl $4, %esp           # remove the sum from the stack
    xorl %eax, %eax         # set the return value to zero
    ret                     # return from the function

display_sum:
    pushl %ebp              # save the old base pointer
    movl %esp, %ebp         # set the new base pointer
    subl $4, %esp           # allocate space for the argument
    movl 4(%ebp), %eax      # load the sum from the stack
    pushl %eax              # push the sum as the argument
    pushl $sum_format       # push the format string
    call printf             # call the printf function
    addl $8, %esp           # remove the arguments from the stack
    leave                   # restore the old base pointer and return

# Exit with return 0
	movl $1, %eax           # exit(0) - $1 is sys_exit    
	movl $0, %ebx           # 0 is return value    
	int  $0x80              # system interrupt to kernel    
	ret
	
