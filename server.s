  .data @ initialized
  @ .align 2

  .section .bss @ unitialized
  @ .align 2

  .section .rodata, "a" @ readonly
  .align 0
msg_ok:
  .asciz "200 OK"
