# PLAN — Phase 4: Khởi tạo Flutter + nền tảng + Snake

Môi trường: Flutter 3.35.4 (stable), Xcode 26, Android SDK 35 (còn thiếu chấp nhận license), có Chrome. Repo chưa có code Flutter.

## Quyết định kỹ thuật

- **Tên/ID**: package `nostalplay`, bundle/app id `com.nostalplay.app` (chốt lại trước khi phát hành). Tên hiển thị "NostalPlay".
- **Cấu trúc**: `lib/{app,core,games}`; không dùng go_router/Riverpod (đã chốt trong kế hoạch).
- **Thư viện**: `shared_preferences`, `provider` (hoặc `ChangeNotifier` thuần), `flutter_lints`. Âm thanh: `audioplayers` (hoặc `flame_audio` khi vào Flame, tuần 3). Rung: `HapticFeedback` của Flutter, không thêm thư viện.
- **Font**: đóng gói **Space Mono** (Regular, Bold) và **Inter** vào `assets/fonts/` (không tải qua mạng, app chạy offline), kiểm tra dấu tiếng Việt thật bằng test hình ảnh. Không dùng Press Start 2P.
- **Render Snake**: `CustomPainter` trên lưới 16×16, logic thuần Dart.
- **Design tokens** lấy từ design system Stitch: màu LCD (`#0F380F #306230 #8BAC0F #9BBC0F`), vỏ máy (`#C9C6BA #8E8B80 #2B2B2B #9B2335`), nền app `#1E2420`, thẻ `#2B332D`, viền `#3D483F`.

## Cấu trúc thư mục

```
lib/
├── main.dart
├── app/
│   ├── app.dart            # MaterialApp, theme, route
│   ├── theme.dart          # tokens màu, chữ
│   └── screens/            # home, game_detail, game_screen, settings
├── core/
│   ├── game_action.dart    # enum GameAction
│   ├── game_input.dart     # pointer-id đa chạm, giữ/nhả
│   ├── game_session.dart   # ready/playing/paused/gameOver
│   ├── game_definition.dart + registry
│   ├── storage/            # best score, settings (key v1:)
│   ├── audio/ haptics/
│   └── widgets/            # ConsoleShell, DPad, ActionButton, LcdFrame, LcdDialog
└── games/snake/
    ├── snake_logic.dart    # thuần Dart, RNG có seed
    ├── snake_painter.dart
    └── snake_game.dart     # định nghĩa game + widget
assets/{fonts,audio,games/snake}
test/                       # unit snake_logic, widget điều hướng/input
```

## Các bước (mỗi bước có thể chạy và kiểm tra)

1. **Khởi tạo**: `flutter create` (iOS + Android), bật lint, thêm font, thư viện; CI GitHub Actions (`flutter analyze` + `flutter test`); `.gitignore`. Commit đầu.
2. **Theme + widget dùng chung**: tokens, `ConsoleShell` (vỏ máy), `LcdFrame`, `DPad`, `ActionButton` (A/B, trạng thái nhấn), `LcdDialog`. Có màn demo để so với ảnh Stitch.
3. **Core**: `GameAction`, `GameInput` (đa chạm theo pointer-id, không kích nhầm khi trượt ngón), `GameSession`, `GameDefinition` + registry, storage (kỷ lục, âm thanh/rung), lifecycle (vào nền → pause).
4. **Màn hình**: Home → Game Detail → Game Screen (Ready/Playing, Pause overlay, Game Over) → Settings; điều hướng và Back đúng SPEC §6.
5. **Snake**: logic (tick, đổi hướng + buffer, ăn mồi, va chạm, thắng, tăng tốc, giữ A ×2), painter, nối vào session; unit test với seed.
6. **Âm thanh + rung**: bíp ăn mồi, game over, phá kỷ lục (tạo asset 8-bit tự làm hoặc CC0, ghi `assets/CREDITS.md`).
7. **Icon app**: từ `design/app-icon.png` (cần bản vuông, xem dưới), tạo iOS/Android adaptive icon.
8. **QA**: chạy trên iPhone SE/lớn và Android emulator, kiểm tra 320 px, đa chạm, 10 phút chơi liên tục; đối chiếu từng FR/tiêu chí nghiệm thu; báo cáo cái nào đạt/chưa kiểm chứng.

## Cách đối chiếu design
- Ảnh `design/*.png` là chuẩn bố cục; HTML Stitch chỉ lấy token/kích thước (tải bằng ID trong `design/STITCH.md`).
- Chỗ mâu thuẫn spec thì theo SPEC và ghi lại. Các điểm đã biết: Game Screen thiếu rắn/táo trong ảnh (theo SPEC, vẽ bằng code); không có Select/Start/pin; dấu tiếng Việt dùng Space Mono.

## Rủi ro và việc cần bạn
- **Android license chưa chấp nhận**: cần chạy `flutter doctor --android-licenses` (tương tác, mình không chạy hộ được) trước khi build Android.
- **Icon**: ảnh Stitch đã bo góc; cần bản vuông 1024 không trong suốt. Có thể cắt bỏ góc bo tạm thời hoặc sinh lại icon.
- **Bundle ID**: cần chốt tên cuối trước khi phát hành (đổi sau tốn công).
- Chưa có thiết bị thật trong danh sách (iPhone/iPad không kết nối được); sẽ kiểm tra bằng simulator/emulator, và nên thử trên máy thật ở bước QA.
- Độ trễ nút ảo: đo thử sớm ở bước 3 (dùng `Listener`).

## Ngoài phạm vi (làm sau)
Brick Breaker và các game khác, Flame, tracking/khảo sát, chủ đề máy, tốc độ game trong Settings.
