part of 'contact_us_bloc.dart';

@immutable
abstract class ContactUsState {}

class ContactUsInitial extends ContactUsState {}

class ContactUsLoadingState extends ContactUsState {
  final bool isLoading;
  final String? message;

  ContactUsLoadingState({ this.isLoading = false, this.message, });
}

class ContactUsSuccessState extends ContactUsState {
  final String? message;
  final dynamic data;

  ContactUsSuccessState({ this.message, this.data, });
}

class ContactUsErrorState extends ContactUsState {
  final String message;
  final dynamic data;

  ContactUsErrorState({ required this.message, this.data, });
}
