MEMORY
{
	rom (rx) : ORIGIN = 0, LENGTH = 1M
	ram (!rx) : org = 0x100000, LENGTH = 64K
}

SECTIONS
{
	.text : {
		*(.header)
		*(.text*)
		*(.rodata*)
		. = ALIGN(2);
		_etext = .;
	} > rom
	.data : {
		_data = .;
		*(.data*)
		. = ALIGN(2);
		_edata = .;
	} > ram AT>rom
	.bss : {
		*(.bss*)
		_ebss = .;
	} > ram
}
