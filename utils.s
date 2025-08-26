.text
.global print
.arm
.align 2
print:
  @ params:
  @   r0: (unused for less instructions)
  @   r1: ptr to strings
  @   r2: num of chars (if 0 then will be counted from null terminated str)
  @
  @ returns: whatever

  str r7, [sp, #-4]!
  tst r2, r2
  bne .Lfinished
  cpy r2, r1

.Lcount_until_null:
  ldrsb r3, [r2], #1 @ load character
  tst r3, r3
  bne .Lcount_until_null @ check if null

  sub r2, r2, r1 @ size
.Lfinished:
  mov r7, #4 @ sys_write
  mov r0, #1 @ stdout
  @ r1 has not been modified
  svc 0

  ldr r7, [sp], #4
  bx lr


.equ PROGRAM_EXIT_CODE, 1
.equ OUT_MEM_CODE, 2
.equ CHUNK_NO_BOUND_CODE, 2

.global fatal_error
.align 1
.thumb_func
fatal_error:
  @ params:
  @   r0: exit code
  @
  @ returns: nothing, it exits
  cpy r3, r0

  @ Write "Fatal Error"
  mov r7, #4 @ sys_write
  mov r0, #2 @ stderr
  adr r1, .str_fatalError
  mov r2, #(.Lfatal_error_end - .str_fatalError) @ size
  swi 0

  cmp r3, #1
  beq .Lprogram_exit

  @ Check which error message to write
  cmp r3, #OUT_MEM_CODE
  beq .Lout_of_memory
  cmp r3, #CHUNK_NO_BOUND_CODE
  beq .Lchunk_out_of_bound
  @ else
  b .Lprogram_exit

.Lout_of_memory:
  adr r1, .str_outOfMemory
  mov r2, #(.Lout_of_memory_end - .str_outOfMemory) @ size
  b .Lwrite_error_description
.Lchunk_out_of_bound:
  adr r1, .str_chunkIndexOutOfBound
  mov r2, #(.Lchunk_no_bound_end - .str_chunkIndexOutOfBound) @ size
  @ b .Lwrite_error_description

.Lwrite_error_description:
  mov r0, #2 @ stderr
  swi 0

.Lprogram_exit:
  mov r7, #1 @ sys_exit
  mov r0, r3
  swi 0

  .align 0
.str_fatalError: @ code 1
  .ascii "Fatal Error"
.Lfatal_error_end:

  .align 0
.str_outOfMemory: @ code 2
  .ascii ": Out of memory"
.Lout_of_memory_end:

  .align 0
.str_chunkIndexOutOfBound:
  .ascii ": Chunk index out of bound"
.Lchunk_no_bound_end:


@ All of my defined error messages for error codes:
@ 1: Unknown/Undefined
@ 2: Out of memory
@ 3: Chunk index out of bound (if that happens, this is probably my fault)
