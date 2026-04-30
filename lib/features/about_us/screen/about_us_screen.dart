import 'package:anaheim_technologies_website/utils/color_utils.dart';
import 'package:anaheim_technologies_website/utils/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final children = [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'About us',
            style: TextStyle(fontFamily: 'Mechsuit', fontSize: 24),
          ),
          const SizedBox(
            height: 32,
          ),
          Text.rich(
            TextSpan(
                text:
                '''Anaheim Technologies is a specialist product studio — small by design, senior by default. We turn ideas into shipped products: web, mobile, cloud, and hardware when the product needs to live in the physical world.

13+ years of engineering depth. Ex-GlacierGrid (YC-backed IoT). The work most agencies spread across a team of five, we deliver through deep technical concentration.

Who we work with:

→ Founders with an idea but no engineering team. We help you decide what to build, then we build it. v1 in your hands, not on a roadmap.

→ SMBs going digital — the kind that need software but don't want to hire a full-time CTO yet. We become yours, fractionally.

Currently building Loooans — the first product on our fintech stack, now in closed beta. We dogfood every stack we recommend. Even this website is written in Flutter. We don't sell what we don't ship.

Let's build something. ''',
                style: const TextStyle(
                  height: 1.5,
                  fontSize: 16,
                ),
                children: [
                  TextSpan(
                      text: 'Talk to us today!',
                      style: const TextStyle(
                        color: AppColors.textLinkColor,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          GoRouter.of(context).go('/contact');
                        })
                ]),
          ),
        ],
      ),
      SizedBox(
        height: 500,
        child: Wrap(
          spacing: 32,
          alignment: WrapAlignment.spaceEvenly,
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: 32,
          children: [
            'flutter_logo.svg',
            'dart_logo.svg',
            'firebase_logo.svg',
            'gcp_logo_full.svg',
            'golang_logo.svg',
            'java_logo_full.svg',
            'kotlin_logo.svg',
            'nodejs_logo.svg',
            'python_logo.svg',
            'swift_logo.svg',
            'typescript_logo.svg',
            'cpp_logo.svg',
            'gcp_iot_core_log.svg',
            'lorawan_logo_dark.svg',
          ].map((e) => SvgPicture.asset('assets/svg/$e', height: 56,)).toList(),
        ),
      ),
    ];

    return LayoutBuilder(builder: (context, constraints) {

      return SingleChildScrollView(
        child: Constants.isExpandedScreen ? Row(
          children: [
            Expanded(
              child: children[0],
            ),
            const Gap(32),
            Expanded(
              child: children[1],)
          ],
        ) : Column(
          children: [
            children[0],
            const Gap(32),
            children[1],
          ],
        ),
      );
    });
  }
}
