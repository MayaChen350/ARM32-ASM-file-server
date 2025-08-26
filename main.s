  .data @ initialized
  .global hello
  .align 0
hello:
  .string "hello world!!!! :3 :3 :3 :3\n"

  .extern brk_ptr
  .extern print

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
  mov r2, #(.Lmsg_start_end - .Lmsg_start)
  bl print
  mov r7, #1 @ sys_exit
  mov r0, #0
  svc 0
  .align 2
.Lbrk_ptr:
  .word brk_ptr
.Lmsg_start:
  .string "Initiated.\n"
.Lmsg_start_end:
