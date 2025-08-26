@ macros
  .equ TOTAL_ALLOCATIONS, 256 

  .bss
  .global brk_ptr
  .align 2
brk_ptr:
  .space 4

  .align 6
reserved_chunks:
  .space (TOTAL_ALLOCATIONS*4)

  .data
  .align 1
chunk_index:
  .hword 0

.text

  .extern fatal_error

.global mayalloc
.align 4
mayalloc:
  @ params:
  @   r1: size
  @
  @ returns: start address of new mem block
  stmdb sp!, {r4, r5, r6, r7}
  ldr r12, =brk_ptr @ ptr**
  ldr r3, [r12] @ ptr*

  ldr r0, [r3, r1]
  add r0, r0, #2 @ the 2 bytes for the 16 bit index to the reserved_chunk
  mov r7, #0x2d @ sys_brk
  swi 0

  @ error handling
  cmp r0, r3
  moveq r0, #2 @ out of memory code
  beq .Lerror

  @ insert the 2 bytes of the chunk_ptr
  ldr r4, =chunk_index @ chunk_index ptr
  ldrh r5, [r4] @ chunk_index
  strh r5, [r3] @ index at 2 first bytes of the allocation

  @ update things
  ldr r6,=reserved_chunks
  orr r7, r1, #(1<<31) @ alloc size with first bit at HIGH
  str r7, [r6, r5] @ update the reserved chunks at index
  add r5, r5, #1

  @ error handling
  cmp r5, #TOTAL_ALLOCATIONS
  movgt r0, #3
  bgt .Lerror

  strh r5, [r4] @ update chunk_index
  str r0, [r12] @ update brk_ptr

  @ return
  sub r0, r1 @ back to the start
  ldmia sp!, {r4, r5, r6, r7}
  bx lr
.Lerror:
  ldr r1, =fatal_error
  bx r1

  .global maya_free
  .align 4
maya_free:
  @ params:
  @   r0: block pointer from mayalloc
  @
  @ returns: not important
                     @ the chunk index is the two bytes before the block
  ldrh r1, [r0, #-2] @ chunk index for the block

  ldr r2,=reserved_chunks
  @ Those values contain:
  @   1 bit for if it's still reserved or not
  @   31 bits for the actual value allocated

  @ verifying if it's time to unallocate (or not and mostly just return)
  ldr r3,=chunk_index
  ldr r3, [r3]
  @ load chunk int32 in advance
  ldr r0, [r2, r1, lsl #2]
  sub r0, r0, #(1<<31) @ unset first bit

  @ verifying
  cmp r3, r1
  strne r0, [r2, r1, lsl #2]
  bxne lr

  @ actually deallocating memory
  movs r12, r0 @ number for how much we deallocate

.Lfreeing_heap:
  addeq r12, r12, r0
  sub r3, r3, #1  @ current chunk_index
  ldr r0, [r2, r3, lsl #2] @ load new byte
  tst r0, #(1<<31)
  beq .Lfreeing_heap

  @ we finally deallocate memory
  str r7, [sp, #-4]!
  mov r7, #0x2d @ sys_brk
  ldr r1,=brk_ptr
  ldr r0, [r1]
  sub r0, r0, r12
  swi 0
  str r0, [r1] @ update brk_ptr
  ldr r7, [sp], #4
  bx lr
