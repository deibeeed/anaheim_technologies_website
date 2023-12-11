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

    return MasterDetailScreen(
      title: 'Projects',
      titleList: [
        'BPV Loan Monitoring',
        '[PROTOTYPE] HLP Systems',
      ],
      narrativeList: [
        '''BPV Loan monitoring is a loan monitoring application created specific for the needs of Baybay Property Ventures Corp.

The application is an internal company application that monitors the loan of their customers. Providing real time posting of payments when the customer pays.

The application also tracks lots to determine which lots are sold and which are not.

Want to learn more about the application andhow we can help you? ''',
        '''This customer, thru a mutual connection, was having problems with his collections and
remittances. Not because there’s a lack of resources, but because of human intended errors.

The solution: Integrity, Accountability and Security.

We created an application of interconnected systems that will help the customer monitor and take actions to the accountable.

Want to learn more about the application and how we can help you? '''
      ],
      detailList: [
        SizedBox(
          height: size.height * 0.45,
          width: size.width * 0.3,
          child: Stack(
            children: [
              Image.asset(
                'assets/images/pic1.png',
                height: size.height * 0.18,
              ),
              Positioned(
                top: size.height * 0.1,
                left: size.width * 0.14,
                child: Image.asset(
                  'assets/images/pic2.png',
                  height: size.height * 0.2,
                ),
              ),
              Positioned(
                top: size.height * 0.23,
                child: Image.asset(
                  'assets/images/pic3.png',
                  height: size.height * 0.18 ,
                ),
              ),
            ],
          ),
        ),
        SvgPicture.asset(
          'assets/svg/3d-model.svg',
          colorFilter: const ColorFilter.mode(
            AppColors.textLinkColor,
            BlendMode.srcIn,
          ),
        )
      ],
    );
  }

}