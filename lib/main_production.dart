import 'package:anaheim_technologies_website/app/app.dart';
import 'package:anaheim_technologies_website/bootstrap.dart';
import 'package:anaheim_technologies_website/firebase_options.dart';
import 'package:anaheim_technologies_website/utils/platform_stub.dart'
if (dart.library.html)
'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

void main() async {
  Logger.root.level = Level.WARNING;
  Logger.root.onRecord.listen((record) {
    print('[${record.loggerName}] [${record.level.name}]: ${record.time}: ${record.message}');
  });
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (kIsWeb) {
    usePathUrlStrategy();
  }

  final log = Logger('main.dart');
  const env = String.fromEnvironment('ENVIRONMENT');
  log.info('environment: $env');

  bootstrap(() => App());
}
