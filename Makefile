# Makefile because why not (better start somewhere)
CC := arm-linux-gnu

CFLAGS := -nostdlib -static  -march=armv6 -mfpu=vfp -mfloat-abi=soft

TARGET := main
SOURCE := $(wildcard *.s)
OBJECTS := $(patsubst %s,%o, $(SOURCE))

$(TARGET): $(OBJECTS)
	$(CC)-gcc $(CFLAGS) -o $@ $<

assemble: $(TARGET)

%.o: %.s
	$(CC)-as -o $@ $<

run: assemble
	qemu-arm $(TARGET)

