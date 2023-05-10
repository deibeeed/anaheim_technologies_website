import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

part 'contact_us_event.dart';

part 'contact_us_state.dart';

class ContactUsBloc extends Bloc<ContactUsEvent, ContactUsState> {
  ContactUsBloc() : super(ContactUsInitial()) {
    // on<ContactUsEvent>((event, emit) {
    //   // TODO: implement event handler
    // });
    on(_handleSendEmailEvent);
  }

  final log = Logger('contact_us_bloc.dart');

  bool _isSendingEmail = false;

  bool get isSendingEmail => _isSendingEmail;

  String get _firestore_collection_prefix {
    const env = String.fromEnvironment('ENVIRONMENT');

    if (env == 'development') {
      return 'dev_';
    }

    return '';
  }

  Future<void> _handleSendEmailEvent(
    SendEmailEvent event,
    Emitter<ContactUsState> emit,
  ) async {
    try {
      _isSendingEmail = true;
      emit(ContactUsLoadingState(isLoading: true));

      // store data in firestore
      await FirebaseFirestore.instance
          .collection('${_firestore_collection_prefix}inquiries')
          .add({
        'email_address': event.email,
        'full_name': event.fullName,
        'message': event.message,
        'inquired_on': DateTime.now().millisecondsSinceEpoch
      });

      _isSendingEmail = false;
      emit(ContactUsLoadingState());
      emit(ContactUsSuccessState());
    } catch (err) {
      emit(ContactUsLoadingState());
      log.severe('Something went wrong while sending emails: $err');
      emit(ContactUsErrorState(
        message: 'Something went wrong while sending emails',
      ));
    }
  }

  void sendEmail({
    required String email,
    required String fullName,
    required String message,
  }) {
    if (email.isEmpty || fullName.isEmpty || message.isEmpty) {
      emit(ContactUsErrorState(message: 'Please fill up all fields'));
      return;
    }

    add(SendEmailEvent(email: email, fullName: fullName, message: message));
  }
}
