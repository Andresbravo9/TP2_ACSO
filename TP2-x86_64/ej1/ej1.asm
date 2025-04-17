section .data

LC0:    db "", 0
LC1:    db "List length: %d\n", 0
LC2:    db "\tnode hash: %s | type: %d\n", 0


section .text

extern malloc
extern free
extern strlen
extern strcpy
extern strcat
extern fprintf

global string_proc_list_create_asm
global string_proc_node_create_asm
global string_proc_list_add_node_asm
global string_proc_list_concat_asm
global string_proc_list_destroy_asm
global string_proc_node_destroy_asm
global str_concat_asm
global string_proc_list_print_asm


string_proc_list_create_asm:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 16
        mov     edi, 16
        call    malloc
        mov     QWORD  [rbp-8], rax
        cmp     QWORD  [rbp-8], 0
        jne     .L2
        mov     eax, 0
        jmp     .L3
.L2:
        mov     rax, QWORD  [rbp-8]
        mov     QWORD  [rax], 0
        mov     rax, QWORD  [rbp-8]
        mov     QWORD  [rax+8], 0
        mov     rax, QWORD  [rbp-8]
.L3:
        leave
        ret
string_proc_node_create_asm:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 32
        mov     eax, edi
        mov     QWORD  [rbp-32], rsi
        mov     BYTE  [rbp-20], al
        mov     edi, 32
        call    malloc
        mov     QWORD  [rbp-8], rax
        cmp     QWORD  [rbp-8], 0
        je      .L5
        cmp     QWORD  [rbp-32], 0
        jne     .L6
.L5:
        mov     eax, 0
        jmp     .L7
.L6:
        mov     rax, QWORD  [rbp-8]
        movzx   edx, BYTE  [rbp-20]
        mov     BYTE  [rax+16], dl
        mov     rax, QWORD  [rbp-8]
        mov     rdx, QWORD  [rbp-32]
        mov     QWORD  [rax+24], rdx
        mov     rax, QWORD  [rbp-8]
        mov     QWORD  [rax], 0
        mov     rax, QWORD  [rbp-8]
        mov     QWORD  [rax+8], 0
        mov     rax, QWORD  [rbp-8]
.L7:
        leave
        ret
string_proc_list_add_node_asm:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 48
        mov     QWORD  [rbp-24], rdi
        mov     eax, esi
        mov     QWORD  [rbp-40], rdx
        mov     BYTE  [rbp-28], al
        cmp     QWORD  [rbp-24], 0
        je      .L13
        cmp     QWORD  [rbp-40], 0
        je      .L13
        movzx   eax, BYTE  [rbp-28]
        mov     rdx, QWORD  [rbp-40]
        mov     rsi, rdx
        mov     edi, eax
        call    string_proc_node_create_asm
        mov     QWORD  [rbp-8], rax
        mov     rax, QWORD  [rbp-24]
        mov     rax, QWORD  [rax]
        test    rax, rax
        jne     .L12
        mov     rax, QWORD  [rbp-24]
        mov     rdx, QWORD  [rbp-8]
        mov     QWORD  [rax], rdx
        mov     rax, QWORD  [rbp-24]
        mov     rdx, QWORD  [rbp-8]
        mov     QWORD  [rax+8], rdx
        jmp     .L8
.L12:
        mov     rax, QWORD  [rbp-24]
        mov     rax, QWORD  [rax+8]
        mov     rdx, QWORD  [rbp-8]
        mov     QWORD  [rax], rdx
        mov     rax, QWORD  [rbp-24]
        mov     rdx, QWORD  [rax+8]
        mov     rax, QWORD  [rbp-8]
        mov     QWORD  [rax+8], rdx
        mov     rax, QWORD  [rbp-24]
        mov     rdx, QWORD  [rbp-8]
        mov     QWORD  [rax+8], rdx
        jmp     .L8
.L13:
        nop
.L8:
        leave
        ret

string_proc_list_concat_asm:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 64
        mov     QWORD  [rbp-40], rdi
        mov     eax, esi
        mov     QWORD  [rbp-56], rdx
        mov     BYTE  [rbp-44], al
        cmp     QWORD  [rbp-40], 0
        je      .L15
        cmp     QWORD  [rbp-56], 0
        jne     .L16
.L15:
        mov     eax, 0
        jmp     .L17
.L16:
        mov     rax, QWORD  [rbp-56]
        mov     rsi, rax
        mov     edi, LC0
        call    str_concat_asm
        mov     QWORD  [rbp-8], rax
        cmp     QWORD  [rbp-8], 0
        jne     .L18
        mov     eax, 0
        jmp     .L17
.L18:
        mov     rax, QWORD  [rbp-40]
        mov     rax, QWORD  [rax]
        mov     QWORD  [rbp-16], rax
        jmp     .L19
.L22:
        mov     rax, QWORD  [rbp-16]
        movzx   eax, BYTE  [rax+16]
        cmp     BYTE  [rbp-44], al
        jne     .L20
        mov     rax, QWORD  [rbp-8]
        mov     QWORD  [rbp-24], rax
        mov     rax, QWORD  [rbp-16]
        mov     rdx, QWORD  [rax+24]
        mov     rax, QWORD  [rbp-8]
        mov     rsi, rdx
        mov     rdi, rax
        call    str_concat_asm
        mov     QWORD  [rbp-8], rax
        cmp     QWORD  [rbp-8], 0
        jne     .L21
        mov     rax, QWORD  [rbp-24]
        mov     rdi, rax
        call    free
        mov     eax, 0
        jmp     .L17
