# Kế hoạch phát triển — 4 Nút (NostalPlay)

Dựa trên [idea.md](idea.md). Tài liệu này chốt thứ tự làm, phạm vi từng mốc, tiêu chí xong và các điểm cần quyết định. Repo hiện đang trống (chưa có code Flutter).

## 0. Điểm cần chốt trước khi code

| # | Vấn đề | Đề xuất mặc định |
|---|--------|------------------|
| 1 | `idea.md` mâu thuẫn danh sách game V1.1–V1.6: phần tổng quan ghi Pac-Man/Breakout Challenge/Frogger/Space Invaders/Tetris Sprint/Tank/Dungeon, phần chi tiết ghi Sky Hop/Minesweeper/Road Hopper/Number Merge/Maze Chase/Whack-a-Mole/Tank Battle/Sky Climber/Simon/Pinball | Dùng **phần chi tiết** (9–17), vì có mô tả và ước tính. Tổng cuối là 17 game, nhưng V1.1 → V1.6 chỉ thêm 12 game (5 + 12 = 17) ✔ |
| 2 | "4 nút" nhưng điều khiển có D-pad 4 hướng + A + B (6 action) | **Đã chốt**: giữ D-pad + A/B, vì app mô phỏng máy 4 nút và triển khai các game trên máy đó |
| 3 | Tên | **Đã chốt**: `NostalPlay`. Việc còn lại: kiểm tra trùng tên trên App Store/Google Play, icon, ảnh store |
| 4 | Lưu trữ | `shared_preferences` cho MVP (điểm, cài đặt). Number Merge cần lưu ván → dùng JSON trong prefs, không cần Isar |
| 4 | Tracking + khảo sát | **Đã chốt**: có trong V1.0 (xem §2.1). Cần Firebase Analytics (hoặc tương đương), màn đồng ý, chính sách quyền riêng tư |
| 5 | Flame cho mọi game? | Không. Luật chơi viết Dart thuần (test được); render bằng Flame cho game real-time, `CustomPainter` cho game lưới |
| 6 | Platform | iOS + Android, portrait trước |
| 7 | Âm thanh/pixel art | Tự làm hoặc asset CC0 có ghi nguồn — theo dõi trong `assets/CREDITS.md` |

## 1. Nguyên tắc kiến trúc (làm đúng ngay từ đầu)

- **Đơn giản hóa**: điều hướng dùng `Navigator` + `onGenerateRoute` (bỏ `go_router`, app chỉ ~5 màn hình); state dùng `ChangeNotifier`/`ValueNotifier` + `InheritedWidget` hoặc `provider` (bỏ Riverpod). Chỉ thêm thư viện khi thật sự thiếu.
- **Game registry**: mỗi game là một `GameDefinition` (id, tên, mô tả, hướng dẫn điều khiển, builder), khai báo trong một `const List<GameDefinition>`. Thêm game = thêm thư mục `games/x/` + 1 dòng vào list. Chỉ trừu tượng hóa thêm khi có game thứ 3 cho thấy cần.
- **Cấu trúc thư mục gọn**: `lib/{app, core, games}`, bỏ tầng `features/`; Home/Detail/Settings nằm trong `app/screens/`.
- **Tách logic khỏi render**: `games/snake/snake_logic.dart` (thuần Dart, tick theo `dt`, có seed RNG để test deterministic) và `snake_game.dart` (Flame/Painter).
- **Input chung**: `GameInput` phát `onActionDown/Up`; hỗ trợ đa chạm theo pointer-id, key-repeat có cấu hình, buffer 1 hướng cho Snake/Block Puzzle.
- **GameSession**: quản lý Playing/Paused/GameOver, lifecycle (app vào nền → tự pause), điểm, kỷ lục, âm thanh.
- **Versioning dữ liệu**: key lưu trữ có prefix `v1:` và tên game; game mới không đụng key cũ (đáp ứng "không mất kỷ lục khi cập nhật").

## 2. Lộ trình

### Giai đoạn A — MVP V1.0 (≈ 6 tuần, 1 dev)

