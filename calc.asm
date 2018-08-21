;calc.asm
;Brock Boehler, August 2018
;Main code for RPN calculator written in x86 assembly
;Code begins execution at "main" label
;
;the following function takes arguments from STDIN and places
;the result of the calculations back into STDOUT
;
;Calling Conventions | Arguments:
;RDI, RSI, RDX, RCX, R8, R9
;Calling Conventions | return:
;RAX

extern gets
extern outf
extern outn
extern prints
extern nl

SECTION .DATA

          slash:    db '/'
          plus:     db '+'
          minus:    db '-'
          multiply: db '*'
          mask:     dq 00000000000000FFh
          welcome1: db 'Welcome to the x86 RPN calculator', 0
          welcome2: db 'Be wary of segfaults!', 0


          global main

SECTION .TEXT

;    MAIN FRAME SETUP
;    return address      rbp + 8
;    old RBP             rbp + 0
;    char pointer        rbp - 8
;    Stack arg 1
;    Stack arg 2
;    Stack arg ...

main:
          push rbp
          mov rbp, rsp

          ;print the welcome message
          mov rdi, welcome1
          call prints
          call nl
          mov rdi, welcome2
          call prints
          call nl

          call gets
          push rax

grabloop:
          mov rax, [rbp-8]
          mov rax, [rax]
          and rax, 00000000000000FFh

          ;Compare input and check for end of line or return key
          cmp rax, 0
          je done
          cmp rax, 10
          je done
          cmp rax, 15
          je done
          cmp rax, 13
          je done

          ;Check input for associated mathematical operation
          cmp rax, '+'
          je addition
          cmp rax, ' '
          je loopdone
          cmp rax, '-'
          je subtraction
          cmp rax, '*'
          je multiplication
          cmp rax, '/'
          je division
          cmp rax, '%'
          je modulus
          cmp rax, '^'
          je exponential

          ;Otherwise push the input onto the stack, after
          ;converting the input to an integer using the
          ;convertascii function.
          mov rdi, rax
          call convertascii
          push rax

loopdone:
          ;increment the string pointer and then store it
          ;back into memory
          mov rax, [rbp-8]
          add rax, 1
          mov [rbp-8], rax
          jmp grabloop
done:
          ;pop the end result into RAX to be returned
          ;to the caller function. Also restore RBP for the
          ;next function. All variables must be popped off
          ;the stack to avoid a segfault
          pop rax
          pop rcx
          pop rbp
          mov rdi, rax
          call outn
          ret

;convertascii
;takes an argument from rdi and converts a single ascii number
;to decimal

convertascii:
          push rbp
          mov rbp, rsp
          push rdi
          mov rax, rdi
          and rax, 00000000000000FFh
          add rax, -48
          pop rdi
          pop rbp
          ret

;Mathematical functions
;The following functions pop arguments off the stack and perform
;the associated mathematical operation, and then push the result back
;onto the stack

addition:
          pop rax
          pop rbx
          add rax, rbx
          push rax
          jmp loopdone

subtraction:
          pop rax
          pop rbx
          sub rbx, rax
          push rbx
          jmp loopdone

division:
          xor rdx, rdx
          pop rbx
          pop rax
          idiv rbx
          push rax
          jmp loopdone

multiplication:
          pop rax
          pop rbx
          imul rbx
          push rax
          jmp loopdone

modulus:
          xor rdx, rdx
          pop rbx
          pop rax
          idiv rbx
          push rdx
          jmp loopdone

exponential:
          pop rcx
          pop rax
          mov rbx, rax
exploop:
          imul rbx
          add rcx, -1
          cmp rcx, 1
          jne exploop
          push rax
          jmp loopdone
