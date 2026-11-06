import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/game_definition.dart';
import '../../core/l10n/strings.dart';
import '../../core/storage/app_storage.dart';
import '../routes.dart';
import '../theme.dart';
import '../widgets/screen_header.dart';

class GameDetailScreen extends StatefulWidget {
  const GameDetailScreen({super.key, required this.game});

  final GameDefinition game;

  @override
  State<GameDetailScreen> createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends State<GameDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final game = widget.game;
    final best = context.read<AppStorage>().bestScore(game.id);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ScreenHeader(title: game.title),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                children: [
                  _preview(),
                  const SizedBox(height: 12),
                  _bestBadge(context, best),
                  const SizedBox(height: 16),
                  _rules(context, game),
                  const SizedBox(height: 16),
                  _controls(context, game),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: _PlayButton(
                onTap: () => Navigator.of(context)
                    .pushNamed(Routes.play, arguments: game.id)
                    .then((_) => setState(() {})),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _preview() {
    return Container(
      height: 150,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: NpColors.lcdBright,
        border: Border.all(color: NpColors.lcdDeep, width: 2),
      ),
      child: Builder(
        builder: (context) =>
            widget.game.icon?.call(context) ?? const SizedBox(),
      ),
    );
  }

  Widget _bestBadge(BuildContext context, int best) {
    return _Card(
      child: Row(
        children: [
          const Icon(Icons.emoji_events, color: NpColors.primary, size: 22),
          const SizedBox(width: 8),
          Text(
            best > 0 ? context.s.bestUpper(best) : context.s.noRecordUpper,
            style: const TextStyle(
              fontFamily: kMono,
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: NpColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _rules(BuildContext context, GameDefinition game) {
    final texts = game.textsFor(context.s.language);
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _SectionTitle(context.s.rulesTitle)),
              if (texts.gridInfo != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  color: NpColors.surface,
                  child: Text(
                    texts.gridInfo!,
                    style: const TextStyle(
                      fontFamily: kMono,
                      fontSize: 11,
                      color: NpColors.onSurfaceVariant,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            texts.rules,
            style: const TextStyle(
              fontFamily: kSans,
              fontSize: 15,
              height: 1.5,
              color: NpColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _controls(BuildContext context, GameDefinition game) {
    final texts = game.textsFor(context.s.language);
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(context.s.controlsTitle),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _ControlTile(
                  leading: const _MiniDPad(),
                  title: 'D-PAD',
                  hint: texts.dpadHint,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  children: [
                    _ControlTile(
                      leading: const _MiniButton('A', used: true),
                      title: context.s.buttonATitle,
                      hint: texts.aHint,
                      row: true,
                    ),
                    const SizedBox(height: 8),
                    _ControlTile(
                      leading: _MiniButton('B', used: texts.bHint != null),
                      title: context.s.buttonBTitle,
                      hint: texts.bHint ?? context.s.notUsed,
                      dim: texts.bHint == null,
                      row: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NpColors.card,
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: kMono,
        fontWeight: FontWeight.w700,
        fontSize: 13,
        letterSpacing: 1.4,
        color: NpColors.primary,
      ),
    );
  }
}

class _ControlTile extends StatelessWidget {
  const _ControlTile({
    required this.leading,
    required this.title,
    required this.hint,
    this.dim = false,
    this.row = false,
  });

  final Widget leading;
  final String title;
  final String hint;
  final bool dim;
  final bool row;

  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(
      fontFamily: kMono,
      fontWeight: FontWeight.w700,
      fontSize: 12,
      color: dim ? NpColors.silkscreen : NpColors.primary,
    );
    final hintStyle = TextStyle(
      fontFamily: kSans,
      fontSize: 13,
      color: dim ? NpColors.silkscreen : NpColors.onSurface,
    );
    final text = Column(
      crossAxisAlignment: row
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        Text(title, style: titleStyle),
        Text(hint, style: hintStyle, textAlign: row ? null : TextAlign.center),
      ],
    );
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: NpColors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: row
          ? Row(
              children: [
                leading,
                const SizedBox(width: 10),
                Expanded(child: text),
              ],
            )
          : Column(children: [leading, const SizedBox(height: 6), text]),
    );
  }
}

class _MiniButton extends StatelessWidget {
  const _MiniButton(this.label, {required this.used});

  final String label;
  final bool used;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: used
            ? NpColors.actionCrimson
            : NpColors.actionCrimson.withValues(alpha: 0.3),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: kMono,
          fontWeight: FontWeight.w700,
          color: Color(used ? 0xFFFFDADA : 0x66FFDADA),
        ),
      ),
    );
  }
}

class _MiniDPad extends StatelessWidget {
  const _MiniDPad();

  @override
  Widget build(BuildContext context) {
    const arm = 28.0;
    Widget cell(IconData? icon) => SizedBox(
      width: arm,
      height: arm,
      child: ColoredBox(
        color: icon == null
            ? NpColors.controlCharcoal
            : NpColors.controlCharcoal,
        child: icon == null
            ? null
            : Icon(icon, size: 20, color: NpColors.onSurface),
      ),
    );
    const none = SizedBox(width: arm, height: arm);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [none, cell(Icons.keyboard_arrow_up), none],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            cell(Icons.keyboard_arrow_left),
            cell(null),
            cell(Icons.keyboard_arrow_right),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [none, cell(Icons.keyboard_arrow_down), none],
        ),
      ],
    );
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: context.s.playSemantics,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          height: 56,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: NpColors.primary,
            boxShadow: [
              BoxShadow(color: Color(0xFF516600), offset: Offset(0, 4)),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.play_arrow, color: NpColors.onPrimary),
              const SizedBox(width: 8),
              Text(
                context.s.play,
                style: const TextStyle(
                  fontFamily: kMono,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  letterSpacing: 2,
                  color: NpColors.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
