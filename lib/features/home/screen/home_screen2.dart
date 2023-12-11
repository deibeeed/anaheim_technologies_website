import 'package:anaheim_technologies_website/features/home/cubit/menu_selection_cubit.dart';
import 'package:anaheim_technologies_website/features/home/cubit/service_select_cubit.dart';
import 'package:anaheim_technologies_website/utils/color_utils.dart';
import 'package:anaheim_technologies_website/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomeScreen2 extends StatelessWidget {
  final Widget child;

  HomeScreen2({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const maxWidth = 1000.0;

    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ServiceSelectCubit(),
          ),
          BlocProvider(
            create: (context) => MenuSelectionCubit(),
          ),
        ],
        child: Scaffold(
          body: WidgetUtils.defaultBackground(
            context: context,
            child: Center(
              child: SizedBox(
                width: maxWidth,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 56,
                      ),
                      child: BlocBuilder<MenuSelectionCubit, int>(
                        builder: (context, state) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.ideographic,
                            children: [
                              InkWell(
                                onTap: () {
                                  context.read<MenuSelectionCubit>().selectNone();
                                  GoRouter.of(context).go('/');
                                },
                                child: const Text(
                                  'ATO',
                                  style: TextStyle(
                                    fontFamily: 'Mechsuit',
                                    fontSize: 32,
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                              ),
                              Expanded(child: Container()),
                              HoveredText(
                                text: 'about us',
                                navigateTo: '/us',
                                alwaysShowIndicator: context.read<MenuSelectionCubit>().isAboutSelected,
                                onTap: () {
                                  context.read<MenuSelectionCubit>().selectAbout();
                                },
                              ),
                              const SizedBox(
                                width: 32,
                              ),
                              HoveredText(
                                text: 'services',
                                navigateTo: '/services',
                                alwaysShowIndicator: context.read<MenuSelectionCubit>().isServicesSelected,
                                onTap: () {
                                  context.read<MenuSelectionCubit>().selectServices();
                                },
                              ),
                              const SizedBox(
                                width: 32,
                              ),
                              HoveredText(
                                text: 'projects',
                                navigateTo: '/projects',
                                alwaysShowIndicator: context.read<MenuSelectionCubit>().isProjectsSelected,
                                onTap: () {
                                  context.read<MenuSelectionCubit>().selectProjects();
                                },
                              ),
                              const SizedBox(
                                width: 32,
                              ),
                              HoveredText(
                                text: 'contact us',
                                navigateTo: '/contact',
                                alwaysShowIndicator: context.read<MenuSelectionCubit>().isContactUsSelected,
                                onTap: () {
                                  context.read<MenuSelectionCubit>().selectContactUs();
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 96,
                        ),
                        child: child,
                      ),
                    ),
                    if (GoRouter.of(context).location != '/')
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 56,
                        ),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () => GoRouter.of(context).go('/'),
                              child: const Text(
                                'ATO',
                                style: TextStyle(
                                  fontFamily: 'Mechsuit',
                                  fontSize: 24,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () async {
                                if (await canLaunchUrlString(
                                    'https://fb.com/anaheim.technologies')) {
                                  launchUrlString(
                                      'https://fb.com/anaheim.technologies');
                                }
                              },
                              child: SvgPicture.asset(
                                'assets/svg/facebook.svg',
                                height: 24,
                                color: AppColors.foregroundColor,
                              ),
                            ),
                            const Gap(16),
                            InkWell(
                              onTap: () async {
                                if (await canLaunchUrlString(
                                    'https://linkedin.com/company/anaheim-technologies')) {
                                  launchUrlString(
                                      'https://linkedin.com/company/anaheim-technologies');
                                }
                              },
                              child: SvgPicture.asset(
                                'assets/svg/linkedin.svg',
                                height: 24,
                                color: AppColors.foregroundColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
