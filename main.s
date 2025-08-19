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
  ldr r1,=brk_ptr
  str r0, [r1]

  ldr r1, =hello
  bl print
  mov r7, #1 @ sys_exit
  svc 0

.global print @ no more println
.align 4
print:
  @ error handling
  @ldrsb r0, [r1]
  @tst r0, r0
  @moveq r0, #1
  @bxeq lr

@ no_error:
 mov r2, #0 @ index/chars size
 stmdb sp!, {r2, r7}

.Lcount_until_null:
  add r2, r2, #1
  ldrsb r3, [r1, r2] @ load character at hello
  tst r3, r3
  bne .Lcount_until_null @ check if null

  mov r7, #4 @ sys_write
  mov r0, #1 @ stdout
  @ r1 has not been modified
  @ r2 was incrementing in the loop
  svc 0

  ldmia sp!, {r0, r7}
  bx lr

