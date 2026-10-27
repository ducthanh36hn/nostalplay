# STITCH BRIEF — NostalPlay (Nền tảng + Snake)

Nguồn: [SPEC.md](SPEC.md). Thiết bị: **mobile, portrait**, thiết kế cho khung ~390×844 (iPhone 14) và kiểm tra co giãn xuống 320 px rộng.

## Mô tả sản phẩm (dán đầu mỗi phiên Stitch để giữ nhất quán)

NostalPlay là app mobile mô phỏng máy chơi game điện tử cầm tay 4 nút ngày xưa: màn hình LCD xanh lá kiểu Game Boy, D-pad + nút A/B, chữ pixel. Mỗi game là một "băng" chơi trên cùng một chiếc máy ảo. Ngôn ngữ: tiếng Việt, tên game giữ tiếng Anh.

## Design tokens (dùng cho mọi màn hình)

- **Bảng màu LCD (4 sắc xanh lá)**: `#0F380F` (đậm nhất, chữ/pixel), `#306230`, `#8BAC0F`, `#9BBC0F` (nền sáng nhất).
- **Vỏ máy**: xám nhạt ngà `#C9C6BA`, viền tối `#8E8B80`, nút D-pad `#2B2B2B`, nút A/B màu đỏ rượu `#9B2335`, chữ nhãn trên vỏ `#4A4A4A`.
- **Nền app (ngoài máy)**: xám xanh tối `#1E2420`.
- **Font**: pixel font (ví dụ "Press Start 2P" hoặc "Silkscreen") cho tiêu đề và LCD; nội dung hướng dẫn dùng font sans đơn giản (ví dụ "Inter") để dễ đọc tiếng Việt có dấu.
- **Phong cách**: góc bo nhẹ ở vỏ máy, viền pixel cứng ở thành phần LCD, không gradient/bóng đổ mềm trong vùng LCD. Vùng chạm tối thiểu 44 px.
- **Tương phản**: chữ trên LCD dùng `#0F380F` trên `#9BBC0F`.

## Thứ tự tạo màn hình và liên kết

1. Home → chạm thẻ game → 2. Game Detail → nút PLAY → 3. Game Screen (Ready) → 4. Game Screen (Playing) → 5. Pause overlay → 6. Game Over (có/không kỷ lục) → quay về Home hoặc chơi lại.
Home → biểu tượng ⚙ → 7. Settings. Icon app (Prompt 7) làm độc lập.

---

## Prompt 1 — Home

```
Mobile app screen, portrait 390x844. App "NostalPlay", retro handheld game console style. Dark blue-green background #1E2420.

Top: app title "NOSTALPLAY" in pixel font (Press Start 2P), color #9BBC0F, small pixel-art gamepad icon on the left, a settings gear icon button on the right (44px touch target).

Subtitle under title: "Chọn băng để chơi" in light sans font, muted #8BAC0F.

Main area: a vertical list of game cards styled like old game cartridges / LCD tiles. Each card: left a 64x64 pixel-art icon on a green LCD tile (#9BBC0F with #0F380F pixels), center the game name in pixel font, below it a line "Best: 1250", a small chevron on the right. Card background #2B332D, 2px pixel border #306230, slightly rounded corners.

Show exactly ONE card: "SNAKE" with pixel-art snake icon and "Best: 1250".

Also show variant states in the design notes: (a) game with no score yet shows "New game" instead of Best, (b) a longer list that scrolls.

Style: flat, crisp pixel edges, no soft shadows, high contrast. Bottom safe area padding. Vietnamese language UI.
```

## Prompt 2 — Game Detail

```
Mobile app screen, portrait 390x844, same retro handheld style as the Home screen (background #1E2420, LCD green palette #0F380F #306230 #8BAC0F #9BBC0F, pixel font Press Start 2P for headings, Inter for body).

Top bar: back arrow button on the left (44px), title "SNAKE" in pixel font.

Hero: a large LCD-style panel (#9BBC0F with #0F380F pixel border) showing a pixel-art snake eating an apple on a small grid, ~ 300x180.

Below: "Best: 1250" in pixel font on a small badge (or "Chưa có kỷ lục" for no score).

Section "Luật chơi": short Vietnamese text — "Điều khiển rắn ăn mồi để dài ra. Đâm vào tường hoặc thân mình là thua. Càng ăn nhiều, rắn càng nhanh."

Section "Điều khiển": a compact diagram of the console controls — D-pad with arrows labeled "Đổi hướng", button A (dark red circle) labeled "Giữ để tăng tốc", button B labeled "Không dùng" (dimmed).

Bottom: a large primary button "PLAY" in pixel font, background #9BBC0F, text #0F380F, 2px pixel border, full width with 16px side margins, 56px high.
```

## Prompt 3 — Game Screen (Ready & Playing)

