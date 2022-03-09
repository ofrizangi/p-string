    # 207488305 ofri zangi

.section .rodata #read only data section

str4:	.string	"invalid input!\n"

.text

# &pstr in %rdi
.global pstrlen
.type	pstrlen, @function
pstrlen:
    xorq %rax, %rax
    movb (%rdi) , %al #the leangt is in the first byte
    ret
     
# &pstr in %rdi, oldChar in %rsi, newChar in %rdx         
.global replaceChar
.type	replaceChar, @function
replaceChar:
   xorq %rcx , %rcx
   movb (%rdi) , %cl # getting the leangth of the string
   xorq %r8, %r8
   movb $0 , %r8b # i=0
   cmpb %r8b, %cl # if the len is 0
   je .finish
   
   .loopstart:
       xorq %r10, %r10
       addb $1 , %r8b # going to the next charecter
       movb (%rdi , %r8, 1) , %r10b
       cmpb %r10b , %sil  #checking if the string char is eqaul to oldCahr
       jne .end
        
       movb %dl , (%rdi, %r8, 1)  #if they are equal we want to switch to the new char 
        
       .end:      
        cmpb %r8b, %cl #if they are not equal and we didn't the string, we want to continue
        jne .loopstart                  
   .finish:
        movq %rdi , %rax # returnind &pstr
        ret    
        
        
# &pstr_dst in %rdi, $pstr_src in %rsi, i in %rdx, j in %rcx        
.global pstrijcpy
.type	pstrijcpy, @function        
pstrijcpy:
    xorq %r9, %r9
    
    #check if the index are out of bound from dst
    movb (%rdi), %r9b # saving length
    subb $1, %r9b # the index starts from zero, so we want to check if it's smaller than len-1
    cmpb %r9b, %dl #if i>size
    jg .error
    cmpb %r9b, %cl #if j>size
    jg .error
    
    #check if the index are out of bound of src
    movb (%rsi), %r9b # saving length
    subb $1, %r9b # the index starts from zero, so we want to check if it's smaller than len-1
    cmpb %r9b , %dl #if i>size
    jg .error
    cmpb %r9b , %cl #if j>size
    jg .error
    
    .loopstart3:
        xorq %r8, %r8
        addq $1, %rdx
        movb (%rsi , %rdx, 1), %r8b # the src char
        movb %r8b, (%rdi, %rdx, 1) #put it in the right place in dst. pstr_dst[i]=pstr_src[i]
        cmpq %rcx , %rdx
        jle .loopstart3
        jmp .fin
        
     # if the indexes are ut of bound       
    .error:
         movq $str4,%rdi #first parameter to print
         movq $0, %rax
         call printf
    
    .fin:
        movq %rdi, %rax #returning &pstr_dst
        ret        
                                
        
        
# &pstr in %rdi        
.global swapCase
.type	swapCase, @function
swapCase:
   xorq %rcx, %rcx
   movb (%rdi) , %cl # getting the length of the string
   xorq %r8, %r8
   movb $0 , %r8b # i=0
   cmpb %r8b, %cl # if the len is 0
   movzbq %r8b, %r8
   je .done
   
   .loopstart2:
        xorq %rsi, %rsi
        addb $1 , %r8b # going to the next cahrecter
        movb (%rdi, %r8 , 1), %sil
        
        cmpb $65, %sil # if  char_value < 65
        jl .end2      #it's not a letter so we want to finish
        
        cmpb $90, %sil # if char_value<=90
        jle .changeToLittle # we want to change it to a little letter
        
        cmpb $96, %sil # if 90< char_value <= 96
        jle .end2 #it's not a letter so we want to finish
        
        cmpb $122, %sil # if char_value > 122
        jg .end2 #it's not a letter so we want to finish
        jmp .changeToBig # we want through all the other cases so this is a small letter 
        
        .changeToLittle:
            addb $32 , (%rdi , %r8 ,1)
            jmp .end2
            
        .changeToBig:
            subb $32 , (%rdi , %r8 ,1) 
       
         .end2:      
            cmpb %r8b, %cl #if they are not equal we want to continue
            jne .loopstart2   
                      
      .done:
            movq %rdi, %rax
            ret  

                        
# &pstr1 in %rdi, &psrt2 in %rsi, i in %rdx, j in %rcx        
.global pstrijcmp
.type	pstrijcmp, @function            
pstrijcmp:
    xorq %r9, %r9
    # check if the index are out of bound from pstr1
    movb (%rdi), %r9b
    subb $1, %r9b # the index strarts from zero, so we want to check if it's smaller than len-1
    cmpb %r9b, %dl
    jg .error2
    cmpb %r9b, %cl
    jg .error2
    
    # check if the index are out of bound of pstr2
    movb (%rsi), %r9b
    subb $1, %r9b # the index strarts from zero, so we want to check if it's smaller than len-1
    cmpb %r9b , %dl #if i>size
    jg .error2
    cmpb %r9b , %cl #if j>size
    jg .error2
    
    .loopstart4:
        xorq %r8, %r8
        xorq %r9, %r9
        addq $1, %rdx
        movb (%rdi, %rdx, 1), %r8b 
        movb (%rsi, %rdx, 1), %r9b
        cmpb %r9b, %r8b # compering both charaters
        jg .pstr1IsBigger
        jl .pstr1IsSmaller
        cmpq %rcx, %rdx # if i!=j
        jle .loopstart4
        
     movq $0, %rax
     jmp .fin2
     
     # if the indexes are out of bound
    .error2:
       movq $0, %rax
       movq $str4, %rdi
       call printf
       movq $-2, %rax
       jmp .fin2
     
    .pstr1IsBigger:
       movq $1 , %rax
       jmp .fin2
    
    .pstr1IsSmaller:
        movq $-1, %rax

    .fin2:
        ret                    
            
