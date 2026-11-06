# SPEC — Nền tảng NostalPlay + game Snake (Tuần 1–2)

Nguồn: [idea.md](../idea.md), [development-plan.md](../development-plan.md).

## 1. Mục tiêu & bối cảnh

Xây nền tảng dùng chung (vỏ máy retro, bộ nút A/B + D-pad, vòng đời game, lưu điểm, âm thanh) và game đầu tiên **Snake** để kiểm chứng kiến trúc trước khi làm 4 game còn lại của V1.0.

Kết quả: app Flutter chạy iOS + Android, có Home → Game Detail → Game Screen → Game Over, chơi trọn ván Snake, kỷ lục còn sau khi tắt app. Chưa gồm tracking/khảo sát (tuần 6), Settings đầy đủ (tuần 6).

## 2. Người dùng & user stories

Người dùng: người chơi phổ thông, thích cảm giác máy game điện tử cổ, chơi một tay hoặc hai tay trên điện thoại, portrait.

- US-1: Là người chơi, tôi mở app và thấy danh sách game để chọn chơi ngay.
- US-2: Tôi xem luật và cách điều khiển trước khi chơi.
- US-3: Tôi điều khiển rắn bằng D-pad ảo, có thể nhấn nhanh hoặc giữ.
- US-4: Tôi tạm dừng, tiếp tục, chơi lại; ván tự dừng khi tôi chuyển sang app khác.
- US-5: Tôi thấy điểm hiện tại, kỷ lục, và biết khi phá kỷ lục.
- US-6: Tôi bật/tắt âm thanh và rung.

## 3. Phạm vi

**In scope**
- Khung app, theme LCD, vỏ máy retro, bộ nút ảo.
- Các màn hình: Home, Game Detail, Game Screen (+ lớp Pause), Game Over, Settings tối thiểu (âm thanh, rung).
- Snake hoàn chỉnh.
- Lưu cục bộ: kỷ lục theo game, cài đặt âm thanh/rung.
- Registry game để thêm game không sửa lõi.
- CI: analyze + test. Unit test luật Snake.

**Out of scope (làm sau)**
- Brick Breaker, Space Shooter, Block Puzzle, Racing (tuần 3–5).
- Tracking, khảo sát, màn đồng ý quyền riêng tư (tuần 6).
- Chủ đề máy, tốc độ game trong Settings; game chơi gần đây; thành tích.
- Landscape, tablet tối ưu riêng, đa ngôn ngữ (chỉ tiếng Việt ở bước này, chuỗi tách khỏi code để dịch sau).
- Backend, tài khoản, tải/gỡ game.

## 4. Yêu cầu chức năng

### Nền tảng
- **FR-1**: Home hiển thị danh sách game từ registry (tên, ảnh/biểu tượng pixel, kỷ lục "Best: N" hoặc "New game"). Ở bước này chỉ Snake có thể chơi; các game dự kiến không hiển thị (không có mục "Coming soon" trừ khi design yêu cầu).
- **FR-2**: Chọn game → Game Detail: tên, mô tả luật, bảng điều khiển (D-pad/A/B làm gì), kỷ lục, nút Play.
- **FR-3**: Game Screen có "màn hình LCD" chứa game, hàng thông tin (điểm, kỷ lục, mạng/cấp nếu có), nút Pause, và bộ điều khiển ảo gồm D-pad 4 hướng + A + B.
- **FR-4**: Input phát sự kiện `onActionDown/onActionUp` cho `GameAction {up, down, left, right, buttonA, buttonB}`. Hỗ trợ nhấn nhanh, giữ, và đa chạm (ví dụ giữ hướng + nhấn A) theo pointer-id; không nhận nhầm khi trượt ngón giữa các nút.
- **FR-5**: Phản hồi nút: hiệu ứng nhấn trực quan; rung nhẹ nếu bật; không trễ cảm nhận được.
- **FR-6**: `GameSession` quản lý trạng thái `ready → playing ↔ paused → gameOver`. Từ `gameOver` có thể chơi lại hoặc về menu.
- **FR-7**: Pause: nút Pause và nút hệ thống Back mở lớp Pause với Resume / Restart / Quit to menu (và bật/tắt âm thanh, rung). D-pad lên/xuống di chuyển con trỏ, A chọn mục; B không dùng trong menu; chỉ mục đang chọn hiện gợi ý [A]. Khi app vào nền hoặc mất focus, tự chuyển `paused`; khi quay lại không tự chạy tiếp.
- **FR-8**: Game Over: hiển thị điểm, kỷ lục, thông báo "Kỷ lục mới" nếu phá kỷ lục; nút Chơi lại và Về menu. D-pad lên/xuống chọn Chơi lại / Về menu, A xác nhận mục đang chọn (mặc định Chơi lại); B không dùng; chỉ mục đang chọn hiện gợi ý [A] (cập nhật theo yêu cầu 2026-11-06, thay quyết định cũ A = Chơi lại, B = Về menu).
- **FR-9**: Lưu kỷ lục theo game ngay khi kết thúc ván (và khi thoát khi đang chơi nếu điểm hiện tại cao hơn kỷ lục). Dữ liệu còn sau khi tắt app.
- **FR-10**: Settings: bật/tắt âm thanh, bật/tắt rung; lưu cục bộ, áp dụng ngay.
- **FR-11**: Registry game: mỗi game là một `GameDefinition` (id, tên, mô tả, hướng dẫn điều khiển, builder). Thêm game = thêm thư mục + một dòng vào danh sách.
- **FR-12**: Âm thanh retro: bíp khi ăn mồi, khi chuyển hướng (tuỳ chọn), tiếng game over, tiếng phá kỷ lục. Tắt hoàn toàn khi tắt âm thanh.

