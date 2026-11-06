import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/game_definition.dart';
import '../../core/storage/app_storage.dart';
import '../routes.dart';
import '../theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final registry = context.read<GameRegistry>();
    final storage = context.read<AppStorage>();
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _header(context),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                itemCount: registry.games.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final game = registry.games[i];
                  return _GameCard(
                    game: game,
                    best: storage.bestScore(game.id),
                    onTap: () => Navigator.of(context)
                        .pushNamed(Routes.detail, arguments: game.id)
                        .then((_) => setState(() {})),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: NpColors.lcdDeep,
              border: Border.all(color: NpColors.lcdDark, width: 2),
            ),
            child: const Icon(
              Icons.sports_esports,
              size: 22,
              color: NpColors.lcdBright,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('NOSTALPLAY', style: text.headlineMedium),
                Text('Chọn băng để chơi', style: text.bodyMedium),
              ],
            ),
          ),
          Semantics(
            button: true,
            label: 'Cài đặt',
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context).pushNamed(Routes.settings),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: NpColors.card,
                  border: Border.all(color: NpColors.lcdDark, width: 2),
                ),
                child: const Icon(Icons.settings, color: NpColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  const _GameCard({
    required this.game,
    required this.best,
    required this.onTap,
  });

  final GameDefinition game;
  final int best;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${game.title}, ${best > 0 ? 'kỷ lục $best' : 'chưa có kỷ lục'}',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: NpColors.card,
            border: Border.all(color: NpColors.lcdDark, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                color: NpColors.lcdBright,
                alignment: Alignment.center,
                child: game.icon?.call(context),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game.title.toUpperCase(),
                      style: const TextStyle(
                        fontFamily: kMono,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        letterSpacing: 1,
                        color: NpColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      best > 0 ? 'Best: $best' : 'New game',
                      style: const TextStyle(
                        fontFamily: kMono,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: NpColors.lcdMid,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: NpColors.lcdMid),
            ],
          ),
        ),
      ),
    );
  }
}
