import 'package:anaheim_technologies_website/utils/color_utils.dart';
import 'package:anaheim_technologies_website/utils/print_utils.dart';
import 'package:anaheim_technologies_website/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    printd('size: $size');
    var rx0Height = size.height * 0.55;
    var reginleifHeight = size.height * 0.4;
    final screenHeight = size.height * 2;
    final screenWidth = size.width;
    var centerPieceHeight = screenHeight * 0.47;
    printd('centerPieceHeight: $centerPieceHeight');

    if (rx0Height > 800) {
      rx0Height = 800.0;
    }

    if (reginleifHeight > 650) {
      reginleifHeight = 650.0;
    }

    if (centerPieceHeight > 954) {
      centerPieceHeight = 954;
    }

    return Scaffold(
      body: WidgetUtils.extendedBackground(
        context: context,
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
              left: -173,
              top: screenHeight * 0.33,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: SvgPicture.asset(
                  'assets/svg/strike-freedom-vector.svg',
                  height: rx0Height,
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
                children: const [
                  Text(
                    'ATO',
                    style: TextStyle(
                      fontFamily: 'Mechsuit',
                      fontSize: 24,
                      color: AppColors.whiteColor,
                    ),
                  ),
                  SizedBox(
                    width: 78,
                  ),
                  Text(
                    'about us',
                    style: TextStyle(
                      fontFamily: 'Plavsky',
                    ),
                  ),
                  SizedBox(
                    width: 68,
                  ),
                  Text(
                    'projects',
                    style: TextStyle(
                      fontFamily: 'Plavsky',
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 90,
              right: screenWidth * 0.08,
              child: const Text(
                'hello@anaheimtechnologies.com',
                style: TextStyle(
                    fontFamily: 'Plavsky', color: AppColors.whiteColor),
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
                onPressed: () => printd('talk to us'),
                style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.foregroundColor,
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    side: const BorderSide(
                      color: AppColors.foregroundColor,
                    )),
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
            Positioned(
              top: screenHeight * 0.3,
              left: screenWidth * 0.15,
              child: SvgPicture.asset(
                'assets/svg/center_piece.svg',
                height: centerPieceHeight,
              ),
            ),
            Positioned(
              top: screenHeight * 0.35,
              left: screenWidth * 0.455,
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
            Positioned(
              top: screenHeight * 0.45,
              left: screenWidth * 0.293,
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
              top: screenHeight * 0.45,
              right: screenWidth * 0.21,
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
              top: screenHeight * 0.6,
              left: screenWidth * 0.2,
              child: const SizedBox(
                width: 250,
                child: Text('Your digital identity is as important as your real-world one. We create your digital identity that emulates your mission.'),
              ),
            ),
            Positioned(
              top: screenHeight * 0.63,
              left: screenWidth * 0.446,
              child: const SizedBox(
                width: 250,
                child: Text('Creating out of nothing is in our DNA. We make mobile, web, desktop applications and IoT prototyping.'),
              ),
            ),
            Positioned(
              top: screenHeight * 0.6,
              left: screenWidth * 0.69,
              child: const SizedBox(
                width: 250,
                child: Text('Making great user experience = more user engagement. We are your partners in making your product speak for your digital identity'),
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.18,
              left: screenWidth * 0.26,
              child: const Text(
                'Are you ready to co-create with us? Let’s connect!',
                style: TextStyle(fontSize: 32),
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.13,
              left: screenWidth * 0.44,
              child: OutlinedButton(
                onPressed: () => printd('talk to us'),
                style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.foregroundColor,
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    side: const BorderSide(
                      color: AppColors.foregroundColor,
                    )),
                child: Row(
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
            Positioned(
              left: screenWidth * 0.1,
              right: screenWidth * 0.06,
              bottom: 56,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
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
                  Row(
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
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}