### Snake
- **FR-13**: Lưới cố định (đề xuất 16 × 16 ô; chốt lại sau khi có design). Rắn ban đầu dài 3 ô, hướng phải, ở giữa lưới.
- **FR-14**: D-pad đổi hướng; không cho quay đầu 180° trực tiếp. Nếu người chơi nhấn nhiều hướng trong 1 tick, giữ tối đa 1 hướng chờ (buffer) để thao tác nhanh không bị nuốt.
- **FR-15**: Rắn tiến mỗi tick. Tick ban đầu 200 ms, giảm dần theo điểm (mỗi 5 mồi, giảm 10 ms) tới tối thiểu 80 ms (đề xuất, chỉnh khi playtest).
- **FR-16**: Mồi xuất hiện ngẫu nhiên ở ô trống. Ăn mồi: +10 điểm, rắn dài thêm 1 ô.
- **FR-17**: Va vào tường hoặc thân thì game over (không xuyên tường). Nếu rắn lấp đầy lưới thì thắng (game over kiểu "hoàn hảo").
- **FR-18**: Nút A giữ để tăng tốc tạm thời (×2) trong lúc giữ; B không dùng (ghi rõ trong hướng dẫn). *Giả định, xem §9.*
- **FR-19**: Logic Snake viết bằng Dart thuần, nhận RNG có seed, không phụ thuộc Flutter/Flame, để test deterministic.

## 5. Yêu cầu phi chức năng

- **NFR-1** Nền tảng: iOS 14+ và Android 7.0+ (API 24), portrait. Phiên bản này chốt chính xác khi tạo project.
- **NFR-2** Hiệu năng: 60 fps ổn định trên máy tầm trung; Snake không giật khi giữ nút.
- **NFR-3** Độ trễ nút → đổi hướng thấy được trong tick kế tiếp (tick ≤ 200 ms).
- **NFR-4** Responsive: iPhone SE (nhỏ) tới điện thoại lớn; vỏ máy co giãn theo chiều rộng, nút đủ lớn (≥ 44 pt) và không chồng nhau.
- **NFR-5** Game chơi hoàn toàn ngoại tuyến; không xin quyền hệ thống nguy hiểm. Ngoại lệ (2026-11-06): thêm quảng cáo AdMob banner ở Home (cần mạng và quyền INTERNET; tự rỗng khi offline, không ảnh hưởng game). Đang dùng ID test của Google; cần thay ID thật và làm form đồng ý (UMP) trước khi phát hành.
- **NFR-6** Dung lượng: asset game nằm trong `assets/games/<id>/`; ghi nhận kích thước build mỗi lần (xem development-plan §5.1).
- **NFR-7** Chất lượng: `flutter analyze` sạch; unit test logic Snake; widget test cho điều hướng cơ bản; CI chạy hai việc này.
- **NFR-8** Bản quyền: chỉ asset/âm thanh tự làm hoặc CC0, ghi nguồn trong `assets/CREDITS.md`.
- **NFR-9** Khả năng mở rộng: thêm game không sửa `core/`; key lưu trữ có prefix phiên bản (ví dụ `v1:snake:best`).
- **NFR-10** Khả năng tiếp cận tối thiểu: có nhãn ngữ nghĩa cho nút; tương phản đủ trên LCD; rung/âm thanh tắt được.

## 6. Màn hình & luồng điều hướng

Luồng: **Home → Game Detail → Game Screen → (Pause overlay | Game Over)**; Home → Settings.

