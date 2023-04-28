import 'package:anaheim_technologies_website/counter/counter.dart';
import 'package:anaheim_technologies_website/features/home/screen/home_screen.dart';
import 'package:anaheim_technologies_website/features/privacy/screen/privacy_screen.dart';
import 'package:anaheim_technologies_website/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class App extends StatelessWidget {
  App({super.key});
  static final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

  final GoRouter _rootRouter = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: '/privacy',
        builder: (context, state) {
          return const PrivacyScreen();
        },
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _rootRouter,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: const Color(0xFF13B9FF),
        ),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
//<a href="https://www.flaticon.com/free-icons/under-construction" title="under construction icons">Under construction icons created by max.icons - Flaticon</a>
// <a href="https://www.flaticon.com/free-icons/under-construction" title="under construction icons">Under construction icons created by Freepik - Flaticon</a>