import 'package:avionics_internal/bloc/Profile/ContactSupport/contactsupport_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'contactsupport_model.dart';
import 'contactsupport_state.dart';

class ContactSupportCubit extends Cubit<ContactSupportState> {
  ContactSupportCubit()
      : super(const ContactSupportState());

  void updateEmail(String email) {
    emit(state.copyWith(email: email));
  }

  void updateMessage(String message) {
    emit(state.copyWith(message: message));
  }

  bool isValidEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  Future<void> submitSupport(BuildContext context) async {
    if (!isValidEmail(state.email) || state.message.isEmpty) return;

    emit(state.copyWith(isSubmitting: true));

    final contact = ContactSupportModel(
      email: state.email,
      description: state.message,
    );

    try {
      await ContactSupportRepository().submitContactSupport(contact);
      emit(state.copyWith(
        isSubmitting: false,
        submissionSuccess: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        submissionSuccess: false,
      ));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
}
