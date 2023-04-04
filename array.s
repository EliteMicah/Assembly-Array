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
    
    movl $array, %eax       # load the array into eax register
    movl $4, %ecx           # initialize the counter with the number of elements

myLoop:
    cmpl $0, %ecx           # check if the counter has reached zero (counting down)
    je loopEnd              # if it has, jump to the end of the loop

    movl (%eax), %ebx       # load the current element into EBX for processing
# perform necessary operations on the current element here

    addl $4, %eax           # increment the memory address to point to the next element
    loop myLoop             # decrement the counter and jump back to the loop start

loop_end:
# code to be executed after the loop ends

# Output the sum
    movq $4, %rax           # sys_write    
    movq $1, %rbx           # $1 is stdout    
    movq $sumMsg, %rcx      # output sumMsg
    movq $0x23, %rdx        # length of the message    
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
	
