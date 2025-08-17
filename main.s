  .data @ initialized
  .align 2
  .global hello
hello:
  .string "hello world"

  .section .bss @ unitialized
  .align 2

  .section .rodata, "a" @ readonly
  .align 2

  .text
  .align 2
  .arm
  .global _start
_start:
  mov r7, #4 @ sys_write
  mov r0, #1 @ stdout
  adr r1, hello
  mov r2, #11
  svc 0

  mov r7, #1
  mov r0, #0
  svc 0
