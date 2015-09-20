AS=m68k-elf-as
CC=m68k-elf-gcc
LD=m68k-elf-ld
OBJCOPY=m68k-elf-objcopy
CFLAGS=-Wall -Wno-parentheses -fno-builtin -fno-diagnostics-show-caret -fno-diagnostics-color -O2 -march=68000 -mshort
O=\
	start.o\
	cons.o\
	main.o\
	div.o\

all: code.mif

clean:
	rm -f $(O)

.PHONY: all clean

code.mif: code.elf
	$(OBJCOPY) -O binary -j .text -j .data --gap-fill=2 $< /dev/stdout | xxd -p -c 32 | sed 's/..../& /g' | awk ' BEGIN { print "DEPTH = 4096;\nWIDTH = 16;\nADDRESS_RADIX = HEX;\nDATA_RADIX = HEX;\nCONTENT\nBEGIN"; a = 0 } { printf "%.5x : ", a; a += NF; for(i = 1; i <= NF; i++) printf "%s ", $$i; print ";" } END { print "END;" } ' > code.mif

code.elf: $(O) link.ld
	$(LD) -o $@ -T link.ld $(O)

%.o: %.s
	$(AS) $< -o $@

%.o: %.c dat.h fns.h
	$(CC) $(CFLAGS) -c $< -o $@
