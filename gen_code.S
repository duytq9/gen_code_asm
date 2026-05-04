.section .text.start
.globl _start
_start:
    csrwi   0x7c1, 0          # ghi 0 vào CSR 0x7c1 (custom CSR)
    addiw   s0, zero, 1       # s0 = 1
    slli    s0, s0, 0x1f      # s0 = 1 << 31 = 0x80000000
    csrr    a0, mhartid       # a0 = hart ID
    auipc   a1, 0x0           # a1 = PC hiện tại
    addi    a1, a1, 114       # a1 = a1 + 114 -> trỏ tới _dtb (0x100080)
    jr      s0                # nhảy tới địa chỉ trong s0 (0x80000000)

.section .text.hang
.globl _hang
_hang:
    csrwi   0x7c1, 0          # ghi 0 vào CSR 0x7c1
    csrr    a0, mhartid       # a0 = hart ID
    auipc   a1, 0x0           # a1 = PC hiện tại
    addi    a1, a1, 56        # a1 = a1 + 56 -> trỏ tới _dtb
    csrwi   mie, 0            # tắt machine interrupt enable
1:  wfi                       # wait-for-interrupt
    j       1b                # nhảy về nhãn 1 phía trên (vòng lặp vô hạn)
