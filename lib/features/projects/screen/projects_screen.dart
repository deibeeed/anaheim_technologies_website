import 'package:anaheim_technologies_website/features/projects/screen/projects_content_screen.dart';
import 'package:anaheim_technologies_website/utils/color_utils.dart';
import 'package:anaheim_technologies_website/utils/widget_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var rx0Height = size.height * 0.55;
    var reginleifHeight = size.height * 0.4;
    var strikeFreedomHeight = size.height * 0.62;
    var screenHeight = size.height;
    var screenWidth = size.width;

    if (rx0Height > 800) {
      rx0Height = 800.0;
    }

    if (reginleifHeight > 650) {
      reginleifHeight = 650.0;
    }

    if (strikeFreedomHeight > 635) {
      strikeFreedomHeight = 635;
    }

    if (screenHeight > 2048) {
      screenHeight = 2048;
    }

    if (screenWidth > 1920) {
      screenWidth = 1920;
    }

    return Scaffold(
      body: WidgetUtils.defaultBackground(
        context: context,
        child: Center(
          child: SizedBox(
            width: screenWidth,
            height: screenHeight,
            child: Stack(
              children: [
                Positioned(
                  top: screenHeight * 0.09,
                  right: -10,
                  child: SvgPicture.asset(
                    'assets/svg/rx-0-vector.svg',
                    height: rx0Height,
                    colorFilter: ColorFilter.mode(
                      AppColors.foregroundColor.withOpacity(0.015),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                Positioned(
                  left: -190,
                  top: screenHeight * 0.6,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(math.pi),
                    child: SvgPicture.asset(
                      'assets/svg/strike-freedom-vector.svg',
                      height: strikeFreedomHeight,
                      colorFilter: ColorFilter.mode(
                        AppColors.foregroundColor.withOpacity(0.015),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: screenHeight * 0.6,
                  top: screenHeight * 0.75,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationZ(0.28),
                    child: SvgPicture.asset(
                      'assets/svg/reginleif-vector.svg',
                      height: reginleifHeight,
                      colorFilter: ColorFilter.mode(
                        AppColors.foregroundColor.withOpacity(0.015),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                // contents here
                Positioned(
                  top: 56,
                  left: screenWidth * 0.18,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.ideographic,
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
                      const SizedBox(
                        width: 78,
                      ),
                      const HoveredText(
                        text: 'about us',
                        navigateTo: '/us',
                      ),
                      const SizedBox(
                        width: 68,
                      ),
                      const HoveredText(
                        text: 'projects',
                        navigateTo: '/projects',
                        alwaysShowIndicator: true,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 80,
                  right: screenWidth * 0.08,
                  child: const HoveredText(
                    text: 'hello@anaheimtechnologies.com',
                    textStyle: TextStyle(fontFamily: 'Plavsky', color: AppColors.whiteColor),
                    navigateTo: '/hello',
                  ),
                ),
                // content here
                Positioned(
                  top: screenHeight * 0.15,
                  left: screenWidth * 0.25,
                  child: ProjectsContentScreen(),
                ),
                //  footer
                Positioned(
                  left: screenWidth * 0.1,
                  right: screenWidth * 0.06,
                  bottom: 56,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () async {
                          if (await canLaunchUrlString('https://fb.com/anaheim.technologies')) {
                            launchUrlString('https://fb.com/anaheim.technologies');
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SvgPicture.asset(
                              'assets/svg/facebook.svg',
                              height: 24,
                              color: AppColors.foregroundColor,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            const Text(
                              'fb.com/anaheim.technologies',
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SvgPicture.asset(
                            'assets/svg/internet.svg',
                            height: 24,
                            color: AppColors.foregroundColor,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          const Text(
                            'anaheimtechnologies.com',
                          )
                        ],
                      ),
                      InkWell(
                        onTap: () async {
                          if (await canLaunchUrlString('https://linkedin.com/company/anaheim-technologies')) {
                            launchUrlString('https://linkedin.com/company/anaheim-technologies');
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SvgPicture.asset(
                              'assets/svg/linkedin.svg',
                              height: 24,
                              color: AppColors.foregroundColor,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            const Text(
                              'linkedin.com/company/anaheim-technologies',
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}