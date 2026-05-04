#!/usr/bin/env python3
"""
gen_rom.py — Tao file assembly RISC-V de fill day ROM bang lenh NOP don gian.

Mac dinh dung lenh `addi x0, x0, 0` (= machine code 0x00000013, 4 byte),
day la cach chuan de "khong lam gi" tren RISC-V.

Cach dung:
    python3 gen_rom.py <size> [-o output.S] [--instr "<instruction>"]

<size> tinh bang byte, ho tro hau to K / M / G:
    python3 gen_rom.py 1024
    python3 gen_rom.py 4K
    python3 gen_rom.py 1M -o my_rom.S

Sau khi gen, compile sang .bin bang riscv-gcc:
    riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 \
        -nostdlib -nostartfiles -Wl,-Ttext=0x0 -Wl,--no-relax \
        -o rom.elf rom.S
    riscv64-unknown-elf-objcopy -O binary rom.elf rom.bin
"""

import argparse
import sys


def parse_size(s: str) -> int:
    """Parse size kieu '1024', '4K', '1M', '2G'."""
    s = s.strip().upper()
    if not s:
        raise ValueError("Size khong duoc rong")

    suffixes = {"K": 1024, "M": 1024 ** 2, "G": 1024 ** 3}
    if s[-1] in suffixes:
        return int(s[:-1]) * suffixes[s[-1]]
    return int(s)


def generate(rom_size: int, output_path: str, instr: str) -> None:
    """Sinh file assembly fill day ROM bang `instr`."""
    if rom_size <= 0:
        raise ValueError("ROM size phai > 0")

    # Lenh RISC-V base (RV32I/RV64I) deu 4 byte
    if rom_size % 4 != 0:
        print(
            f"[!] Canh bao: {rom_size} khong chia het cho 4, lam tron len.",
            file=sys.stderr,
        )
        rom_size = (rom_size + 3) & ~3

    n_instr = rom_size // 4

    asm = (
        "# File nay duoc auto-generate boi gen_rom.py\n"
        f"# Tong: {rom_size} byte = {n_instr} instruction (4 byte/lenh)\n"
        f"# Lenh lap: {instr}\n\n"
        "    .section .text\n"
        "    .globl  _start\n"
        "_start:\n"
        # Dung .rept de gon thay vi viet N dong
        f"    .rept   {n_instr}\n"
        f"    {instr}\n"
        "    .endr\n"
    )

    with open(output_path, "w") as f:
        f.write(asm)

    print(f"[+] Da ghi {output_path}: {n_instr} lenh, {rom_size} byte.")


def main():
    p = argparse.ArgumentParser(
        description="Gen RISC-V assembly fill day ROM bang lenh don gian.",
    )
    p.add_argument("size", help="Kich thuoc ROM (vi du: 1024, 4K, 1M, 16M)")
    p.add_argument(
        "-o", "--output", default="rom.S",
        help="File assembly dau ra (mac dinh: rom.S)",
    )
    p.add_argument(
        "--instr", default="addi x0, x0, 0",
        help="Lenh duoc lap di lap lai (mac dinh: 'addi x0, x0, 0')",
    )
    args = p.parse_args()

    rom_size = parse_size(args.size)
    generate(rom_size, args.output, args.instr)


if __name__ == "__main__":
    main()
