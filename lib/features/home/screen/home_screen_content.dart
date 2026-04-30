import 'package:anaheim_technologies_website/features/home/cubit/service_select_cubit.dart';
import 'package:anaheim_technologies_website/utils/color_utils.dart';
import 'package:anaheim_technologies_website/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomeScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                flex: 3,
                child: Text(
                  'We turn ideas into shipped products — web, mobile, cloud, and hardware when the product needs to live in the physical world. A specialist studio with the depth of a small team. Founder-friendly, senior by default.',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ),
              if (Constants.isExpandedScreen) ...[
                Expanded(
                  child: Container(),
                ),
                const Text(
                  '''Ideas -
Delivered''',
                  style: TextStyle(
                      fontFamily: 'Plavsky', color: Colors.white, fontSize: 48),
                ),
              ],
            ],
          ),
          if (!Constants.isExpandedScreen)
            const SizedBox(
              width: double.infinity,
              child: Text(
                '''Ideas -
Delivered''',
                style: TextStyle(
                    fontFamily: 'Plavsky', color: Colors.white, fontSize: 48),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 48),
            child: Row(
              children: [
                FilledButton(
                  onPressed: () {
                    GoRouter.of(context).go('/services');
                  },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 24,
                    ),
                    backgroundColor: AppColors.textLinkColor,
                  ),
                  child: const Text(
                    'Our services',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.gradientBottom,
                    ),
                  ),
                ),
                const Gap(16),
                OutlinedButton(
                  onPressed: () {
                    GoRouter.of(context).go('/contact');
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 24,
                    ),
                    foregroundColor: AppColors.textLinkColor,
                    side: const BorderSide(
                      color: AppColors.textLinkColor,
                    ),
                  ),
                  child: const Text(
                    'Contact us',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 96,
            ),
            child: DecoratedBox(
              decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                  color: AppColors.textLinkColor,
                )),
              ),
              child: BlocBuilder<ServiceSelectCubit, int>(
                builder: _buildServiceMenu,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 56,
            ),
            child: BlocBuilder<ServiceSelectCubit, int>(
              builder: (context, state) {
                // var text =
                //     'Your digital identity is as important as your real-world one. We create your digital identity that emulates your mission.';
                //
                // if (state == 1) {
                //   text =
                //   'Creating out of nothing is in our DNA. We make mobile, web, desktop applications in all screens and IoT prototyping, making great user experience and more user engagement.\n\nWe are your partners in making your product speak for your digital identity. ';
                // }

                final text = switch (state) {
                  0 =>
                    'Your brand is the first thing customers see and the last thing they remember. We design digital identities that look the part and hold up under scale — logo, color, typography, motion, and the system that ties them all together.',
                  1 =>
                    "From napkin sketch to production. We design and build mobile apps, web platforms, and cloud backends — and when the product needs to live in the physical world, we prototype the hardware too. Most studios stop at one of those. We don't.",
                  2 =>
                    'Building a team is hard. We help you skip the talent-acquisition slog — sourcing, technical vetting, onboarding — and stay on as the engineering layer that keeps everything moving. Your culture stays yours. The hiring pain becomes ours.',
                  _ => ''
                };

                return Text(
                  text,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(
              top: 96,
            ),
            child: Text(
              'Are you ready to co-create with us?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Plavsky',
                fontSize: 32,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(
              top: 24,
            ),
            child: Text(
              'We are excited to work with you!',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 48,
            ),
            child: OutlinedButton(
              onPressed: () async {
                const bookingsUrl = 'https://bit.ly/CallATO';
                if (await canLaunchUrlString(bookingsUrl)) {
                  await launchUrlString(bookingsUrl);
                }
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 24,
                ),
                foregroundColor: AppColors.textLinkColor,
                side: const BorderSide(
                  color: AppColors.textLinkColor,
                ),
              ),
              child: const Text(
                'Talk to us today',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 96),
            child: Column(
              children: const [
                Text(
                  'CURRENTLY BUILDING',
                  style: TextStyle(
                    color: AppColors.textLinkColor,
                    fontSize: 14,
                    letterSpacing: 2,
                  ),
                ),
                Gap(16),
                Text(
                  'Loooans',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Plavsky',
                    fontSize: 32,
                    color: Colors.white,
                  ),
                ),
                Gap(12),
                Text(
                  'The first product on our fintech stack. Now in closed beta.\nWe dogfood every stack we recommend.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
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
                      launchUrlString('https://fb.com/anaheim.technologies');
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
    );
  }

  Widget _buildServiceMenu(BuildContext context, int state) {
    final screenWidth = MediaQuery.of(context).size.width;

    final buttons = [
      FilledButton(
        onPressed: () {
          context.read<ServiceSelectCubit>().selectBranding();
        },
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 24,
          ),
          backgroundColor:
              state == 0 ? AppColors.textLinkColor : Colors.transparent,
          foregroundColor:
              state == 0 ? AppColors.gradientBottom : AppColors.textLinkColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          )),
        ),
        child: const Text(
          'Branding',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
      FilledButton(
        onPressed: () {
          context.read<ServiceSelectCubit>().selectPdd();
        },
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 24,
          ),
          backgroundColor:
              state == 1 ? AppColors.textLinkColor : Colors.transparent,
          foregroundColor:
              state == 1 ? AppColors.gradientBottom : AppColors.textLinkColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          )),
        ),
        child: const Text(
          'Product Design, Development and Prototyping',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
      FilledButton(
        onPressed: () {
          context.read<ServiceSelectCubit>().selectVt();
        },
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 24,
          ),
          backgroundColor:
              state == 2 ? AppColors.textLinkColor : Colors.transparent,
          foregroundColor:
              state == 2 ? AppColors.gradientBottom : AppColors.textLinkColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          )),
        ),
        child: const Text(
          'Virtual Teams',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
    ];

    if (!Constants.isExpandedScreen || screenWidth < 1000) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: buttons[0],
          ),
          SizedBox(
            width: double.infinity,
            child: buttons[1],
          ),
          SizedBox(
            width: double.infinity,
            child: buttons[2],
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons,
    );
  }
}
