/* link.ld - RISC-V Boot ROM linker script */

OUTPUT_ARCH(riscv)
OUTPUT_FORMAT("elf64-littleriscv")
ENTRY(_start)

MEMORY
{
    ROM (rx) : ORIGIN = 0x100000, LENGTH = 0x1000   /* 4KB Boot ROM */
}

SECTIONS
{
    /* _start tại 0x100000 */
    .text.start 0x100000 : {
        KEEP(*(.text.start))
    } > ROM

    /* _hang tại 0x100040 */
    .text.hang 0x100040 : {
        KEEP(*(.text.hang))
    } > ROM

    /* _dtb tại 0x100080 - nơi gắn Device Tree Blob */
    .dtb 0x100080 : {
        _dtb = .;
        KEEP(*(.dtb))
    } > ROM

    /* Bỏ các section thừa */
    /DISCARD/ : {
        *(.comment)
        *(.note*)
        *(.eh_frame*)
        *(.riscv.attributes)
    }
}
