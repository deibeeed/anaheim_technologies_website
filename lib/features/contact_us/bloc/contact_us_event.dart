part of 'contact_us_bloc.dart';

@immutable
abstract class ContactUsEvent {}

class SendEmailEvent extends ContactUsEvent {
  final String email;
  final String fullName;
  final String message;

  SendEmailEvent({
    required this.email,
    required this.fullName,
    required this.message,
  });
}
