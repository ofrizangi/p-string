    # 207488305 ofri zangi

.section .rodata #read only data section
f: .string "%s\0"
num: .string "%d"


.text

.global run_main
.type	run_main, @function
run_main:
    pushq %rbp
    movq %rsp, %rbp #for correct debugging
   
    #scanning the first length and string
    sub  $256, %rsp #the pstring can be 256 bytes with the \0
    mov  $0, %eax       # clear AL
    movq $num, %rdi  # load format string
    leaq (%rsp), %rsi  # set storage to address of x
    call scanf
    popq %r14 # x = leanth of string
    
    #scanning the string
    sub  $8, %rsp   # so there will be 256 free bytes in the stack
    mov  $0, %eax       # clear AL
    movq $f, %rdi  # load format string
    leaq (%rsp), %rsi  # set storage to address of x
    call scanf   
    
    #putting the leangth we scanned the highest as sappused to be in pstring
    sub $1, %rsp
    movb %r14b , (%rsp)
    
    movq %rsp,%r12 # saving a register that will point to the start of pstring1
    
    #getting the leangth of the seccond string
    sub  $271, %rsp
    mov  $0, %eax   # clear AL
    movq $num, %rdi  # load format string
    leaq (%rsp), %rsi  # set storage to address of x
    call scanf
    popq %r14 #poping and saving the leangth
    # getting the second string
    sub  $8, %rsp
    mov  $0, %eax  # clear AL
    movq $f, %rdi  # load format string
    leaq (%rsp), %rsi  # set storage to address of x
    call scanf
    
    #putting the leangth we scanned the highest as sappused to be in pstring
    sub $1, %rsp
    movb %r14b , (%rsp)
    movq %rsp, %r13 # saving a register that will point to the start of pstring1
    
    # get the case number
    sub  $15, %rsp
    mov  $0, %eax       # clear AL (zero FP args in XMM registers)
    movq $num, %rdi  # load format string
    leaq (%rsp), %rsi  # set storage to address of x
    call scanf
    # save the case number in rdi
    popq %rdi # first argument
         
   # saving %rdx and %rdi as pointers to those pstrings
   movq %r12,%rsi # second argument
   movq %r13, %rdx # third argument
   call run_func
 
   movq %rbp, %rsp
   popq %rbp
    
   ret
           
