  .data @ initialized
  .global hello
  .align 2
hello:
  .string "hello world!!!! :3 :3 :3 :3"

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
  ldr r1,=brk_ptr
  str r0, [r1]

  ldr r1, =hello
  bl println
  mov r7, #1 @ sys_exit
  svc 0

.global println
.align 4
println:
  @ error handling
  ldrsb r0, [r1]
  tst r0, r0
  bne .Lno_error
  mov r0, #1
  bx lr

.Lno_error:
  stmdb sp!, {r4, r7}
  cpy r4, r1 @ saving pointer original position
  mov r2, #0 @ index/chars size

.Lcount_until_null:
  add r2, r2, #1
  ldrsb r3, [r1], #1 @ load character at hello
  tst r3, r3
  bne .Lcount_until_null @ check if null

  mov r0, #0xA @ \n
  strb r0, [r1] @ end the line with a LF
  add r2, r2, #1

  mov r7, #4 @ sys_write
  mov r0, #1 @ stdout
  cpy r1, r4
  svc 0

  ldmia sp!, {r4, r7}
  mov r0, #0 @ success :D
  bx lr
