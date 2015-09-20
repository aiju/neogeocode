#include "dat.h"
#include "fns.h"

static void
init(void)
{
	uchar *p, *q;
	extern uchar _etext, _data, _edata, _ebss;
	
	for(p = &_etext, q = &_data; q < &_edata; )
		*q++ = *p++;
	while(q < &_ebss)
		*q++ = 0;

	OPORT[REG_NOSHADOW] = 0;
	OPORT[REG_PALBANK0] = 0;
	
	PAL[0] = 0x8000;
	PAL[1] = 0x7fff;
	PAL[4095] = 0x8000;
}

u32int
__udivsi3(u32int a, u32int b)
{
	return udivmod(nil, a, b);
}

u32int
__umodsi3(u32int a, u32int b)
{
	u32int c;
	
	udivmod(&c, a, b);
	return c;
}

void
putlong(u32int n)
{
	static const uchar hd[] = "0123456789abcdef";
	
	putc(hd[n >> 28]);
	putc(hd[n >> 24 & 0xf]);
	putc(hd[n >> 20 & 0xf]);
	putc(hd[n >> 16 & 0xf]);
	putc(hd[n >> 12 & 0xf]);
	putc(hd[n >> 8 & 0xf]);
	putc(hd[n >> 4 & 0xf]);
	putc(hd[n & 0xf]);
	putc(10);
}

int
main(void)
{
	init();

	printf("%x", 31337);
	return 0;
}
