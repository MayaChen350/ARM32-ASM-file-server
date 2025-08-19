  .data @ initialized
  @ .align 2

  .section .bss @ unitialized
  @ .align 2

  .section .rodata, "a" @ readonly
  @ .align 2

  .text
  .global create_tcp_packet
  .align 4
create_tcp_packet:
  @ params:
  @   r0: buffer pointer
  @   r1: ptr data
  @   r2: data size
  @   r3: source port
  @   sp+4: destination port
  @   sp+8: flags
  @
  @ return: pointer to the packet buffer

  @ source port 16 bits
  @ destination port 16 bits (why 16 bits for a port number wtf)
  @ sequence number 32 bits (defined mostly by the flag)
  @ acknowldgement number 32 bits (next sequence number when ACK bit is set)
  @ TCP header size 4 bits (not actual name)
  @ Reserved 4 bits (useless, most likely all set to 0 anyway)
  @ flags 8 bits (it's at sp+8 here)
  @ window 16 bits (whatever that is)
  @ checksum 16 bits (error checking)
  @ urgent pointer 16 (meaningful if URG flag is set, it defines the offset to "the last urgent data byte")
  @ Options 0-320 bits (padded in 32 bits chunks, 
