#include "dat.h"
#include "fns.h"

static u16int x, y;

enum {
	WIDTH = 20,
};

void
putc(char c)
{
	u16int *g;
	
	g = GPU;
	switch(c){
	case 10:
		x = 0;
		y++;
		break;
	default:
		g[VRAMADDR] = 0x7000 + (x + 8) * 0x20 + (y + 8);
		g[VRAMDATA] = (u8int) c;
		if(++x == WIDTH){
			x = 0;
			y++;
		}
	}
}

static void
putn(u32int n, int b)
{
	u32int d;

	d = udivmod(&n, n, b);
	if(d != 0)
		putn(d, b);
	if(n >= 10)
		putc(n + 'a' - 10);
	else
		putc(n + '0');
}

void
printf(char* s, ...)
{
	va_list va;
	char lng;
	
	va_start(va, s);
	for(; *s != 0; s++)
		if(*s == '%'){
			s++;
			lng = 0;
			if(*s == 'l'){
				lng = 1;
				s++;
			}
			switch(*s){
			case '%':
				putc('%');
				break;
			case 'd':
				putn(lng ? va_arg(va, u32int) : va_arg(va, u16int), 10);
				break;
			case 'o':
				putn(lng ? va_arg(va, u32int) : va_arg(va, u16int), 8);
				break;
			case 'x':
				putn(lng ? va_arg(va, u32int) : va_arg(va, u16int), 16);
				break;
			}
		}
		else
			putc(*s);
	va_end(va);
}
