import 'package:anaheim_technologies_website/app/app.dart';
import 'package:anaheim_technologies_website/bootstrap.dart';
import 'package:anaheim_technologies_website/utils/platform_stub.dart'
if (dart.library.html)
'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:flutter/foundation.dart';

void main() {
  if (kIsWeb) {
    usePathUrlStrategy();
  }
  bootstrap(() => App());
}
