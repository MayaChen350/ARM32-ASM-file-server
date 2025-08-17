# Makefile because why not (better start somewhere)
CC := arm-linux-gnu-gcc

CFLAGS := -nostdlib -static -march=armv6 -mfpu=vfp -mfloat-abi=soft

TARGET := main
SOURCE := $(TARGET).s

assemble:
	$(CC) $(CFLAGS) -o $(TARGET) $(SOURCE)

run: assemble
	qemu-arm $(TARGET)