| Tuần | Nội dung | Tiêu chí xong |
|------|----------|---------------|
| 1 | Flutter project, lint, CI (analyze + test), theme LCD, Home / Game Detail / Game Screen, `GameInput` + bộ nút ảo, game loop Flame mẫu | Chạy iOS + Android, điều hướng được, nút bấm giữ/nhả đúng |
| 2 | **Snake** + `GameSession`, Pause/Restart/Game Over, lưu kỷ lục, âm thanh, lifecycle, unit test luật | Chơi trọn ván, kỷ lục còn sau khi tắt app |
| 3 | **Brick Breaker** | Dùng lại hạ tầng, không sửa lõi ngoài ý muốn |
| 4 | **Space Shooter** (spawn, đạn, độ khó tăng dần, object pooling) | 60 fps trên máy cấu hình thấp |
| 5 | **Block Puzzle** + **Racing** | Đủ 5 game |
| 6 | Settings (âm thanh/rung/chủ đề/tốc độ), tracking + khảo sát + màn đồng ý (§2.1), QA đa kích thước màn hình, đa chạm, background/foreground, TestFlight + Android internal testing, tài liệu build/release | Checklist 12 mục ở §7 của idea.md đạt; có dữ liệu tracking từ beta |

### 2.1 Tracking và khảo sát (làm trong tuần 6, cổng quyết định)

- **Sự kiện** (ẩn danh, không thu dữ liệu cá nhân): `app_open`, `game_start`, `game_over` (game, điểm, thời lượng), `game_quit`, `retry`, `settings_change`, `crash` (Crashlytics). Dùng lớp `Analytics` mỏng để đổi nhà cung cấp sau này.
- **Khảo sát trong app**: hiện sau ván thứ 3 hoặc ngày chơi thứ 2, tối đa 1 lần, có nút bỏ qua. 3 câu: mức độ vui (1–5), game thích nhất, game muốn có thêm (chọn từ danh sách V1.1+ hoặc nhập tự do). Gửi qua event hoặc form liên kết.
- **Quyền riêng tư**: màn đồng ý lần đầu (có thể từ chối), chính sách quyền riêng tư, khai báo dữ liệu trên App Store/Play. Đây là ngoại lệ có chủ đích với nguyên tắc "không backend" ở MVP: chỉ dùng dịch vụ analytics, không có tài khoản.
- **Cổng "nếu ổn thì phát triển tiếp"** (ngưỡng đề xuất, chỉnh theo thực tế): sau 2–4 tuần beta với ≥ 30 người thử: điểm vui trung bình ≥ 3,8/5; ≥ 40% quay lại ngày 2; phiên chơi trung bình ≥ 5 phút; crash-free ≥ 99%. Đạt → làm V1.1 theo kết quả khảo sát (có thể đổi thứ tự game); không đạt → chỉnh gameplay/điều khiển trước khi thêm game.

**Thứ tự rủi ro**: Snake trước để kiểm chứng kiến trúc; nếu interface `MiniGame`/`GameInput` sai thì sửa ở tuần 2–3 khi chi phí còn thấp. Đặt *kiểm tra checkpoint cuối tuần 2* trước khi làm tiếp.

### Giai đoạn B — Mỗi version thêm 2 game

Chỉ bắt đầu sau khi qua cổng ở §2.1. Thứ tự các version là dự kiến, điều chỉnh theo khảo sát người chơi. Ưu tiên cam kết V1.1–V1.2; từ V1.3 chọn lại theo dữ liệu.

| Version | Game | Lõi cần nâng | Ngày công |
|---------|------|--------------|-----------|
| V1.1 | Pong, Memory Match | Menu/điểm hoàn thiện, AI đối thủ đơn giản, chế độ chọn ô bằng D-pad | 4–6 |
| V1.2 | Sky Hop, Minesweeper | Nút A giữ/nhấn, "xác nhận ô" + cờ (B) | 6–8 |
| V1.3 | Road Hopper, Number Merge | Lưu/khôi phục ván giữa chừng, hệ cấp độ, vuốt → action | 7–9 |
| V1.4 | Dot Muncher (tên gốc Maze Chase; không dùng tên/hình Pac-Man), Whack-a-Mole | Pathfinding/AI, bản đồ từ file, thử thách tính giờ + combo | 7–10 |
| V1.5 | Tank Battle, Sky Climber | Kẻ địch AI, vật lý nhảy, tái dùng component | 9–12 |
| V1.6 | Simon Says, Mini Pinball | Vật lý (cân nhắc Forge2D), bảng kỷ lục, hiệu ứng/âm thanh | 7–10 |

