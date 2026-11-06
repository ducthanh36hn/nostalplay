# QA — Nền tảng + Snake (bước 8, 2026-11-06)

Môi trường: iPhone SE (2nd gen) simulator iOS 18.6 (bước 6), Pixel 9 emulator Android 16 (RAM 2 GB, 1080×2424), Flutter 3.35.4.
Không có thiết bị thật.

## Kết quả đối chiếu SPEC §8

Ký hiệu: ✅ đã kiểm chứng · 🧪 chỉ có test tự động · ❓ chưa kiểm chứng

**Nền tảng**
- ✅ Build và chạy trên iOS simulator và Android emulator (Android cần JDK 21, xem "Phát hiện").
- ✅ Home → Detail → Game → Game Over trên Android; 🧪 Back hệ thống và toàn bộ luồng bằng widget test (`app_flow_test`).
- 🧪 Nhấn nhanh/giữ/đa chạm/trượt ngón (widget test `dpad`, `game_input`); ❓ chưa thử đa chạm bằng tay trên máy thật.
- ✅ Vào nền → tự Pause, quay lại vẫn Pause (Android); 🧪 Pause/Resume/Restart/Quit.
- 🧪 Kỷ lục lưu qua `AppStorage` (khởi tạo lại bộ nhớ); ❓ chưa thử tắt hẳn app rồi mở lại.
- 🧪 Toggle âm thanh/rung có hiệu lực ngay và lưu; ❓ chưa nghe/cảm nhận trên máy thật.
- ✅ Hiển thị ổn trên iPhone SE (bước 6) và Pixel 9; 🧪 test 320 px. Lỗi layout màn cao đã sửa (mục 2).
- 🧪 Game giả trong registry (`fake_game`) chạy không sửa `core/`.
- ❓ CI chưa chạy (chưa push). Cục bộ: `dart analyze` sạch, 75 test qua.

**Snake**
- 🧪 Tất cả mục logic (khởi tạo, tick, 180°, buffer, ăn mồi, mồi không trên thân, va chạm, thắng, tăng tốc, giữ A) có unit test với RNG có seed.
- ❓ Chơi liên tục 10 phút, fps: chưa làm (emulator thiếu RAM, không đo được fps đáng tin).

## Phát hiện
1. **Android build lỗi với JDK 25** (JBR của Android Studio): Gradle 8.12 không chạy. Cách chạy: `GRADLE_OPTS="-Dorg.gradle.java.home=$(/usr/libexec/java_home -v 21)" flutter build apk --debug`, hoặc `flutter config --jdk-dir <JDK 21>`. Nên nâng Gradle/AGP lên bản hỗ trợ JDK 25 hoặc ghi vào README.
2. **Màn cao (20:9, Pixel 9)**: vỏ máy có khoảng trống ~20% dưới bộ nút. **Đã sửa**: chiều cao dư chia đều quanh bộ nút (`ConsoleShell`); có test `console_shell_layout_test` (412×915 và 320×568 / 375×667 / 390×844 không tràn). Chưa nhìn lại bằng mắt trên emulator vì emulator hết RAM.
3. **Splash Android**: nền trắng. **Đã sửa**: nền `#1E2420` (đã thấy trên emulator, Android 12+ qua `values-v31`; Android cũ hơn chưa thử).
4. Emulator 2 GB RAM bị hệ điều hành kill app một lần (lowmemorykiller), không phải lỗi app.
5. Lỗi tap đầu tiên bị mất trên iOS simulator (từ bước 4) không tái hiện trên Android; vẫn cần máy thật.

## Còn mở
Máy thật (độ trễ nút, âm thanh, rung, fps, đa chạm), 10 phút liên tục, tắt hẳn app kiểm tra kỷ lục, CI sau khi push, Game Over biến thể B/C.
