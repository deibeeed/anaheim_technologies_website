import 'package:anaheim_technologies_website/features/about_us/screen/about_us_screen.dart';
import 'package:anaheim_technologies_website/features/contact_us/bloc/contact_us_bloc.dart';
import 'package:anaheim_technologies_website/features/contact_us/screen/contact_us_screen.dart';
import 'package:anaheim_technologies_website/features/home/screen/home_screen.dart';
import 'package:anaheim_technologies_website/features/home/screen/home_screen2.dart';
import 'package:anaheim_technologies_website/features/home/screen/home_screen_content.dart';
import 'package:anaheim_technologies_website/features/privacy/screen/privacy_screen.dart';
import 'package:anaheim_technologies_website/features/projects/screen/projects_screen.dart';
import 'package:anaheim_technologies_website/features/services/screen/services_screen.dart';
import 'package:anaheim_technologies_website/l10n/l10n.dart';
import 'package:anaheim_technologies_website/utils/color_utils.dart';
import 'package:anaheim_technologies_website/utils/constants.dart';
import 'package:anaheim_technologies_website/utils/router_utils.dart';
import 'package:anaheim_technologies_website/utils/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class App extends StatelessWidget {
  App({super.key});

  static final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

  final GoRouter _rootRouter = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    routes: [
      ShellRoute(
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) {
              return buildPageWithDefaultTransition<void>(
                context: context,
                state: state,
                child: HomeScreenContent(),
              );
            },
          ),
          GoRoute(
            path: '/privacy',
            builder: (context, state) {
              return const PrivacyScreen();
            },
            pageBuilder: (context, state) {
              return buildPageWithDefaultTransition<void>(
                context: context,
                state: state,
                child: const PrivacyScreen(),
              );
            },
          ),
          GoRoute(
            path: '/us',
            pageBuilder: (context, state) {
              return buildPageWithDefaultTransition<void>(
                context: context,
                state: state,
                child: const AboutUsScreen(),
              );
            },
          ),
          GoRoute(
            path: '/contact',
            pageBuilder: (context, state) {
              return buildPageWithDefaultTransition<void>(
                context: context,
                state: state,
                child: ContactUsScreen(),
              );
            },
          ),
          GoRoute(
            path: '/projects',
            pageBuilder: (context, state) {
              return buildPageWithDefaultTransition<void>(
                context: context,
                state: state,
                child: const ProjectsScreen(),
              );
            },
          ),
          GoRoute(
            path: '/services',
            pageBuilder: (context, state) {
              return buildPageWithDefaultTransition<void>(
                context: context,
                state: state,
                child: const ServicesScreen(),
              );
            },
          ),
        ],
        builder: (context, state, child) {
          return HomeScreen2(child: child);
        }
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    Constants.isExpandedScreen =
        getScreenSize(context: context) == ScreenSize.expanded;
    Constants.isMediumScreen =
        getScreenSize(context: context) == ScreenSize.medium;
    Constants.isCompactScreen =
        getScreenSize(context: context) == ScreenSize.compact;

    return BlocProvider(
      create: (context) => ContactUsBloc(),
      child: MaterialApp.router(
        routerConfig: _rootRouter,
        theme: ThemeData(
            appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
            colorScheme: ColorScheme.fromSwatch(
              accentColor: const Color(0xFF13B9FF),
            ),
            textTheme: GoogleFonts.notoSansTextTheme().apply(
              bodyColor: AppColors.foregroundColor,
              displayColor: AppColors.foregroundColor,
            )),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }
}
//<a href="https://www.flaticon.com/free-icons/under-construction" title="under construction icons">Under construction icons created by max.icons - Flaticon</a>
// <a href="https://www.flaticon.com/free-icons/under-construction" title="under construction icons">Under construction icons created by Freepik - Flaticon</a>
