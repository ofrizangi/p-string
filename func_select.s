    # 207488305 ofri zangi

.section .rodata #read only data section
	
str1:	.string	"first pstring length: %d, second pstring length: %d\n"
str2:	.string	"old char: %c, new char: %c, first string: %s, second string: %s\n"
str3:	.string	"length: %d, string: %s\n"
str4:	.string	"invalid input!\n"
str5:   .string "compare result: %d\n"
str6:   .string "invalid option!\n"
f: .string "%s\0"
num: .string "%d"
tav: .string " %c"


.align 8
.switchCase:
    .quad .L1  #case 50
    .quad .L2 #case 60
    .quad .L3  #case 52
    .quad .L4  #case 53
    .quad .L5  #case 54
    .quad .L6  #case 55
    .quad .L7  #default
    

.text
                                                      
                                                                                                                                               
#numCase in %rdi, &pstr1 int %rsi, &pstr2 in %rdx
.global run_func
.type	run_func, @function
run_func: 
    
    # caller saved and stuck pointer
    pushq %rbp
    movq %rsp, %rbp
    pushq %r12
    pushq %r13
    pushq %r14
    pushq %r15
      
    #the number of case we want to go to is in %rdi
    leaq  -50(%rdi) , %rcx # xi = x - 50
    cmpq    $10 , %rcx # if the number is 60
    je      .L2 # case 60
    
    #jumping to default
    cmpq     $1 , %rcx # if the number is 51 we want to go to the default
    je      .L7 
    cmpq    $5 , %rcx  # if the number is larger than 5 we want to go to the default
    ja      .L7    
    
    #jumping to switchCase[xi*8]
    jmp     *.switchCase(,%rcx,8)
    
    
    #case 50 or 60
    .L1:
       movq %rsi, %rdi #first parameter to pstrlen
       call pstrlen 
       movq %rax , %rcx #saving the len
       movq %rdx, %rdi #first parameter to pstrlen
       call pstrlen
       movq $str1,%rdi #first parameter to printf
       movq %rcx, %rsi #second parameter to printf
       movq %rax, %rdx #third parameter to printf
       movq $0,%rax 
       call printf
       jmp .L10
        
    #case 60
    .L2:
       jmp .L1   
    
     #case 52
    .L3:
        #save the pstr before calling scanf
        movq %rsi, %r12
        movq %rdx, %r13
        
        # the registers that will hold the parameters from scanf
        xorq %r14, %r14
        xorq %r15, %r15
        
        #scanning the first character
        sub  $8, %rsp
        mov  $0, %eax  # clear AL
        movq $tav, %rdi  # load format string
        leaq (%rsp), %rsi  # set storage to address of x
        call scanf
        popq %r14
     
        #scanning the second character
         sub  $8, %rsp
         mov  $0, %eax  # clear AL
         movq $tav, %rdi  # load format string
         leaq (%rsp), %rsi  # set storage to address of x
         call scanf
         popq %r15
         
         #call replaceChar with the first pstr
         xorq %rsi, %rsi
         xorq %rdi, %rdi
         
         movq %r12, %rdi # first argument
         movq %r14, %rsi # second argument
         movq %r15 , %rdx # third argument
         call replaceChar
         
         #save the first pstr pointer
         movq %rdi, %rcx
         
         #call with the second pstr
         movq %r13, %rdi # first parameter
         call replaceChar
         
         # call printf
         movq $str2,%rdi #first parameter to printf
         leaq 1(%r12), %rcx
         leaq 1(%r13), %r8
         movq $0, %rax
         call printf
         
        jmp .L10
    
     #case 53
    .L4:
    
        #save the pstrings    
        movq %rsi, %r14
        movq %rdx, %r15
        
        # the registers that will hold the parameters from scanf
        xorq %r12, %r12
        xorq %r13, %r13
        
        #get the first index
        sub  $8, %rsp
        mov  $0, %eax       # clear AL (zero FP args in XMM registers)
        movq $num, %rdi  # load format string
        leaq (%rsp), %rsi  # set storage to address of x
        call scanf
        movb (%rsp) , %r12b #we want to keep only the first byte
            
        #get the second index    
        mov  $0, %eax       # clear AL (zero FP args in XMM registers)
        movq $num, %rdi  # load format string
        leaq (%rsp), %rsi  # set storage to address of x
        call scanf
        movb (%rsp) , %r13b #we want to keep only the first byte
        
        # call pstrijcpy with both of the pstrings
        movq %r14, %rdi 
        movq %r15, %rsi
        movq %r12, %rdx
        movq %r13, %rcx
        call pstrijcpy
        
        #call printf and print the dst pstr
        movq $str3,%rdi #first parameter to printf
        xorq %rsi, %rsi
        movb (%r14), %sil # %r14 point to dst
        leaq 1(%r14), %rdx
        movq $0, %rax
        call printf 
        
        #call printf and print the src pstr
        movq $str3,%rdi #first parameter to printf
        xorq %rsi, %rsi
        movb (%r15), %sil # %r15 point to src
        leaq 1(%r15), %rdx
        movq $0, %rax
        call printf 
        
        jmp .L10
    
     #case 54
    .L5:
      pushq %rdx  #save the second pstr
    
      #call the function with the first pstr  
      movq %rsi, %rdi
      call swapCase
      
      #call printf with first pstr
      movq $str3,%rdi #first parameter to printf
      xorq %rsi, %rsi # rsi = 0
      movb (%rax), %sil
      leaq 1(%rax), %rdx
      movq $0, %rax
      call printf 

      #call the function with the second pstr
      popq %rdx
      movq %rdx, %rdi # first parameter
      call swapCase
      
      #call printf with second pstr
      movq $str3,%rdi #first parameter to printf
      xorq %rsi, %rsi # rsi = 0
      movb (%rax), %sil
      leaq 1(%rax), %rdx
      movq $0, %rax
      call printf 
      
      jmp .L10
    
    
     #case 55
    .L6:
        #save the pstrings    
        movq %rsi, %r14
        movq %rdx, %r15
        
        # the registers that will hold the parameters from scanf
        xorq %r12, %r12
        xorq %r13, %r13
        
        #get 2 numbers
        sub  $8, %rsp
        mov  $0, %eax   # clear AL
        movq $num, %rdi  # load format string
        leaq (%rsp), %rsi  # set storage to address of x
        call scanf
        movb (%rsp) , %r12b
        
        mov  $0, %eax    # clear AL
        movq $num, %rdi  # load format string
        leaq (%rsp), %rsi  # set storage to address of x
        call scanf
        movb (%rsp) , %r13b
        
        # call pstrijcmp with pstr1, pstr2 and the indexes we scaned
        movq %r14, %rdi
        movq %r15, %rsi
        movq %r12, %rdx
        movq %r13, %rcx
        call pstrijcmp
        
        # call prinf
        movq %rax, %rsi
        movq $str5, %rdi
        movq $0, %rax
        call printf
        
        jmp .L10
    
     #default
    .L7:
        movq $str6, %rdi
        movq $0, %rax
        call printf
        jmp .L10
    
    .L10:
        #finish the function run
        popq %r15
        popq %r14
        popq %r13
        popq %r12
        movq %rbp, %rsp
        popq %rbp
        xorq  %rax, %rax
        ret
        
        
