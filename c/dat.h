typedef unsigned char uchar;
typedef unsigned char u8int;
typedef unsigned short u16int;
typedef unsigned long u32int;

#define IPORT ((u8int*) 0x300000)
#define OPORT ((u8int*) 0x3a0000)
enum {
	REG_NOSHADOW = 0x01,
	REG_SHADOW = 0x11,
	REG_PALBANK1 = 0x0F,
	REG_PALBANK0 = 0x1F,
};

#define GPU ((u16int*) 0x3c0000)
enum {
	VRAMADDR,
	VRAMDATA,
	VRAMINC,
};
#define PAL ((u16int*) 0x400000)

#define nil ((void*)0)
typedef char *va_list;
#define va_start(va, arg) (sizeof(arg) == 1 ? (va = (char*) &(arg) + 2) : (va = (char *) (&(arg) + 1)))
#define va_arg(va, type) ((sizeof(type) == 1) ? (va += 2, (type*)va)[-1] : (va += sizeof(type), (type*)va)[-1])
#define va_end(va)