| Màn hình | Nội dung chính | Trạng thái cần thiết kế |
|----------|----------------|--------------------------|
| Home | Tiêu đề "NostalPlay", danh sách game (thẻ: biểu tượng, tên, Best), nút Settings | 1 game; chưa có kỷ lục ("New game"); danh sách dài (cuộn) |
| Game Detail | Tên, ảnh, luật, bảng điều khiển, Best, nút Play, Back | Chưa có kỷ lục |
| Game Screen | Vỏ máy retro, LCD, hàng điểm/kỷ lục, nút Pause, D-pad, A, B | Ready ("Press A to start"), playing, tăng tốc |
| Pause overlay | Resume, Restart, Quit | — |
| Game Over | Điểm, Best, badge "Kỷ lục mới", Chơi lại, Về menu | Có / không phá kỷ lục; thắng hoàn hảo |
| Settings | Toggle âm thanh, toggle rung, phiên bản app | — |

Điều hướng: Back hệ thống ở Game Screen = Pause; ở Pause = Resume; ở các màn khác = lùi một bước.

## 7. Dữ liệu & mô hình

Lưu bằng `shared_preferences`:

| Key | Kiểu | Ý nghĩa |
|-----|------|---------|
| `v1:settings:sound` | bool (mặc định true) | Âm thanh |
| `v1:settings:haptics` | bool (mặc định true) | Rung |
| `v1:<gameId>:best` | int (mặc định 0) | Kỷ lục |

Mô hình chính: `GameAction` (enum), `GameDefinition`, `GameSession` (state: ready/playing/paused/gameOver, score, best), `SnakeState` (lưới, thân rắn, hướng, mồi, điểm, trạng thái).

## 8. Tiêu chí nghiệm thu

**Nền tảng**
- [ ] App build và chạy trên iOS simulator và Android emulator.
- [ ] Home → Detail → Game → Game Over → Home hoạt động, Back hệ thống đúng như §6.
- [ ] Bộ nút: nhấn nhanh, giữ, giữ + nhấn nút khác đều đúng; trượt ngón không kích nhầm nút khác (FR-4).
- [ ] Pause/Resume/Restart/Quit đúng; vào nền tự pause, quay lại vẫn paused (FR-7).
- [ ] Kỷ lục lưu và còn sau khi tắt hẳn app (FR-9).
- [ ] Toggle âm thanh/rung có hiệu lực ngay và còn sau khi mở lại app (FR-10, FR-12).
- [ ] Hiển thị ổn trên iPhone SE và màn hình lớn, không tràn/chồng nút (NFR-4).
- [ ] Thêm một game giả vào registry không cần sửa `core/` (FR-11, NFR-9).
- [ ] CI xanh: `flutter analyze` + `flutter test`.

**Snake**
- [ ] Rắn ban đầu, hướng, tick đúng FR-13/15.
- [ ] Không quay đầu 180°; nhấn hai hướng liên tiếp trong 1 tick xử lý đúng bằng buffer (FR-14).
- [ ] Ăn mồi +10, dài thêm 1, mồi không sinh trên thân rắn (FR-16).
- [ ] Va tường/thân → game over; lấp đầy lưới → thắng (FR-17).
- [ ] Tăng tốc theo điểm đúng ngưỡng; giữ A tăng tốc, thả A về bình thường (FR-15, FR-18).
- [ ] Unit test (RNG có seed) cover: di chuyển, đổi hướng hợp lệ/không hợp lệ, ăn mồi, va chạm, sinh mồi, thắng, tăng tốc (FR-19).
- [ ] Chơi liên tục 10 phút không crash, không tụt fps rõ rệt.

## 9. Giả định & câu hỏi mở

**Giả định (tự chọn mặc định, báo lại nếu muốn đổi)**
1. Nền tảng tối thiểu iOS 14 / Android API 24; chốt khi tạo project theo phiên bản Flutter hiện hành.
2. Snake tự vẽ bằng Flutter `CustomPainter` (lưới đơn giản, không cần Flame); Flame vào ở Brick Breaker/Shooter. Nền tảng vẫn cung cấp game loop dùng chung để các game Flame cắm vào sau.
3. Tick Snake và lưới 16×16 chỉ là điểm xuất phát, cần playtest.
4. Nút A = tăng tốc, B không dùng trong Snake.
5. Tiếng Việt trước, chuỗi đặt trong một file để dịch sau.
6. Âm thanh/hình ảnh tự tạo hoặc CC0; tạm dùng placeholder cho tới khi có asset thật.
7. Game Screen chưa có "Ready" riêng: nhấn A để bắt đầu ván (giống máy cũ).

**Đã chốt (user duyệt 2026-10-26)**
- Q1: A giữ để tăng tốc (ở Ready/Game Over, A = bắt đầu/chơi lại).
- Q2: Home chỉ hiện game đã có, không có "Sắp ra mắt".
- Q3: LCD xanh lá kiểu Game Boy.
