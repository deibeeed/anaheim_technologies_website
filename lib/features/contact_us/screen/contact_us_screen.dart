import 'package:anaheim_technologies_website/features/contact_us/bloc/contact_us_bloc.dart';
import 'package:anaheim_technologies_website/utils/color_utils.dart';
import 'package:anaheim_technologies_website/utils/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';

class ContactUsScreen extends StatelessWidget {
  ContactUsScreen({super.key});

  final emailTextController = TextEditingController();
  final fullNameTextController = TextEditingController();
  final messageTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final contactUsBloc = BlocProvider.of<ContactUsBloc>(context);

    return BlocListener<ContactUsBloc, ContactUsState>(
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
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Talk to us',
              style: TextStyle(fontFamily: 'Mechsuit', fontSize: 24),
            ),
            const SizedBox(
              height: 32,
            ),
            Text.rich(
              TextSpan(
                  text:
                      'We want to know you more. Please fill out the form. Rest assured that we are collecting your data according to the Data Privacy Act of 2012.\n\nClick ',
                  style: TextStyle(height: 1.5),
                  children: [
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
              width: !Constants.isExpandedScreen ? double.infinity : 350,
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
                      TextField(
                        maxLines: 5,
                        enabled: !contactUsBloc.isSendingEmail,
                        style: const TextStyle(color: AppColors.textLinkColor),
                        controller: messageTextController,
                        cursorColor: AppColors.textLinkColor,
                        decoration: const InputDecoration(
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
                          onPressed: () => contactUsBloc.isSendingEmail
                              ? null
                              : contactUsBloc.sendEmail(
                                  email: emailTextController.text,
                                  fullName: fullNameTextController.text,
                                  message: messageTextController.text,
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
        ),
      ),
    );
  }
}
