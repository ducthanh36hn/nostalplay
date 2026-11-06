import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/ads/ads_controller.dart';
import '../../core/settings_controller.dart';
import '../theme.dart';
import '../widgets/screen_header.dart';

/// Keep in sync with `version:` in pubspec.yaml.
const String kAppVersion = '1.0.0';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();
    final ads = context.watch<AdsController>();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ScreenHeader(title: 'Cài đặt'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: [
                  _SettingTile(
                    icon: Icons.volume_up,
                    title: 'Âm thanh',
                    subtitle: 'Bật/tắt hiệu ứng âm thanh',
                    value: settings.soundEnabled,
                    onChanged: settings.setSound,
                  ),
                  const SizedBox(height: 16),
                  _SettingTile(
                    icon: Icons.vibration,
                    title: 'Rung',
                    subtitle: 'Rung nhẹ khi nhấn nút',
                    value: settings.hapticsEnabled,
                    onChanged: settings.setHaptics,
                  ),
                  if (ads.privacyOptionsRequired) ...[
                    const SizedBox(height: 16),
                    _ActionTile(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Quyền riêng tư quảng cáo',
                      subtitle: 'Xem hoặc đổi lựa chọn đồng ý',
                      onTap: ads.showPrivacyOptions,
                    ),
                  ],
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                'NOSTALPLAY V$kAppVersion',
                style: TextStyle(
                  fontFamily: kMono,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  letterSpacing: 1.6,
                  color: NpColors.lcdMid,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      toggled: value,
      label: title,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onChanged(!value),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: NpColors.card,
            border: Border.all(color: NpColors.lcdDark, width: 2),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                color: NpColors.surface,
                child: Icon(
                  icon,
                  color: value ? NpColors.primary : NpColors.silkscreen,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: kMono,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: NpColors.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontFamily: kSans,
                        fontSize: 13,
                        color: NpColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              _PixelSwitch(on: value),
            ],
          ),
        ),
      ),
    );
  }
}

class _PixelSwitch extends StatelessWidget {
  const _PixelSwitch({required this.on});

  final bool on;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 32,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: on ? const Color(0xFF5A7210) : NpColors.surface,
            border: Border.all(color: NpColors.lcdDark, width: 2),
          ),
          child: Row(
            children: [
              if (on)
                const Expanded(
                  child: Center(
                    child: Text(
                      'BẬT',
                      style: TextStyle(
                        fontFamily: kMono,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                        color: NpColors.primary,
                      ),
                    ),
                  ),
                ),
              Container(
                width: 24,
                color: on ? NpColors.lcdBright : NpColors.lcdDark,
              ),
              if (!on)
                const Expanded(
                  child: Center(
                    child: Text(
                      'TẮT',
                      style: TextStyle(
                        fontFamily: kMono,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                        color: NpColors.silkscreen,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          on ? '[ON]' : '[OFF]',
          style: TextStyle(
            fontFamily: kMono,
            fontSize: 10,
            color: on ? NpColors.primary : NpColors.silkscreen,
          ),
        ),
      ],
    );
  }
}

/// Settings row that opens something instead of toggling.
class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: title,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: NpColors.card,
            border: Border.all(color: NpColors.lcdDark, width: 2),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                color: NpColors.surface,
                child: Icon(icon, color: NpColors.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: kMono,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: NpColors.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontFamily: kSans,
                        fontSize: 13,
                        color: NpColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: NpColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}
