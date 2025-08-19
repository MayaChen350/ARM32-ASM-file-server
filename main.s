  .data @ initialized
  .global hello
  .align 2
hello:
  .string "hello world!!!! :3 :3 :3 :3\n"

  .extern brk_ptr

  .section .bss @ unitialized
  @ .align 2

  .section .rodata, "a" @ readonly
  @ .align 2

  .text
  .global _start
  .align 2
_start:
  @ "init" brk_ptr
  mov r0, #0
  mov r7, #0x2d @ sys_brk
  svc 0
  ldr r1,.Lbrk_ptr
  str r0, [r1]

  adr r1, .Lmsg_start
  bl print
  mov r7, #1 @ sys_exit
  mov r0, #0
  svc 0
.Lbrk_ptr:
  .word brk_ptr
.Lmsg_start:
  .string "Initiated.\n"

.global print @ no more println
.align 4
print:
  cpy r2, r1
  str r7, [sp, #-4]!

.Lcount_until_null:
  ldrsb r3, [r2], #1 @ load character
  tst r3, r3
  bne .Lcount_until_null @ check if null

  mov r7, #4 @ sys_write
  mov r0, #1 @ stdout
  @ r1 has not been modified
  sub r2, r2, r1 @ size
  svc 0

  ldr r7, [sp], #4
  bx lr
