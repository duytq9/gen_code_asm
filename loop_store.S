.section .text.start
.globl _start
_start:
    # Có thể giữ lại phần ghi CSR của bạn nếu cần thiết cho hệ thống
    csrwi   0x7c1, 0            # Ghi 0 vào CSR 0x7c1 (custom CSR)
    addi    s0, zero, 1         # s0 = 1

    # --- KHỞI TẠO CÁC THANH GHI CHO VÒNG LẶP TEST ---
    li      t0, 0x100000        # t0 = Địa chỉ bắt đầu của ROM (Khớp với ORIGIN trong file .ld)
    li      t1, 0x140000        # t1 = Địa chỉ giới hạn (0x100000 + 0x40000)
    li      t2, 0xDEADBEEF      # t2 = Dữ liệu mẫu 32-bit dùng để test ghi

# --- VÒNG LẶP TEST GHI 256KB ---
rom_write_loop:
    sw      t2, 0(t0)           # GHI: Thử lưu t2 vào địa chỉ hiện tại trong t0
    addi    t0, t0, 4           # TỊNH TIẾN: Cộng 4 byte vào địa chỉ để trỏ tới word tiếp theo
    blt     t0, t1, rom_write_loop # KIỂM TRA: Nếu t0 chưa chạm mốc 0x140000 thì quay lại lặp

# --- KẾT THÚC ---
loop_end:
    j       loop_end            # Vòng lặp vô tận giữ CPU lại khi đã quét xong 256KB