.L21:
        mov     rax, QWORD  [rbp-24]
        mov     rdi, rax
        call    free
.L20:
        mov     rax, QWORD  [rbp-16]
        mov     rax, QWORD  [rax]
        mov     QWORD  [rbp-16], rax
.L19:
        cmp     QWORD  [rbp-16], 0
        jne     .L22
        mov     rax, QWORD  [rbp-8]
.L17:
        leave
        ret
string_proc_list_destroy_asm:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 32
        mov     QWORD  [rbp-24], rdi
        cmp     QWORD  [rbp-24], 0
        je      .L28
        mov     rax, QWORD  [rbp-24]
        mov     rax, QWORD  [rax]
        mov     QWORD  [rbp-8], rax
        mov     QWORD  [rbp-16], 0
        jmp     .L26
.L27:
        mov     rax, QWORD  [rbp-8]
        mov     rax, QWORD  [rax]
        mov     QWORD  [rbp-16], rax
        mov     rax, QWORD  [rbp-8]
        mov     rdi, rax
        call    string_proc_node_destroy_asm
        mov     rax, QWORD  [rbp-16]
        mov     QWORD  [rbp-8], rax
.L26:
        cmp     QWORD  [rbp-8], 0
        jne     .L27
        mov     rax, QWORD  [rbp-24]
        mov     rdi, rax
        call    free
        jmp     .L23
.L28:
        nop
.L23:
        leave
        ret
string_proc_node_destroy_asm:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 16
        mov     QWORD  [rbp-8], rdi
        mov     rax, QWORD  [rbp-8]
        mov     QWORD  [rax], 0
        mov     rax, QWORD  [rbp-8]
        mov     QWORD  [rax+8], 0
        mov     rax, QWORD  [rbp-8]
        mov     QWORD  [rax+24], 0
        mov     rax, QWORD  [rbp-8]
        mov     rdi, rax
        call    free
        nop
        leave
        ret
str_concat_asm:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 48
        mov     QWORD  [rbp-40], rdi
        mov     QWORD  [rbp-48], rsi
        mov     rax, QWORD  [rbp-40]
        mov     rdi, rax
        call    strlen
        mov     DWORD  [rbp-4], eax
        mov     rax, QWORD  [rbp-48]
        mov     rdi, rax
        call    strlen
        mov     DWORD  [rbp-8], eax
        mov     edx, DWORD  [rbp-4]
        mov     eax, DWORD  [rbp-8]
        add     eax, edx
        mov     DWORD  [rbp-12], eax
        mov     eax, DWORD  [rbp-12]
        add     eax, 1
        cdqe
        mov     rdi, rax
        call    malloc
        mov     QWORD  [rbp-24], rax
        cmp     QWORD  [rbp-24], 0
        jne     .L31
        mov     eax, 0
        jmp     .L32
.L31:
        mov     rdx, QWORD  [rbp-40]
        mov     rax, QWORD  [rbp-24]
        mov     rsi, rdx
        mov     rdi, rax
        call    strcpy
        mov     rdx, QWORD  [rbp-48]
        mov     rax, QWORD  [rbp-24]
        mov     rsi, rdx
        mov     rdi, rax
        call    strcat
        mov     rax, QWORD  [rbp-24]
.L32:
        leave
        ret

string_proc_list_print_asm:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 32
        mov     QWORD  [rbp-24], rdi
        mov     QWORD  [rbp-32], rsi
        cmp     QWORD  [rbp-24], 0
        je      .L41
        cmp     QWORD  [rbp-32], 0
        je      .L41
        mov     DWORD  [rbp-4], 0
        mov     rax, QWORD  [rbp-24]
        mov     rax, QWORD  [rax]
        mov     QWORD  [rbp-16], rax
        jmp     .L37
.L38:
        add     DWORD  [rbp-4], 1
        mov     rax, QWORD  [rbp-16]
        mov     rax, QWORD  [rax]
        mov     QWORD  [rbp-16], rax
.L37:
        cmp     QWORD  [rbp-16], 0
        jne     .L38
        mov     edx, DWORD  [rbp-4]
        mov     rax, QWORD  [rbp-32]
        mov     esi, LC1
        mov     rdi, rax
        mov     eax, 0
        call    fprintf
        mov     rax, QWORD  [rbp-24]
        mov     rax, QWORD  [rax]
        mov     QWORD  [rbp-16], rax
        jmp     .L39
.L40:
        mov     rax, QWORD  [rbp-16]
        movzx   eax, BYTE  [rax+16]
        movzx   ecx, al
        mov     rax, QWORD  [rbp-16]
        mov     rdx, QWORD  [rax+24]
        mov     rax, QWORD  [rbp-32]
        mov     esi, LC2
        mov     rdi, rax
        mov     eax, 0
        call    fprintf
        mov     rax, QWORD  [rbp-16]
        mov     rax, QWORD  [rax]
        mov     QWORD  [rbp-16], rax
.L39:
        cmp     QWORD  [rbp-16], 0
        jne     .L40
        jmp     .L33
.L41:
        nop
.L33:
        leave
        ret