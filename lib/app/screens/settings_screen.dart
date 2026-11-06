import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/ads/ads_controller.dart';
import '../../core/l10n/strings.dart';
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
            ScreenHeader(title: context.s.settings),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: [
                  _SettingTile(
                    icon: Icons.volume_up,
                    title: context.s.sound,
                    subtitle: context.s.soundSub,
                    value: settings.soundEnabled,
                    onChanged: settings.setSound,
                  ),
                  const SizedBox(height: 16),
                  _SettingTile(
                    icon: Icons.vibration,
                    title: context.s.vibration,
                    subtitle: context.s.vibrationSub,
                    value: settings.hapticsEnabled,
                    onChanged: settings.setHaptics,
                  ),
                  const SizedBox(height: 16),
                  _LanguageTile(
                    value: settings.language,
                    onChanged: settings.setLanguage,
                  ),
                  if (ads.privacyOptionsRequired) ...[
                    const SizedBox(height: 16),
                    _ActionTile(
                      icon: Icons.privacy_tip_outlined,
                      title: context.s.privacyTitle,
                      subtitle: context.s.privacySub,
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
                Expanded(
                  child: Center(
                    child: Text(
                      context.s.on,
                      style: const TextStyle(
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
                Expanded(
                  child: Center(
                    child: Text(
                      context.s.off,
                      style: const TextStyle(
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

/// Language picker: follow the phone, Vietnamese or English.
class _LanguageTile extends StatelessWidget {
  const _LanguageTile({required this.value, required this.onChanged});

  final LanguageSetting value;
  final ValueChanged<LanguageSetting> onChanged;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    String label(LanguageSetting l) => switch (l) {
      LanguageSetting.auto => s.languageAuto,
      LanguageSetting.vi => 'TIẾNG VIỆT',
      LanguageSetting.en => 'ENGLISH',
    };
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NpColors.card,
        border: Border.all(color: NpColors.lcdDark, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                color: NpColors.surface,
                child: const Icon(Icons.language, color: NpColors.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.languageTitle,
                      style: const TextStyle(
                        fontFamily: kMono,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: NpColors.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      s.languageSub,
                      style: const TextStyle(
                        fontFamily: kSans,
                        fontSize: 13,
                        color: NpColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (final l in LanguageSetting.values) ...[
                if (l != LanguageSetting.auto) const SizedBox(width: 8),
                Expanded(
                  child: Semantics(
                    button: true,
                    selected: l == value,
                    label: label(l),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onChanged(l),
                      child: Container(
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: l == value
                              ? NpColors.primary
                              : NpColors.surface,
                          border: Border.all(color: NpColors.lcdDark, width: 2),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            label(l),
                            style: TextStyle(
                              fontFamily: kMono,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                              color: l == value
                                  ? NpColors.onPrimary
                                  : NpColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