```
Mobile app screen, portrait 390x844. A virtual retro handheld console fills the screen, in the style of a Game Boy, ivory-gray body #C9C6BA with darker edge #8E8B80, rounded corners. App background #1E2420.

Top of the console: a thin strip with a small pixel "II" pause button on the left (44px target) and a tiny label "NOSTALPLAY" on the right.

Screen bezel: dark gray frame around a square LCD, ~ 320x320, LCD color #9BBC0F with pixels #0F380F. Above the LCD inside the bezel, a status row in pixel font: "SCORE 0030" left, "BEST 1250" right.

Inside the LCD: a 16x16 grid game field with a snake of 3 segments facing right in the center and one apple. Show TWO states of the same screen:
 (A) READY: LCD overlay text centered "NHẤN A ĐỂ CHƠI" blinking, snake and apple visible.
 (B) PLAYING: snake of 8 segments, apple, no overlay; an optional small "x2" speed indicator in the corner of the LCD when speed boost is active.

Controls area (lower 40% of the screen): on the left a D-pad cross (dark #2B2B2B, 4 directions with arrow glyphs, ~150px wide); on the right two round buttons A and B (diameter 64px, color #9B2335, labels engraved A and B, B slightly lower-left of A like a real handheld). Show a pressed state for one button (darker, shifted 2px).

Bottom: tiny speaker-grill lines on the right bottom of the body as decoration.

Layout must scale down to 320px width without overlap; touch targets >= 44px.
```

## Prompt 4 — Pause overlay

```
Same retro handheld Game Screen as before (snake game in progress), with a pause overlay on top of the LCD: a dimmed LCD (#306230 at 70% over the game) and a centered menu panel in LCD style (#9BBC0F background, #0F380F 2px pixel border).

Title "TẠM DỪNG" in pixel font. Three stacked buttons, each full-width of the panel, 48px high, pixel font: "TIẾP TỤC" (primary, filled #0F380F with #9BBC0F text), "CHƠI LẠI" (outlined), "VỀ MENU" (outlined). A small toggle row below: sound icon and vibration icon, each on/off.

The console body and controls remain visible below, D-pad and A/B slightly dimmed.
```

## Prompt 5 — Game Over (2 trạng thái)

```
Same retro handheld console, the LCD shows a Game Over panel in LCD style (#9BBC0F with #0F380F pixel text). Create TWO variants:

Variant A — New record: big pixel text "GAME OVER", below "ĐIỂM: 1310", a blinking badge "KỶ LỤC MỚI!" with small pixel stars, "BEST: 1310". 
Variant B — No record: "GAME OVER", "ĐIỂM: 420", "BEST: 1250".

Two buttons under the text on the LCD: "CHƠI LẠI" (primary, filled #0F380F) and "VỀ MENU" (outlined). Also mention in notes: pressing A on the console = "CHƠI LẠI".

Optional third variant: perfect win — text "HOÀN HẢO!" when the snake fills the whole grid.
```

## Prompt 6 — Settings

```
Mobile app screen, portrait 390x844, retro handheld app style (background #1E2420, LCD green palette, pixel font headings, Inter body).

Top bar: back arrow (44px), title "CÀI ĐẶT" in pixel font.

List of two setting rows on dark cards (#2B332D, 2px border #306230): 
1. Speaker icon, label "Âm thanh", a retro-style toggle switch (pixel square knob, ON = #9BBC0F, OFF = #306230), subtitle "Bật/tắt hiệu ứng âm thanh".
2. Vibration icon, label "Rung", same toggle, subtitle "Rung nhẹ khi nhấn nút".

Footer: app version text "NostalPlay v1.0.0" small, muted #8BAC0F, centered.

Show both toggle states in the design (one ON, one OFF).
```

## Prompt 7 — Icon app

```
App icon, square 1024x1024, full-bleed solid background (no transparency, no rounded corners, no text).

Background: dark blue-green #1E2420, with a very subtle pixel-dot pattern in #2B332D.

Center: a retro handheld game console tilted about 12 degrees clockwise, filling ~70% of the canvas. Body ivory-gray #C9C6BA with darker edge #8E8B80, rounded corners. Large LCD screen (~50% of the console face) with a thick dark bezel; the LCD is green #9BBC0F and shows a pixel-art snake (#0F380F) curling toward a pixel apple. Below the screen: a dark D-pad cross (#2B2B2B) on the left, two round wine-red buttons (#9B2335) on the right.

Style: flat vector with crisp pixel details on the screen only, bold simple shapes, high contrast, readable at 48x48 px. Max 4 details: screen, snake, D-pad, A/B buttons. Do not copy Nintendo Game Boy proportions or logos. No text, no gradients except a faint soft glow behind the console.

Safe zone: keep all important content within the central 66% circle (for Android adaptive icon). Also provide a version of the console on a transparent background for the Android foreground layer.
```

Kiểm tra: thu nhỏ xuống 48 px, đặt thử trên nền sáng và tối; xuất `icon-1024.png` (iOS) và `icon-foreground.png` + màu nền `#1E2420` (Android) vào `design/`.

---

## Cách bàn giao (Cổng 2)

1. Dán **Mô tả sản phẩm + Design tokens** vào Stitch trước, sau đó dán lần lượt Prompt 1 → 6; chỉnh cho đến khi hài lòng.
2. Xuất kết quả vào `docs/platform-snake/design/` bằng một trong các cách:
   - HTML/CSS hoặc "Copy code" → `design/home.html`, `design/game-detail.html`, `design/game-screen.html`, `design/pause.html`, `design/game-over.html`, `design/settings.html`
   - hoặc ảnh chụp màn hình `design/*.png` (nên có cả trạng thái Ready/Playing/Pressed/Variant).
3. Báo lại khi xong để mình đọc design và triển khai.

**Lưu ý khi review design**: nút Pause hệ thống, nút A là hành động "bắt đầu/chơi lại" ở Ready/Game Over (SPEC FR-18 và Q1), D-pad/A/B phải ≥ 44 px, không chồng nhau ở 320 px.
