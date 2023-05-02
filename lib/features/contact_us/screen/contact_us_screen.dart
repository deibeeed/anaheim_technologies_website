import 'package:anaheim_technologies_website/utils/color_utils.dart';
import 'package:anaheim_technologies_website/utils/print_utils.dart';
import 'package:anaheim_technologies_website/utils/widget_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ContactUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var rx0Height = size.height * 0.55;
    var reginleifHeight = size.height * 0.4;
    var strikeFreedomHeight = size.height * 0.62;
    final screenHeight = size.height;
    final screenWidth = size.width;

    if (rx0Height > 800) {
      rx0Height = 800.0;
    }

    if (reginleifHeight > 650) {
      reginleifHeight = 650.0;
    }

    if (strikeFreedomHeight > 635) {
      strikeFreedomHeight = 635;
    }

    return Scaffold(
      body: WidgetUtils.defaultBackground(
        context: context,
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
            // header
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
                alwaysShowIndicator: true,
              ),
            ),
            // content here
            Positioned(
              top: screenHeight * 0.2,
              left: screenWidth * 0.25,
              child: const Text(
                'Talk to us',
                style: TextStyle(fontFamily: 'Mechsuit', fontSize: 16),
              ),
            ),
            Positioned(
              top: screenHeight * 0.28,
              left: screenWidth * 0.25,
              child: Text.rich(
                TextSpan(text: '''
We want to know you more. Please fill out the 
form. Rest assured that we are collecting your
data according to the Data Privacy Act of 2012.

Click ''', children: [
                  TextSpan(
                      text: 'here',
                      style: const TextStyle(
                        color: AppColors.textLinkColor,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          GoRouter.of(context).go('/privacy');
                        }),
                  const TextSpan(
                    text: ' to learn more.',
                  ),
                ]),
              ),
            ),
            Positioned(
                top: screenHeight * 0.42,
                left: screenWidth * 0.25,
                child: SizedBox(
                  width: screenWidth * 0.18,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const TextField(
                        style: TextStyle(color: AppColors.textLinkColor),
                        cursorColor: AppColors.textLinkColor,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.textLinkColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.textLinkColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.textLinkColor,
                            ),
                          ),
                          label: Text(
                            'Full name',
                            style: TextStyle(color: AppColors.textLinkColor),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      const TextField(
                        style: TextStyle(color: AppColors.textLinkColor),
                        cursorColor: AppColors.textLinkColor,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.textLinkColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.textLinkColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.textLinkColor,
                            ),
                          ),
                          label: Text(
                            'Email Address',
                            style: TextStyle(color: AppColors.textLinkColor),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      const TextField(
                        maxLines: 5,
                        style: TextStyle(color: AppColors.textLinkColor),
                        cursorColor: AppColors.textLinkColor,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.textLinkColor,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.textLinkColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.textLinkColor,
                              ),
                            ),
                            label: Text(
                              'Message',
                              style: TextStyle(color: AppColors.textLinkColor),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: 'How can we help you?',
                            hintStyle: TextStyle(color: Color(0xFF49454F))),
                      ),
                      const SizedBox(
                        height: 56,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => printd('Submit!!'),
                          child: const Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('Send'),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textLinkColor,
                            backgroundColor: AppColors.gradientBottom,
                            padding: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32)),
                            side: const BorderSide(
                              color: AppColors.textLinkColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
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
    );
  }
}
