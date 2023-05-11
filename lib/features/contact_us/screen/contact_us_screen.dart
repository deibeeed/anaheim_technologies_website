import 'package:anaheim_technologies_website/features/contact_us/bloc/contact_us_bloc.dart';
import 'package:anaheim_technologies_website/utils/color_utils.dart';
import 'package:anaheim_technologies_website/utils/print_utils.dart';
import 'package:anaheim_technologies_website/utils/widget_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ContactUsScreen extends StatelessWidget {
  ContactUsScreen({super.key});

  final emailTextController = TextEditingController();
  final fullNameTextController = TextEditingController();
  final messageTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final contactUsBloc = BlocProvider.of<ContactUsBloc>(context);
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
      body: BlocListener<ContactUsBloc, ContactUsState>(
        listener: (context, state) {
          if (state is ContactUsErrorState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is ContactUsSuccessState) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: AppColors.gradientBottom,
                  title: const Text(
                    'We received your message!',
                    style: TextStyle(color: AppColors.textLinkColor),
                  ),
                  content: const Text(
                      'Thank you for your message\nOur team will get back to you as soon.',
                      style: TextStyle(color: AppColors.textLinkColor)),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        child: const Text('OK',
                            style: TextStyle(color: AppColors.textLinkColor)))
                  ],
                );
              },
            );
          }
        },
        child: WidgetUtils.defaultBackground(
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
                      top: screenHeight * 0.15,
                      left: screenWidth * 0.25,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Talk to us',
                            style:
                                TextStyle(fontFamily: 'Mechsuit', fontSize: 16),
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          Text.rich(
                            TextSpan(text: '''
We want to know you more. Please fill out the 
form. Rest assured that we are collecting your
data according to the Data Privacy Act of 2012.

Click ''', style: TextStyle(height: 1.5), children: [
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
                          const SizedBox(
                            height: 32,
                          ),
                          SizedBox(
                            width: screenWidth * 0.18,
                            child: BlocBuilder<ContactUsBloc, ContactUsState>(
                              builder: (context, state) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      style: const TextStyle(
                                        color: AppColors.textLinkColor,
                                      ),
                                      enabled: !contactUsBloc.isSendingEmail,
                                      controller: fullNameTextController,
                                      cursorColor: AppColors.textLinkColor,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppColors.textLinkColor,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColors.textLinkColor),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppColors.textLinkColor,
                                          ),
                                        ),
                                        label: Text(
                                          'Full name',
                                          style: TextStyle(
                                              color: AppColors.textLinkColor),
                                        ),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 32,
                                    ),
                                    TextField(
                                      style: const TextStyle(
                                        color: AppColors.textLinkColor,
                                      ),
                                      enabled: !contactUsBloc.isSendingEmail,
                                      controller: emailTextController,
                                      cursorColor: AppColors.textLinkColor,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppColors.textLinkColor,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColors.textLinkColor),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppColors.textLinkColor,
                                          ),
                                        ),
                                        label: Text(
                                          'Email Address',
                                          style: TextStyle(
                                              color: AppColors.textLinkColor),
                                        ),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 32,
                                    ),
                                    TextField(
                                      maxLines: 5,
                                      enabled: !contactUsBloc.isSendingEmail,
                                      style: const TextStyle(
                                          color: AppColors.textLinkColor),
                                      controller: messageTextController,
                                      cursorColor: AppColors.textLinkColor,
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: AppColors.textLinkColor,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: AppColors.textLinkColor),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: AppColors.textLinkColor,
                                            ),
                                          ),
                                          label: Text(
                                            'Message',
                                            style: TextStyle(
                                                color: AppColors.textLinkColor),
                                          ),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                          hintText: 'How can we help you?',
                                          hintStyle: TextStyle(
                                              color: Color(0xFF49454F))),
                                    ),
                                    const SizedBox(
                                      height: 56,
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: OutlinedButton(
                                        onPressed: () => contactUsBloc
                                                .isSendingEmail
                                            ? null
                                            : contactUsBloc.sendEmail(
                                                email: emailTextController.text,
                                                fullName:
                                                    fullNameTextController.text,
                                                message:
                                                    messageTextController.text,
                                              ),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor:
                                              AppColors.textLinkColor,
                                          backgroundColor:
                                              AppColors.gradientBottom,
                                          padding: const EdgeInsets.all(16),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(32)),
                                          side: const BorderSide(
                                            color: AppColors.textLinkColor,
                                          ),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Text('Send'),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
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
                              launchUrlString(
                                  'https://fb.com/anaheim.technologies');
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
      ),
    );
  }
}
