extern	printf
extern  puts
extern atoi
extern putchar

%macro saveregs 0
    push rbx
    push rsp
    push rbp
    push r12
    push r13
    push r14
    push r15
%endmacro

%macro restoreregs 0
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    pop rsp
    pop rbx
%endmacro

%macro  print_string_imm 1
    section .data
        %%.val:   db  %1,0    
        %%.fmt:   db "%s",0
    section .text
        saveregs
        mov     rdi, %%.fmt
        mov     rsi, %%.val
        mov     rax, qword 0
        call    printf
        restoreregs
%endmacro

%macro  print_string 1
    section .data
        %%.fmt:   db "%s",0
    section .text
        saveregs
        mov     rdi, %%.fmt
        mov     rsi, %1
        mov     rax, qword 0
        call    printf
        restoreregs
%endmacro

%macro  print_puts 1
        saveregs
        mov     rdi, %1
        call    puts
        restoreregs
%endmacro

%macro  print_int 1
    section .data
        %%.fmt:   db "%ld",0
    section .text
        saveregs
        mov     rdi, %%.fmt
        mov     rsi, qword %1
        mov     rax, qword 0
        call    printf
        restoreregs
%endmacro

%macro print_char 1
        mov rdi, %1
        call putchar
%endmacro


%macro print_char_from_string 2
        mov rdi, [%1+%2]
        call putchar
%endmacro

%macro first_char_is_L 1
        mov r8, %1
        mov al, [r8]
        cmp al, 0x4C
        jne %%.no      
        jmp %%.yes
    %%.no:
        mov rax, qword 0
        jmp %%.end
    %%.yes:
        mov rax, qword 1
        jmp %%.end
        %%.end:
%endmacro

%macro second_char_is_upper_case 1 
        mov r8, %1
        mov al, [r8+1]
        cmp al, 0x41   
        jl %%.no
        cmp al, 0x5A
        jg %%.no
        jmp %%.yes
    %%.no:
        mov rax, qword 0
        jmp %%.end
    %%.yes:
        mov rax, qword 1
        jmp %%.end
        %%.end:
%endmacro

%macro third_char_is_S 1
        mov r8, %1
        mov al, [r8+2]
        cmp al, 0x53
        jne %%.no      
        jmp %%.yes
    %%.no:
        mov rax, qword 0
        jmp %%.end
    %%.yes:
        mov rax, qword 1
        jmp %%.end
        %%.end:
%endmacro

%macro  br 0
    section .data
        %%.fmt:   db 10,0
    section .text
        saveregs
        mov     rdi, %%.fmt
        mov     rax, qword 0
        call    printf
        restoreregs
%endmacro

%macro newString 2
    jmp %1_after_def
    %1 db %2, 0
    %1_after_def:
%endmacro

%macro	exit 0
	mov	rax, 60
	xor	rdi, rdi
	syscall
%endmacro

%macro str_len 1
    saveregs
    mov rdi, %1
    call strlen
    restoreregs
%endmacro

%macro is_digit 1
        mov r8, rax
        cmp r8, 0
        je %%.not_char
        cmp r8, 0x41
        jl %%.not_char
        cmp r8, 0x5A
        jle %%.is_char
        cmp r8, 0x61
        jl %%.not_char
        cmp r8, 0x7A
        jg %%.not_char
    %%.is_char:
        mov rax, qword 1
        jmp %%.halt
    %%.not_char:
        mov rax, qword 0
    %%.halt
%endmacro

%macro clearreg 1
        xor %1, %1
%endmacro

%macro err 1
        print_string_imm %1
        br
        exit
%endmacro


%macro repeatint 2 ; args: char, #, repeat char by # times
        mov r12, %2
    %%.loop:
        cmp r12, 0
        jle %%.end_loop
        print_int %1
        ;print_int $1
        dec r12
        jmp %%.loop
    %%.end_loop:
%endmacro

%macro repeatchar 2 ; args: char, #, repeat char by # times
        mov r12, %2
    %%.loop:
        cmp r12, 0
        jle %%.end_loop
        print_char %1
        ;print_int $1
        dec r12
        jmp %%.loop
    %%.end_loop:
%endmacro