Cộng 20–30% cho QA/sửa lỗi. Mỗi version dùng Definition of Done ở §3. Pinball và Tank là rủi ro cao nhất → làm prototype sớm (spike 1 ngày) trước khi cam kết lịch.

### Giai đoạn C — Sau V1.6 (chỉ làm khi gameplay giữ chân được người chơi)

Thành tích, thử thách hằng ngày, nhiều skin máy, bảng xếp hạng online, quảng cáo/IAP. Chỉ thêm backend khi có nhu cầu thật.

## 3. Definition of Done mỗi version

- 2 game mới chơi trọn vẹn, có hướng dẫn điều khiển.
- Unit test luật chơi; widget test cho menu; 1 integration test chơi → game over → kỷ lục.
- Regression game cũ; dữ liệu cũ nguyên vẹn (test migration nếu có đổi schema).
- Pause/resume, vào nền, đa chạm; kiểm tra trên 1 máy yếu.
- Tăng version, build QA, release notes.

## 4. Rủi ro và cách giảm

| Rủi ro | Cách giảm |
|--------|-----------|
| Độ trễ nút ảo trên cảm ứng | Dùng `Listener` (pointer events) thay vì `GestureDetector`; đo thử từ tuần 1 |
| Phình scope MVP | Cố định 5 game; mọi ý tưởng thêm vào backlog V1.x |
| Asset/âm thanh vi phạm bản quyền | Tự làm hoặc CC0; ghi nguồn; tránh tên/hình thương mại (Pac-Man, Tetris…) trong tên game, mô tả và store (dùng "Dot Muncher", "Block Puzzle"…) |
| Tracking vi phạm quy định quyền riêng tư | Ẩn danh, màn đồng ý, chính sách riêng tư, khai báo đúng trên store |
| Hiệu năng Shooter/Pinball | Object pooling, profile sớm bằng DevTools |
| Lệch phiên bản thư viện | Chốt version trong tuần 1, commit `pubspec.lock` |
| Một dev vừa học Flutter | Dùng khung 8–12 tuần cho MVP |

## 5. Việc đầu tiên (Tuần 1, theo thứ tự)

1. `flutter create`, bật `flutter_lints`, cấu trúc thư mục gọn `lib/{app,core,games}`.
2. CI GitHub Actions: `flutter analyze` + `flutter test`.
3. Theme LCD + vỏ máy retro (widget `ConsoleShell`), bộ nút ảo.
4. `GameAction`, `GameInput`, `MiniGame`, `GameRegistry`, `GameSession` (khung).
5. Home → Detail → Game (game "demo" một chấm di chuyển) để kiểm tra input + lifecycle.
6. Sau đó vào Snake.

## 5.1 Dung lượng và tải/gỡ game

- Chưa làm tải/gỡ game trong MVP–V1.2. iOS không cho tải code chạy được, nên nếu cần chỉ tải được asset (Play Asset Delivery / On-Demand Resources).
- Quy ước: asset mỗi game nằm trong `assets/games/<id>/` và game tự khai báo asset của nó, để sau này tách gói dễ.
- Theo dõi dung lượng app mỗi build; cảnh báo khi vượt ~100 MB. Chỉ làm tải/gỡ khi vượt ngưỡng hoặc khảo sát cho thấy cần (backlog sau V1.6).
- Có thể làm sớm: ẩn game, xóa dữ liệu game (điểm, ván lưu).

## 6. Cách tiếp tục

Repo có skill `spec-design-build` (spec → thiết kế Stitch → code). Đề xuất: viết spec chi tiết cho **nền tảng + Snake** trước, duyệt, rồi mới tạo thiết kế UI và code.
