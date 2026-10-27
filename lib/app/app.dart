import 'package:flutter/material.dart';

import 'theme.dart';

class NostalPlayApp extends StatelessWidget {
  const NostalPlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NostalPlay',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const _Placeholder(),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('NOSTALPLAY', style: text.headlineMedium),
            const SizedBox(height: 8),
            Text('Chọn băng để chơi', style: text.bodyMedium),
            const SizedBox(height: 16),
            Text(
              'LUẬT CHƠI · ĐIỀU KHIỂN · TẠM DỪNG · KỶ LỤC MỚI',
              style: text.labelLarge,
            ),
          ],
        ),
      ),
    );
  }
}
