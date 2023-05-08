import 'package:anaheim_technologies_website/utils/color_utils.dart';
import 'package:anaheim_technologies_website/utils/print_utils.dart';
import 'package:anaheim_technologies_website/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;

import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var rx0Height = size.height * 0.55;
    var strikeFreedomHeight = size.height * 0.62;
    var reginleifHeight = size.height * 0.4;
    var screenHeight = size.height * 2;
    var screenWidth = size.width;
    var centerPieceHeight = screenHeight * 0.47;

    if (rx0Height > 800) {
      rx0Height = 800.0;
    }

    if (reginleifHeight > 650) {
      reginleifHeight = 650.0;
    }

    if (centerPieceHeight > 954) {
      centerPieceHeight = 954;
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

    printd('screenHeight: $screenHeight, screenWidth: $screenWidth');

    return Scaffold(
      body: WidgetUtils.extendedBackground(
        context: context,
        height: screenHeight,
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
                  top: screenHeight * 0.32,
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
                  right: -screenHeight * 0.18,
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
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 80,
                  right: screenWidth * 0.08,
                  child: const HoveredText(
                    text: 'hello@anaheimtechnologies.com',
                    textStyle: TextStyle(
                        fontFamily: 'Plavsky', color: AppColors.whiteColor),
                    navigateTo: '/hello',
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.12,
                  left: screenWidth * 0.22,
                  child: const Text(
                    'Ideas - \nDelivered.',
                    style: TextStyle(
                        fontFamily: 'Plavsky',
                        color: AppColors.whiteColor,
                        fontSize: 56),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.22,
                  left: screenWidth * 0.22,
                  child: OutlinedButton(
                    onPressed: () => GoRouter.of(context).go('/hello'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.foregroundColor,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      side: const BorderSide(
                        color: AppColors.foregroundColor,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text('Talk to us',
                            style: GoogleFonts.notoSans(fontSize: 16)),
                        const SizedBox(
                          width: 8,
                        ),
                        const Icon(
                          Icons.arrow_right_alt,
                          color: AppColors.foregroundColor,
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: SvgPicture.asset(
                    'assets/svg/center_piece.svg',
                    height: centerPieceHeight,
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.32,
                  child: SizedBox(
                    width: screenWidth,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            'Full stack',
                            style: TextStyle(fontFamily: 'Plavsky'),
                          ),
                          Text(
                            'Development',
                            style: TextStyle(fontFamily: 'Plavsky', fontSize: 32),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.42,
                  left: screenWidth * 0.325,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Comprehensive',
                        style: TextStyle(fontFamily: 'Plavsky'),
                      ),
                      Text(
                        'Branding',
                        style: TextStyle(fontFamily: 'Plavsky', fontSize: 32),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.42,
                  left: screenWidth * 0.575,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Product design and development',
                        style: TextStyle(fontFamily: 'Plavsky'),
                      ),
                      Text(
                        'Design',
                        style: TextStyle(fontFamily: 'Plavsky', fontSize: 32),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.58,
                  left: screenWidth * 0.26,
                  child: const SizedBox(
                    width: 250,
                    child: Text(
                        'Your digital identity is as important as your real-world one. We create your digital identity that emulates your mission.'),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.61,
                  child: SizedBox(
                    width: screenWidth,
                    child: const Center(
                      child: SizedBox(
                        width: 250,
                        child: Text(
                            'Creating out of nothing is in our DNA. We make mobile, web, desktop applications and IoT prototyping.'),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.58,
                  left: screenWidth * 0.62,
                  child: const SizedBox(
                    width: 250,
                    child: Text(
                        'Making great user experience = more user engagement. We are your partners in making your product speak for your digital identity'),
                  ),
                ),
                Positioned(
                  bottom: screenHeight * 0.18,
                  child: SizedBox(
                    width: screenWidth,
                    child: const Center(
                      child: Text(
                        'Are you ready to co-create with us? Let’s connect!',
                        style: TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: screenHeight * 0.13,
                  child: SizedBox(
                    width: screenWidth,
                    child: Center(
                      child: OutlinedButton(
                        onPressed: () => GoRouter.of(context).go('/hello'),
                        style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.foregroundColor,
                            padding: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                            side: const BorderSide(
                              color: AppColors.foregroundColor,
                            )),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Talk to us today!',
                                style: GoogleFonts.notoSans(fontSize: 16)),
                            const SizedBox(
                              width: 8,
                            ),
                            const Icon(
                              Icons.arrow_right_alt,
                              color: AppColors.foregroundColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // footer
                Positioned(
                  left: screenWidth * 0.1,
                  right: screenWidth * 0.06,
                  bottom: 56,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () async {
                          if (await canLaunchUrlString(
                              'https://fb.com/anaheim.technologies')) {
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
                          if (await canLaunchUrlString(
                              'https://linkedin.com/company/anaheim-technologies')) {
                            launchUrlString(
                                'https://linkedin.com/company/anaheim-technologies');
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
