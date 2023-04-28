import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('Privacy policy', style: Theme
                  .of(context)
                  .textTheme
                  .displaySmall,),
              const SizedBox(
                height: 32,
              ),
              const Text(
                  'We are collecting user information for the purpose of identifying users.'),
              RichText(text: TextSpan(text: 'We comply to the ', style: TextStyle(color: Colors.black), children: [
                TextSpan(
                    text: 'Data Privacy Act of 2012',
                    style: const TextStyle(color: Colors.blueAccent),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        const dataPrivacyActUrl = 'https://www.privacy.gov.ph/data-privacy-act/';
                        if (await canLaunchUrlString(dataPrivacyActUrl)) {
                          unawaited(launchUrlString(dataPrivacyActUrl));
                        }
                      }
                )
              ]))
            ],
          ),
        ),
      ),
    );
  }
}