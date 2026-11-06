import 'package:flutter/material.dart';

import 'screens/demo_screen.dart';
import 'theme.dart';

class NostalPlayApp extends StatelessWidget {
  const NostalPlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NostalPlay',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const DemoScreen(),
    );
  }
}
