# Stitch — NostalPlay

- Project: `NostalPlay Retro Handheld Console`, ID `14001543918404638904`
- Design system "NostalPlay Monolith LCD": `assets/96078e64b5d149acb8192b52707870e1`
- Thiết bị: MOBILE. Font: Space Mono (headline/LCD), Inter (body)
- Lưu ý: `edit_screens` tạo màn hình **mới** thay vì ghi đè; `list_screens` và `screenInstances` không liệt kê các màn mới, nên lấy theo ID dưới đây.

## Bản dùng để triển khai (cập nhật 2026-10-27)

| Màn hình | Screen ID | File ảnh | Đánh giá |
|----------|-----------|----------|----------|
| App Icon | `034298e70f944f708e9ad8b71c3e3c0c` | `app-icon.png` | Cần bản vuông (xem dưới) |
| 1. Home | `6fbd696592ec4bdf9d55ffdf6108059a` | `home-v2.png` | Đạt |
| 2. Game Detail | `b6ca5491ca584a3cac466b2804146127` | `game-detail-v3.png` | Đạt, còn lỗi dấu ở 2 tiêu đề |
| 3. Game Screen (Ready) | `0c5eba096eb844f39c60d51664f59ca1` | `game-screen.png` | Cần chỉnh |
| 4. Pause | `01fd187f1a3a48cfb82b915adc704016` | `pause.png` | Đạt, lỗi dấu trong LCD |
| 5. Game Over (biến thể A) | `b2468a57a439450d92e7b361f65f3e2f` | `game-over-v2.png` | Đạt, lỗi dấu trong LCD |
| 6. Settings | `a11280e8dcfb4fa48eddd84a1ed074ac` | `settings-v2.png` | Đạt |

Các bản cũ (`home.png`, `game-detail.png`, `game-detail-v2.png`, `game-over.png`, `settings.png`) và ID `5c16ad…`, `290ef6…`, `0a04f5…`, `03b231…`, `84b417…` là bản lệch SPEC, **không dùng**. Giữ lại để so sánh.

HTML lấy bằng `download_file` với tên file HTML của màn (lấy từ `get_screen`) khi vào Phase 4. HTML dùng Tailwind CDN, chỉ làm tham chiếu; app là Flutter.

## Việc cần sửa trước khi duyệt cuối

1. **Dấu tiếng Việt trong font pixel (lỗi lặp lại ở nhiều màn)**: font pixel của Stitch (Press Start 2P) không có glyph tiếng Việt, nên dấu bị vỡ ở "LUẬT CHƠI", "ĐIỀU KHIỂN" (Game Detail v3, lần sửa không có hiệu lực), "TẠM DỪNG", "TIẾP TỤC", "CHƠI LẠI" (Pause) và "KỶ LỤC MỚI", "ĐIỂM SỐ" (Game Over). Trong Flutter dùng **Space Mono** (có hỗ trợ tiếng Việt) cho chữ trong LCD và tiêu đề, không dùng Press Start 2P. Cần kiểm tra thực tế khi code, không dựa vào ảnh Stitch.
2. **Game Screen**: LCD trống, không có rắn và táo (chỉ lưới); có nhãn "DOT MATRIX DISPLAY" và "READY STATE" không có trong spec; khoảng trống lớn giữa LCD và nút; nút Pause dùng biểu tượng khác bản Pause. Cần sinh/ sửa: có rắn 3 đốt + táo, trạng thái Playing, bỏ nhãn thừa.
3. **Pause**: toggle Âm thanh đang chọn, Rung đang bỏ chọn (chỉ là ví dụ); cần quyết định hiển thị trạng thái thật theo cài đặt.
4. **Game Over**: mới có biến thể A (kỷ lục mới). Biến thể B và C chỉ có dòng chú thích; cần màn riêng nếu muốn duyệt hình. Dòng "STN-PORTRAIT / READY" trong LCD là chữ bịa, bỏ. Dòng chú thích biến thể dưới máy là ghi chú, không phải UI.
5. **App Icon**: ảnh bo góc, hơi giống Game Boy; cần bản vuông 1024 và foreground nền trong suốt cho Android.
6. Nút A/B trên Game Over có nền "thanh" nối giữa hai nút (kiểu SNES), khác Game Screen; thống nhất kiểu.

## Quyết định thiết kế đã chốt
- Game Over: **A = Chơi lại, B = Về menu** (đã duyệt, đã ghi vào SPEC).
- Máy chỉ có D-pad + A/B (không Select/Start, không pin).
