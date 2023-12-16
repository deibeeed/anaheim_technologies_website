import 'package:anaheim_technologies_website/features/projects/screen/projects_content_screen.dart';
import 'package:anaheim_technologies_website/utils/color_utils.dart';
import 'package:anaheim_technologies_website/utils/constants.dart';
import 'package:anaheim_technologies_website/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var screenHeight = size.height;
    var screenWidth = size.width;

    final pddNarrative =
        '''Imagine you have a great app idea that you want to bring to market. Our team specializes in helping you turn your idea into a tangible product by working with you every step of the way.

We begin by getting a deep understanding of your product idea and your target audience. From there, we use our expertise in app design to create a customized solution that meets your specifications and requirements.

Throughout the entire process, we keep you informed and involved. We provide regular updates and seek your input on important decisions to ensure that the final product meets your vision and goals.

In the end, we deliver a finished app that is user-friendly, functional, and meets the needs of your target market. Whether you're launching a new startup or expanding an existing product line, our team is here to help you realize your app idea.''';

    final prototypingNarrative =
        '''Are you a business looking to implement IoT technology into your operations? At our company, we specialize in IoT prototyping and development, helping you turn your vision into a reality.

We start by getting a deep understanding of your business needs and goals. From there, we use our expertise in IoT technology to create a customized solution that meets your specific requirements.

Our team of experts is equipped with the latest tools and technologies to design and develop connected devices, sensors, and applications that integrate seamlessly with your business processes.

Throughout the entire process, we keep you informed and involved, seeking your input on important decisions to ensure that the final product meets your vision and goals.

In the end, we deliver a functional IoT solution that is tailored to your unique business needs, providing you with the necessary tools and insights to optimize your operations, increase efficiency, and enhance customer satisfaction.

Whether you're looking to improve your supply chain management, streamline your manufacturing processes, or create innovative products for your customers, we have the experience and expertise to help you achieve your IoT goals.''';

    final virtualTeamsNarrative =
        '''At our company, we understand that businesses today are looking for more flexible and cost-effective ways to expand their capabilities. That's why we offer virtual teams as a service, providing businesses with access to top talents.

Our virtual teams are customized to meet your specific business needs and goals. We work with you to identify the skills and expertise required and then build a team that is optimized for your requirements.

Our virtual team services include everything from talent acquisition and onboarding to ongoing management and support. Our team is equipped with the latest technology and communication tools, enabling seamless collaboration and productivity regardless of physical location.

With our virtual team services, businesses can expand their capabilities and take advantage of new opportunities without the need for physical office space or equipment. Our turnkey solution takes the hassle out of building and managing a remote workforce, enabling businesses to focus on their core operations.

At our company, we believe that virtual teams are the future of work. We help businesses build and manage remote workforces that are optimized for success, providing the flexibility and scalability needed to thrive in today's rapidly changing business environment.''';

    if (!Constants.isExpandedScreen) {
      return MasterDetailScreen(
        detailListPaddingTop: screenHeight * 0.03,
        showAllTitleList: false,
        title: 'Services',
        titleList: const [
          'Product design and development',
          'Prototyping',
          'Virtual teams',
        ],
        filledIndicator: true,
        narrativeList: [
          pddNarrative,
          prototypingNarrative,
          virtualTeamsNarrative,
        ],
        detailList: [],
      );
    }

    return MasterDetailScreen(
      detailListPaddingTop: screenHeight * 0.03,
      showAllTitleList: true,
      title: 'Services',
      titleList: const [
        'Product design and development',
        'Prototyping',
        'Virtual teams',
      ],
      filledIndicator: true,
      detailList: [
        SizedBox(
          width: screenWidth * 0.3,
          child: WidgetUtils.showDetailNarrative(
            context: context,
            detailText: pddNarrative,
          ),
        ),
        SizedBox(
          width: screenWidth * 0.3,
          child: WidgetUtils.showDetailNarrative(
            context: context,
            detailText: prototypingNarrative,
          ),
        ),
        SizedBox(
          width: screenWidth * 0.3,
          child: WidgetUtils.showDetailNarrative(
            context: context,
            detailText: virtualTeamsNarrative,
          ),
        ),
      ],
    );
  }
}
