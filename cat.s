.include "lib/sys_read.s"
.include "lib/sys_write.s"
.include "lib/sys_open.s"
.include "lib/sys_close.s"
.include "lib/sys_stat.s"
.include "lib/sys_exit.s"

.section .data
usage: .string "Usage: cat <filename>\n"
usage_len: .quad . - usage

error: .string "error: could not open file\n"
error_len: .quad . - error

.section .bss
.lcomm buff, 1024

.section .text
.global _start
_start:
    movq %rsp, %rbp
    subq $144, %rsp
    movq %rbp, %rbx

    cmpq $2, (%rbx)
    jne  exit_usage

    addq $16, %rbx  # skip argv[0] and argv[1]
section0:
    open (%rbx), O_RDONLY(%rip), $0
    pushq %rax
    testq %rax, %rax
    js exit_error

    close %rax
section1:
    stat -152(%rbp), -144(%rbp)
    leaq -144(%rbp), %rbx

    movq 48(%rbx), %rax
    cqo
    movq $1024, %rcx
    div %rcx

section2:
    incq %rax
    movq %rax, %r8
.LP0:
    read -152(%rbp), buff(%rip), $1024
    write $1, buff(%rip), %rax

    decq %r8
    cmpq $0, %r8
    jne .LP0

exit_success:
    exit $0

exit_usage:
    write $1, usage(%rip), usage_len(%rip)
    exit $-1

exit_error:
    write $1, error(%rip), error_len(%rip)
    exit $-2
