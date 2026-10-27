# Kế hoạch xây dựng app game tổng hợp máy điện tử 4 nút bằng Flutter

Mình đề xuất xây dựng một ứng dụng mobile mô phỏng trải nghiệm của những máy chơi game điện tử 4 nút ngày xưa — kiểu máy có màn hình LCD, các nút điều hướng và vài trò chơi kinh điển như đua xe, bắn máy bay, rắn săn mồi, xếp gạch.

Mục tiêu là tạo một app có thể phát triển lâu dài, bổ sung game mới mà không phải viết lại kiến trúc, ưu tiên Flutter để chạy trên iOS và Android.

[Tutorial Hartung Game Master](https://images.openai.com/static-rsc-4/xpto4cIEr0gNKjeKgccz_SvEKk1IC1e4P2cMQV3FdGMannGwvTiA_PQ37clv6qV63JS45d3ZoxV--NjCuggu_NuyVLVpjDGYHUrFszzYJXz2pzLVmGUw-2gh2AewsC9p0XsR6amr0PrR4hZ2im4XJABWcbWMxF9Y2sUwaUoA9n8?purpose=inline)

[Matsushima Car Race Game & Time Handheld  – Retro MTL](https://images.openai.com/static-rsc-4/YuiB1W0MRFOLvldtY4QWYw9UhNC3IZp3POUOtiaGZEMEIUMnmrVrNkrYwlg7En-h9sXhJmQyvdMtL-RdhU-UKggX5Y23r2g60clnTVpJVpeROxp_alc8ptF0FD9VMZ95lk5oNRtFFZ6GUv7Gn2I3tNzOY14JuTbr8IMmg1MXAgo?purpose=inline)

[GUIDE: Working with videos (anim GIFs)](https://images.openai.com/static-rsc-4/nNLBl6KClze0brH-hh6caHlHpUh0xaOpa4re48pN_YlITC5rDUbweB-DrDNsgwbRyY_J1qMgijkF8-hAe6Sop85yvWQ-GmLfcAL-T_7VCXT3GXNSE9i4Peq0T0VD8vejp_AOGpzFEVmgLG9FiWEm05gV9dftF6ucB6IHJTlbSCI?purpose=inline)

8

## 1. Xác định sản phẩm

Tên dự án tạm thời: 4 Nút – Retro Mini Games

Một ứng dụng, nhiều trò chơi

Người dùng mở app, chọn game và chơi ngay, không cần tải từng trò riêng.

Tái hiện cảm giác máy game cổ

Giao diện pixel, màn hình giả lập LCD, nút A/B, phím điều hướng, âm thanh retro và điểm số cao nhất.

Dễ mở rộng

Mỗi game là một module độc lập, dùng chung hệ thống điều khiển, lưu điểm, âm thanh và menu.

### Phạm vi phiên bản đầu tiên (MVP)

Không nên làm 20–30 game ngay từ đầu. Mình khuyên bắt đầu với 5 game, hoàn thiện trải nghiệm chơi và kiến trúc trước khi mở rộng.

[Retro Snake Game in Pixel Art - Finished Projects - Blender Artists Community](https://images.openai.com/static-rsc-4/G3f7ced0IADYXDAfcmZWlXe6zgUv24Di8R0BJxLwgCZlKY3O9HMw0kL6f4li2RI0ofRvdsBhb-gu5550vRGynQh8TjnQ5jk07oFynosx9C4AeHi8UTYEJxmTmzH-pQUTBdVNBLQhcM0rS6TFzzeJh8YMoCchT4BmQEeLT--i6kk?purpose=inline)

1\. Rắn săn mồi (Snake)

Game đầu tiên

Di chuyển 4 hướng, ăn mồi, tăng độ dài, va chạm kết thúc game. Phù hợp để kiểm tra toàn bộ hệ thống input, vòng lặp game và lưu điểm.

[CIIECE 레트로 휴대용 미니 게임기 - 본체 | 쿠팡](https://images.openai.com/static-rsc-4/F10FnhNWLsLlfaAol4zXVRJaIJBpjcK-FZ_RIBh7RBYdwgVF17wFP49QdJG_0M5-mJcJ9PTDUig-SnnUMA5hEFFrVU8Up3LbBO5eNLp4JOjwRMH0gyNurEyZaThtaasMxV1Nu8iO_GT_QxiTIHUo_ltspgDlXnIPsWHG9oWFp0o?purpose=inline)

2\. Đập gạch (Brick Breaker)

Điều khiển thanh đỡ, bóng nảy, phá gạch, tính mạng và điểm số. Kiểm tra chuyển động liên tục và va chạm.

[Elektronika (Angstrem) - LCD Game & Watch Russe - Explorers of Space MG-13 (occasion)](https://images.openai.com/static-rsc-4/0aR6S8OKhvNTHAqQjaIaPm-XHrZlVrfdpb-1jLsdLpo2PwsV_L-B6k3G7_eU5pWBYxEXf8AYFumwarlKXBABIakeaqa1wF8P2cYId3NHNamGRaL5puX9HAbZ9xM2IIGTjp83evIQAOcqmrMFVhGOUbBMbvOeHEeBYN6JoHacvZI?purpose=inline)

3\. Bắn máy bay (Space Shooter)

Di chuyển, bắn đạn, né kẻ địch, tăng độ khó theo thời gian. Kiểm tra xử lý nhiều đối tượng trên màn hình.

[Portable Game Console Tetris Handheld Game Players LCD Screen Electron – V.I.P Digital Presence](https://images.openai.com/static-rsc-4/8z31cGIXQO14mOhbC5vQs-zqP-ySzQ4qstlMNT42ADRV93rYDUDEJcWfM4tpkJkDcioBLlPZmCbdjwto-qb_wP_E3O36HSIci-rAM-6L5gJSyaXdTxRF9Z31ITB9_rsRVIcuYvNyfEuEtt9rkSMXQDJB2_SFojvxjWovFyrk_0o?purpose=inline)

4\. Xếp gạch (Block Puzzle)

Di chuyển và xoay khối, xóa hàng, tăng cấp độ. Kiểm tra logic lưới và thao tác phím ngắn/dài.

[Yahoo!オークション - 【動作品】LSIゲーム チャンピオンレーサー ゲー...](https://images.openai.com/static-rsc-4/9Gdq979U-0UPqLNUCxr5qBeCXY0qXM4wLxrcXLUVTG2GGCZkp4DdK2LqQ0UD8A4_ovuzoUEMMX0uxcNvWOt0ijsGILRRfIKyWQGtO7pjpeY80aVnRqaPP3jCmQ1Hv70Tz93_VcnQKTDJwmBPpQ1B8-et6O1Mh-4q9PqZmBxGasM?purpose=inline)

5\. Đua xe né chướng ngại vật

Lái xe qua các làn, né vật cản, tăng tốc dần và lưu kỷ lục. Tạo cảm giác arcade cổ điển.

Lưu ý: đây là các game lấy cảm hứng từ thể loại điện tử cổ điển, không phải bản sao nguyên trạng của game thương mại có bản quyền. Ta có thể tự thiết kế đồ họa, âm thanh và luật chơi.

## 2. Thiết kế trải nghiệm người dùng

Luồng sử dụng nên đơn giản như máy điện tử ngày xưa: bật máy → chọn trò → nhấn Start → chơi.

## 4 NÚT

RETRO GAME SYSTEM

[Snake](https://images.openai.com/static-rsc-4/HDGLVwGJrllkZz3dMzuh339MnXYHv8akvrBA67q4-zmc1ABLZBK-ZQCBxtR-oWFeJzh4FHzhQv_ucVp_-8OXTt4j2dsRAHyVRjTP_vlJ03IKfV6Hkv3_yPjCkMe4oDtUIKhes0Bv1rtpCL3pfUb5rWWFbkqM9L56N5xQPVG8lLQ?purpose=inline)

SNAKE

Best: 1250

[pixel ufo spaceship](https://images.openai.com/static-rsc-4/yN-NC2p0eW-GCc69ZUp2dQDlToPFJV-4m1veLMCkWlaQhOaQHYVHrw-2mWZ3A5muPStIJFs_ZkHYaPlolnnJA_mY_PHMe8AKckuXLFGD6yoC2oiMD_D91KwOC_VrhQq7ZAma17v2FOXMBiU3hWdKi9kQ_kJmbKNB5wBLYbBFojBNEYZR1ckKK1Ht0FVp2Ri2?purpose=inline)

SPACE SHOOTER

New game

[Retro block breaker - Show - GameDev.tv](https://images.openai.com/static-rsc-4/vns0cGVvM5Yk9jaPioiSfe7aNfV-3g4muUalbpuj3QDa4WiS3JO3m-bvy7FIB3FjBCY4P6XNhtRZ-a_-eYz_lyP7ivPSKMDx-BOf0nzScheU3h8fvCjrLOKcmws5IQNlzWh8QnGP9_tvLgzbszSi1mW10VK4fDaPKewC1f9vqNU?purpose=inline)

BRICK BREAKER

Best: 890

[FC火箭车经典版nes下载-FC火箭车经典版下载-超能街机](https://images.openai.com/static-rsc-4/GMj2OIX-cbZ41ItRAqh7IIiJ_X7K462bYn79csJn4fwwSNdIYCFCMjDo7WAMfQq78awafLpbKVQts_ZiQURUUhKcP_PwOPsp_UeFLhaDrkx2Zc42rfLJGLZxtP-GwNprYHkEFGMgiAWbncLnsuR4ogN9ydcbC4Py6cnozRml01A?purpose=inline)

RACING

New game

SELECT GAME

### ↑

### ←

### ↓

### →

#### B

#### A

Bản phác thảo định hướng giao diện: màn hình chọn game theo phong cách LCD, có bộ điều khiển ảo. Có thể thay đổi theo thiết kế máy 4 nút bạn muốn tái hiện.

Các màn hình chính:

1. Home: danh sách trò chơi, game chơi gần đây, kỷ lục.
2. Game Detail: hướng dẫn luật chơi, cách điều khiển, nút Play.
3. Game Screen: khu vực game, phím điều khiển, Pause/Resume, Restart.
4. Game Over: điểm số, kỷ lục mới, chơi lại, về menu.
5. Settings: âm thanh, rung, chủ đề máy, tốc độ game.

Nên thiết kế theo hướng responsive, hỗ trợ màn hình điện thoại nhỏ và lớn, portrait trước; chỉ thêm landscape nếu một game thực sự cần.

## 3. Công nghệ và kiến trúc Flutter

Mình khuyên dùng Flutter + Flame cho phần game, thay vì cố xây dựng mọi thứ bằng widget Flutter thông thường.

Flutter Application

Navigation · Home · Settings · Game Library

Flame Engine

Game loop, sprite, collision, animation, rendering.

Shared Game Systems

Input, pause, score, audio, lifecycle.

Game Modules + Local Storage

Snake · Shooter · Racing · Puzzle · Brick Breaker

### Stack đề xuất

| Thành phần            | Công nghệ                               |
| --------------------- | --------------------------------------- |
| Mobile UI             | Flutter / Dart                          |
| Game engine           | Flame                                   |
| Quản lý trạng thái UI | Riverpod                                |
| Điều hướng            | go_router                               |
| Lưu điểm và cài đặt   | SharedPreferences hoặc Isar             |
| Âm thanh              | Flame Audio                             |
| Đồ họa                | Sprite sheet, pixel art tự thiết kế     |
| Kiểm thử              | flutter_test, integration_test          |
| CI/CD                 | GitHub Actions hoặc hệ thống CI hiện có |

Các thư viện cần được kiểm tra phiên bản tương thích tại thời điểm tạo dự án.

### Cấu trúc thư mục

```
lib/
├── app/
│   ├── app.dart
│   ├── router.dart
│   └── theme/
├── core/
│   ├── game_input/
│   ├── audio/
│   ├── storage/
│   ├── scoring/
│   └── widgets/
├── features/
│   ├── home/
│   ├── game_library/
│   ├── game_session/
│   └── settings/
├── games/
│   ├── snake/
│   │   ├── snake_game.dart
│   │   ├── snake_component.dart
│   │   └── snake_config.dart
│   ├── brick_breaker/
│   ├── space_shooter/
│   ├── block_puzzle/
│   └── racing/
└── main.dart

assets/
├── images/
├── sprites/
├── audio/
├── fonts/
└── games/
```

Điểm quan trọng là mỗi game không được tự xây lại toàn bộ hệ thống nút bấm, âm thanh, lưu điểm hay xử lý vòng đời ứng dụng.

## 4. Thiết kế bộ điều khiển 4 nút

Cần thống nhất ngay từ đầu vì nhiều trò chơi sẽ dùng chung hệ thống này.

D-pad: Up / Down / Left / Right

Di chuyển, đổi làn, chọn menu hoặc điều hướng khối.

Nút A

Bắn đạn, xoay khối hoặc xác nhận lựa chọn tùy theo game.

Nút B

Hành động phụ, quay lại hoặc chức năng riêng của từng game.

Mỗi game khai báo ánh xạ điều khiển riêng, ví dụ:

```
enum GameAction {
  up,
  down,
  left,
  right,
  buttonA,
  buttonB,
}

abstract interface class MiniGameController {
  void onActionDown(GameAction action);
  void onActionUp(GameAction action);
}
```

Dùng `onActionDown` và `onActionUp` để hỗ trợ cả nhấn nhanh và giữ nút. Với game cần thao tác liên tục, phải kiểm soát tốc độ lặp phím và không để thao tác đa chạm gây điều khiển sai.

## 5. Roadmap triển khai trong 6 tuần

Kế hoạch dưới đây giả định một lập trình viên Flutter làm chính, dùng asset đơn giản và chưa tích hợp backend.

## 01

Tuần 1 — Khởi tạo nền tảng

- Tạo Flutter project, thiết lập lint và CI.
- Dựng Home, Game Detail, Game Screen.
- Tạo giao diện máy retro và bộ điều khiển ảo.
- Xây dựng game loop đầu tiên bằng Flame.

Đầu ra: ứng dụng chạy trên iOS và Android, điều hướng được giữa các màn hình.

## 02

Tuần 2 — Snake và hệ thống dùng chung

- Hoàn thiện di chuyển, thức ăn, va chạm, điểm.
- Pause/Resume, Restart và Game Over.
- Lưu kỷ lục, âm thanh và xử lý lifecycle.
- Viết unit test cho luật chơi.

Đầu ra: một game hoàn chỉnh, đủ tốt để kiểm chứng kiến trúc.

## 03

Tuần 3 — Brick Breaker

- Xử lý bóng, thanh đỡ và va chạm.
- Hệ thống mạng, level, tính điểm.
- Tối ưu hiệu năng render.

Đầu ra: game thứ hai sử dụng được hạ tầng có sẵn.

## 04

Tuần 4 — Space Shooter

- Sinh kẻ địch, đạn, va chạm.
- Tăng độ khó theo thời gian.
- Hiệu ứng, âm thanh và cân bằng gameplay.

Đầu ra: ba game có vòng lặp gameplay khác nhau.

## 05

Tuần 5 — Puzzle và Racing

- Làm logic lưới và xoay khối.
- Xây dựng game đua xe theo làn.
- Chuẩn hóa cấu hình và menu của năm game.

Đầu ra: đủ năm game ở mức MVP nếu không có trở ngại lớn.

## 06

Tuần 6 — QA và phát hành thử nghiệm

- Kiểm thử trên nhiều kích thước màn hình.
- Xử lý background/foreground, âm thanh, đa chạm.
- Kiểm tra lưu điểm, crash và hiệu năng.
- Phát hành bản TestFlight và Android internal testing.

Đầu ra: bản MVP có thể đưa cho người dùng thử.

Ước tính thực tế: khoảng 6 tuần cho MVP với asset đơn giản và phạm vi được kiểm soát. Nếu cần đồ họa chỉn chu, gameplay phức tạp hoặc một người vừa học Flutter vừa triển khai, nên dự trù 8–12 tuần.

## 6. Những quyết định kỹ thuật cần chốt sớm

### Không phải game nào cũng cần Flame

- Snake và game puzzle dạng lưới: có thể làm bằng Dart thuần, Flutter CustomPainter hoặc Flame.
- Shooter, Brick Breaker và Racing: Flame thường thuận tiện hơn cho game loop, component và collision.
- Dù dùng cách nào, luật chơi nên tách khỏi giao diện để dễ test.

### Không cần backend ở MVP

Ban đầu, lưu các dữ liệu sau trên thiết bị:

- Điểm cao nhất theo game.
- Cài đặt âm thanh và rung.
- Game chơi gần nhất.
- Thành tích và thống kê cơ bản.

Chỉ thêm backend khi thực sự cần tài khoản, đồng bộ điểm, bảng xếp hạng online hoặc sự kiện cộng đồng.

### Bản quyền và phát hành

Nếu mục tiêu là tái hiện các game điện tử phổ biến, nên tự làm hoặc sử dụng asset có giấy phép phù hợp. Không mặc định rằng ROM, hình ảnh, tên thương mại hay âm thanh của các game cũ được phép phân phối miễn phí.

## 7. Tiêu chí hoàn thành MVP

## Checklist nghiệm thu

### 0/12

Gameplay

Cả 5 game đều chơi được từ đầu đến cuối

Có Pause, Resume, Restart và Game Over

Điểm số và luật chơi được kiểm thử

Trải nghiệm

Nút bấm phản hồi tốt, hỗ trợ giữ và nhả nút

Âm thanh có thể tắt và bật

Giao diện thích ứng với màn hình nhỏ và lớn

Chất lượng

Không mất điểm do chuyển ứng dụng tạm thời ngoài dự kiến

Không có lỗi nghiêm trọng khi chơi liên tục

Có bản build thử nghiệm cho iOS và Android

Kiến trúc

Game mới có thể được thêm mà không sửa lõi không cần thiết

Điểm số và cài đặt được lưu cục bộ

Có hướng dẫn build và quy trình phát hành

Reset checklistCopy checklist

## 8. Hướng phát triển sau MVP

Sau khi có năm game hoạt động ổn định, có thể phát triển thêm:

- Thư viện game mở rộng: máy bay, bóng bàn, mê cung, đua xe nhiều làn, bắn súng.
- Chế độ thử thách hàng ngày.
- Thành tích, huy hiệu và chuỗi ngày chơi.
- Bảng xếp hạng online.
- Giao diện nhiều loại máy retro để người dùng lựa chọn.
- Quảng cáo có kiểm soát hoặc gói trả phí để bỏ quảng cáo.

Mình khuyên chưa tích hợp quảng cáo, đăng nhập hoặc backend trong phiên bản đầu tiên. Hãy xác minh trước rằng gameplay đủ vui và người dùng muốn chơi lại.

## 9. Chốt định hướng trước khi bắt đầu code

Nếu chưa có quyết định nào khác, phương án mặc định mình chọn là Flutter + Flame, giao diện LCD retro, năm game tự phát triển, lưu dữ liệu local, phát hành iOS và Android. Bước code đầu tiên sẽ là dựng bộ điều khiển dùng chung và hoàn thiện Snake, sau đó mới mở rộng sang bốn trò còn lại.

# Roadmap phát triển game 4 Nút — mỗi version thêm 2 trò chơi

Mình đề xuất phát triển theo từng version, mỗi bản bổ sung đúng 2 trò chơi mới, đồng thời giữ nguyên các game đã phát hành. Cách này giúp kiểm soát chất lượng, dễ lên kế hoạch sprint và tạo lý do để người dùng quay lại sau mỗi lần cập nhật.

Mình sẽ lấy MVP ban đầu gồm 5 game làm Version 1.0, với giả định các game Snake, Brick Breaker, Space Shooter, Block Puzzle và Racing đã hoàn thành. Nếu MVP thực tế chưa có đủ 5 game, có thể điều chỉnh lại số version mà không thay đổi thứ tự ưu tiên.

## 1. Tổng quan roadmap

## V1.0 — MVP

5 game nền tảng

Nền tảng

[Snake : le célèbre jeu fera son grand retour sur smartphone très bientôt !](https://images.openai.com/static-rsc-4/bzjZvoy-Hjbzc_IsGzRYdmjXN2YAxZXfrJyG0gbHy_C3HEna_wKWEnWnNQGmLXggFxRxFGfDIwYDFg4me_S0Os6ZqRL-mbCpYSwNbf8E_omSRePXItuisYKuDZF5oX503ievnEgI02onTRRDRSwt3q_Osag6CkLylmhy1YsLQAU?purpose=inline)

Snake

[Breakout v1](https://images.openai.com/static-rsc-4/f4l631jbfex7peXSkAJ91MI8nU9aC0jmAk2n4aVquAdJQFX4Tcf1KUEvw3WgNZRixCQkWeW2GPUsdCxWGHTZT-BQdRd4k0kgLsprObQRT90HG4SPkwNPRN8k4Hvagc8hTdxT-KWDnZc9VtBoJP3isFea0b5YWZ70nMJUMxZJUXo?purpose=inline)

Brick Breaker

[retro video game space pixelated scene](https://images.openai.com/static-rsc-4/gNQ6U7oonplC0kQEifFkztRZ2u7TRXmV5KJcu0q_TK1YrMk_wmcAn27NgAtSkxINR2V8g1O6OZjAs8TGHud7VVjTjLyVmALUIeoT1bHGzD1r6shrlMIaF6LK3Gth0yAa8uZleCiwCGp8PqNA2kDbECz8h3guZcvKIRFRujvs5KJbCtcAmfwJe7eN-ur45EcD?purpose=inline)

Space Shooter

[Tetris-Special: Über 35 Jahre alt und immer noch aktuell!](https://images.openai.com/static-rsc-4/9jU5bEY0yHBbrx9GovYYauGDl8OXvKx_ha3wmVoDVy2x-f1vBNBoQBfOLK5bvI3fx9WfJeXE6PMHClvsSeTJRSRq37MLMKX_zVyPgmP_e1TzZA3pi-iGNcSThWicqPUW8APxYu-AB5dyPqCqB2JuJnJOFZZ2LD4wKd4KjcCn-Sw?purpose=inline)

Block Puzzle

[Retro Car Racing Game](https://images.openai.com/static-rsc-4/PvOqGTt7hQDPfK2OwbZtLWvRrxSOvSeuOegerZsHDT5-RxiKWlgmoKRCDATlVYOOCoUL6-YztGgc11MV9JZWA0gPTK6ns6MjAasC5KwaTFV-ikNzgcgkTbslqlmBrC8RUQoXo0Tp1x2s_HcW-vBcaMcyOv19II3JAvo5dJh5YKQ?purpose=inline)

Racing

### V1.1

7 game sau phát hành

- Pong — bóng bàn
- Memory Match — lật thẻ

### V1.2

9 game sau phát hành

- Flappy Bird-style — vượt chướng ngại
- Minesweeper — dò mìn

### V1.3

11 game sau phát hành

- Pac-Man-style — mê cung ăn điểm
- Breakout Challenge — đập gạch nâng cao

### V1.4

13 game sau phát hành

- Frogger-style — qua đường
- Space Invaders-style — phòng thủ

### V1.5

15 game sau phát hành

- Tetris Sprint — xếp gạch tốc độ
- Whack-a-Mole — đập chuột

### V1.6

17 game sau phát hành

- Tank Battle — xe tăng
- Dungeon Escape — mê cung phiêu lưu

Tổng cộng: 17 game sau V1.6. Đây là roadmap đề xuất; tên gọi và gameplay có thể thay đổi khi chốt thiết kế.

## 2. Chi tiết kế hoạch cho từng version

### V1.1 — Game đơn giản, dễ làm quen

[Pong - VGDB - Vídeo Game Data Base](https://images.openai.com/static-rsc-4/6Tp88J9oQDxseokQXxtGXibzEefZZbbgPvCW0v12vpmIVE39exCeWRr9QaNPJwz7YIZia8p8aYchOytwn06CE-ppqjj-r7E3Uj9fLT8BZ0hhow8ECzWsVhlW-2gsTCfb5g61lCmGy2pbjJ8Y4nnv8pAyB4-THxGdGMCXn79RXEo?purpose=inline)

Game 6: Pong — bóng bàn

- Hai thanh đỡ và một quả bóng.
- Chơi với máy, tăng độ khó theo điểm.
- Hỗ trợ điều khiển bằng 4 nút.
- Có màn hình thắng/thua.

Độ khó: Thấp · Ước tính: 2–3 ngày

[MEMORIZE FAST: Memoria y Atención – COKITOS](https://images.openai.com/static-rsc-4/tawXMtrOZ4yfBNgyEKcwBdK2uCZ48qRnC5wNS_jOQ1BTpOPACHuWZoytOytKowjdK-MEzxw6W4oNXeGoxqSW1y5NUa1BftSxtSpvRt0XrfbGcZb9Z6LFFpxHGvBfE1s5iKHAP_7utbqEmddjI8rzUOcGsVthewRe88QKHo1IIH4?purpose=inline)

Game 7: Memory Match — lật thẻ ghi nhớ

- Lật hai thẻ để tìm cặp giống nhau.
- Tính số lượt, thời gian hoàn thành.
- Có nhiều cấp độ với số lượng thẻ khác nhau.

Độ khó: Thấp · Ước tính: 2–3 ngày

Mục tiêu version: Hoàn thiện hệ thống menu, tính điểm, lưu kỷ lục và làm quen với nhiều loại gameplay.

### V1.2 — Phản xạ và tư duy

[Get in a flap, but don’t pipe down (updated 23rd June)](https://images.openai.com/static-rsc-4/rzC2ulau0kt85VuF1ETUPzMrO3HeucJ3q5V8d9O23x3cjDhVHhAWswDspn3-hAjaIYDrMuAIgMZRPRTSiaXg7_Y3aMitiW6F9UoAJjbZ6dyVyrgg94xIyNNGBDw3ERzie0YZvicRaCcXJ6P_DMRHj2SkHlnLoFcXREQj50Dfdlo?purpose=inline)

Game 8: Sky Hop — vượt chướng ngại

- Nhấn nút để bay hoặc nhảy.
- Né chướng ngại vật cuộn ngang.
- Tính điểm theo quãng đường.

Độ khó: Trung bình · Ước tính: 3–4 ngày

[Minesweeper (1991) - The Retro Spirit – Old games database, videos and reviews – Since 1832™](https://images.openai.com/static-rsc-4/aXSrb6JnvEGeeW40orNiEtZevyjvXxnwAjG9--J60TWOVRt_HVPPNryHvubiBe0EX_eqkiGUv7dCVXtE4lzMHA6H8_db-8vySbAEXbLofCUsqsMyeqAZvhRHR1ZDMlAIVTwgZNmoTWTNZcG2mylLDSBtrtdHFKqaPkmtyxufFNI?purpose=inline)

Game 9: Minesweeper — dò mìn

- Mở ô, đánh dấu mìn.
- Sinh bản đồ ngẫu nhiên.
- Có chế độ dễ, trung bình và khó.

Độ khó: Trung bình · Ước tính: 3–4 ngày

Mục tiêu version: Bổ sung gameplay theo thời gian thực và gameplay dạng puzzle; nâng cấp bộ điều khiển để xử lý nhấn, giữ và xác nhận ô.

### V1.3 — Arcade và giải đố

[Started developing a Frogger clone](https://images.openai.com/static-rsc-4/b7T0s2t9JGAT-qwbxIVjEJsBB0UGtaIqvKXlUJjMQPxdXYbmFcJRPZ_Ysyk7_LYpuBA7YF8VL6VTCX1xG4KpG3x3mu9E3sCFcO6ADgDdqpkaBsbeCr204jrBPMLeZJHK9CaiUa4tAFWyj9f5iRHwS_jtpeWZT6vAqzTh0Cql67s?purpose=inline)

Game 10: Road Hopper — qua đường

- Di chuyển nhân vật qua đường và dòng nước.
- Né xe, vượt vật cản.
- Tăng độ khó theo từng màn.

Độ khó: Trung bình · Ước tính: 4–5 ngày

[2048: Play Free Online on PLAY100](https://images.openai.com/static-rsc-4/ZQDVxtqjnzP5nJx0-kM2IZs2w0jBulHYRy7pAq2hhTnkabsIM1Y7mA7wTekjShEIF8tFfG8FMCtxA_w2E0gyebdQnf32Ir8S1o8W6_7RTjaCHHauXSwZUUnLS1Ik3mDfCu20tPwNJNYwwBerzWSvrU2PIURNb2rWs7QKCczBYEY?purpose=inline)

Game 11: Number Merge — ghép số

- Vuốt hoặc dùng phím điều hướng để di chuyển các ô.
- Ghép hai ô cùng giá trị.
- Lưu điểm cao nhất và trạng thái ván chơi.

Độ khó: Trung bình · Ước tính: 3–4 ngày

Mục tiêu version: Tăng độ đa dạng, mở rộng hệ thống cấp độ và lưu trạng thái chơi khi người dùng thoát app.

### V1.4 — Game phản xạ nhanh

[UESPI: FAQ](https://images.openai.com/static-rsc-4/ZBs3ttBQNKbjK4Rbw8NsNtuUoSI7bqqgDKOVej4p9LfVNJFHI7en2cbk2vWz7SuLNhIJHObON7oAQb7Awp0ZfGqzJ1aDvMFEN1wxjt4lG9DVAtVje3Sz-iE5-EId1zp9ouh_0PDIPmucnFTlaJPzU_SsBgPDIYiS9HBM0TA29Qc?purpose=inline)

Game 12: Maze Chase — đuổi bắt trong mê cung

- Di chuyển trong mê cung.
- Thu thập vật phẩm và tránh kẻ địch.
- Có nhiều bản đồ và cấp độ.

Độ khó: Cao · Ước tính: 5–7 ngày

[Whack-the-Mole](https://images.openai.com/static-rsc-4/Oowu0GJ3UEXGzKwU7P7Imug8f_ZZXCrGocZ4lwzBj3QBdnrbiuxC1HRnogtYmWx9VW-O6zcaXm50ItDAmLVFvabl9lAaV0EAT7uiaZHzyk-ArFS9-q1DK5lgttYG_oXMk8bnyO3uZrhezv_crMT1X05e0zfDy7bBJCTsJCKPkro?purpose=inline)

Game 13: Whack-a-Mole — đập chuột

- Mục tiêu xuất hiện ngẫu nhiên.
- Người chơi chọn hướng và nhấn nút để ghi điểm.
- Có giới hạn thời gian và combo.

Độ khó: Thấp–trung bình · Ước tính: 2–3 ngày

Mục tiêu version: Thêm hệ thống sinh kẻ địch, quản lý bản đồ và các thử thách tính giờ.

### V1.5 — Nâng độ sâu gameplay

[Tank Battle game @ PixelJoint.com](https://images.openai.com/static-rsc-4/wMBCUxM43cp-oH0lZ8LPk3--JkdgiMQs_WHENMb0u63VYopVGZ0HZ_LN_trkGI0_R79_rTMwWMZSWXVJOhBlgc_RHIe_zyAr-n2XBjiWVdFC7nKNuAtrnrtADgLT_FNo-JgUuS23aj4cyTeNXdhIIKm9FJc1g8Idwx7mTEL1itM?purpose=inline)

Game 14: Tank Battle — chiến đấu xe tăng

- Điều khiển xe tăng qua bản đồ.
- Bắn đạn, phá vật cản.
- Đối đầu với AI và nhiều loại kẻ địch.

Độ khó: Cao · Ước tính: 5–7 ngày

[Computer 8 bit pixel video game. Platform and arcade vector design](https://images.openai.com/static-rsc-4/lsjq7ttn_I3YZ4hjsDHlAIa-EZkUOe1hQs5Aoehbt8_3vz2OlCwZl-Qt8WhqGKqBBKdVB0TYeeZohoDCJcjq01rUgcftZha1QAVcYjnuT6H4IUly0Z_uv0tOiyTouwZfv_K5Zr6iv78A6dbGBGuM8J2G0fn-jrm5B4zGNmLPNZrPa44tdts5F8EjVhNX2OXH?purpose=inline)

Game 15: Sky Climber — nhảy lên vô tận

- Nhân vật tự nhảy giữa các bệ.
- Né chướng ngại và thu thập vật phẩm.
- Tính điểm theo độ cao đạt được.

Độ khó: Trung bình · Ước tính: 4–5 ngày

Mục tiêu version: Mở rộng hệ thống AI, va chạm, vật lý và tái sử dụng component của Flame.

### V1.6 — Tăng trải nghiệm và khả năng chơi lại

[GitHub - eysium-concordium/simon-game · GitHub](https://images.openai.com/static-rsc-4/3XARKkVvOBH3iZ5WG4I7_JtXHw8xYiAqxllRpXB5KSs_F8NFQL-s28sfTDCtcDhVkazPb0yifxS55sySBK-hkORh_RpQPTsTrP8-V_KEqrCgHEvCoU5_3B3E72MQpnV2akLFWu7L1OoJiAhBCYJkA8g3ZqFsp3YKYn0YMfVTfW8?purpose=inline)

Game 16: Simon Says — ghi nhớ chuỗi nút

- Hiển thị chuỗi nút theo thứ tự.
- Người chơi lặp lại chuỗi.
- Tăng độ dài chuỗi sau mỗi vòng.

Độ khó: Thấp · Ước tính: 2–3 ngày

[Devil’s Crush PC Engine 57 | The King of Grabs](https://images.openai.com/static-rsc-4/NEMw-u3Q1KipvybvtL2clww-D-zc7gjnNIh1Px-HKNYl8Ioh7nmLdPwGxfkACJ3NoYIp_koh_-Saq_DdAi3bo78tXBEYE3HZGUnUZpGrBPgjZWSff5gLtU3-vXSn9pA8H8S46aPmuSeCg-qEi8BgvvAWx2g3GNcR4YxysBzGV5w?purpose=inline)

Game 17: Mini Pinball — bi lăn

- Điều khiển hai thanh gạt.
- Bóng va chạm với các mục tiêu để ghi điểm.
- Có combo, điểm thưởng và nhiều mạng.

Độ khó: Cao · Ước tính: 5–7 ngày

Mục tiêu version: Hoàn thiện bộ game phong phú, cải thiện hiệu ứng, âm thanh, bảng kỷ lục và khả năng chơi lại.

## 3. Kế hoạch phát hành và ước tính effort

Ước tính dưới đây là ngày công phát triển cho mỗi cặp game, chưa tính thời gian review store hoặc các tính năng backend lớn.

| Version | Game mới                   | Ngày công dự kiến |
| ------- | -------------------------- | ----------------- |
| V1.1    | Pong + Memory Match        | 4–6 ngày          |
| V1.2    | Sky Hop + Minesweeper      | 6–8 ngày          |
| V1.3    | Road Hopper + Number Merge | 7–9 ngày          |
| V1.4    | Maze Chase + Whack-a-Mole  | 7–10 ngày         |
| V1.5    | Tank Battle + Sky Climber  | 9–12 ngày         |
| V1.6    | Simon Says + Mini Pinball  | 7–10 ngày         |

Với một developer làm toàn thời gian, nên dự trù thêm khoảng 20–30% thời gian cho kiểm thử, sửa lỗi, hoàn thiện asset và tích hợp. Các game dùng vật lý hoặc AI có thể cần thêm thời gian nếu yêu cầu chất lượng cao.

## 4. Quy tắc để mọi version không làm hỏng game cũ

Mỗi lần thêm hai game, cần hoàn thành các hạng mục sau:

- Hai game mới chơi được từ đầu đến cuối.
- Game cũ không bị lỗi do thay đổi hệ thống dùng chung.
- Điểm cao nhất và cài đặt cũ vẫn được giữ nguyên.
- Có hướng dẫn điều khiển riêng cho từng game.
- Kiểm tra pause/resume, chuyển app ra nền và chơi lại.
- Kiểm tra hiệu năng trên thiết bị cấu hình thấp.
- Tăng version, tạo build QA, kiểm tra regression và phát hành.

Nguyên tắc quan trọng: không bắt buộc phải sửa kiến trúc lõi trong mỗi version. Hãy chỉ nâng cấp `GameInput`, `Scoring`, `Audio` hoặc `GameSession` khi hai game mới thực sự cần tính năng chưa có.

## 5. Đề xuất cách quản lý backlog

Mỗi version có thể được quản lý thành một Epic riêng:

- `EPIC-V1.1`: Pong và Memory Match
- `EPIC-V1.2`: Sky Hop và Minesweeper
- `EPIC-V1.3`: Road Hopper và Number Merge
- `EPIC-V1.4`: Maze Chase và Whack-a-Mole
- `EPIC-V1.5`: Tank Battle và Sky Climber
- `EPIC-V1.6`: Simon Says và Mini Pinball

Trong mỗi Epic, tạo các task: Game Design, Gameplay, UI/Asset, Audio, Unit Test, Integration Test và Release QA. Nếu một game có nhiều cơ chế phức tạp, tách thành các subtask riêng.

Mình khuyên ưu tiên phát hành V1.1 trong vòng 1–2 tuần sau khi MVP ổn định, rồi điều chỉnh nhịp phát hành theo số ngày công thực tế của hai game đầu tiên. Đây là mốc tham khảo, không phải lịch phát hành cố định.
