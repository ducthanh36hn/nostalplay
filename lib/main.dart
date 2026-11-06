import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app/app.dart';
import 'core/storage/app_storage.dart';
import 'games/games.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(const [
    DeviceOrientation.portraitUp,
  ]);
  final storage = await AppStorage.load();
  runApp(NostalPlayApp(storage: storage, registry: buildGameRegistry()));
}
