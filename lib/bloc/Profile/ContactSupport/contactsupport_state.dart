import 'package:equatable/equatable.dart';
import '../../../Constants/ApiClass/ApiErrorModel.dart';

class ContactSupportState extends Equatable {
  final String email;
  final bool isEmailValid;
  final String message;
  final bool isSubmitting;
  final bool submissionSuccess;
  final bool isLoading;
  final bool isSuccess;
  final CommonApiStatus status;
  final String? errorMessage;

  const ContactSupportState({
    this.email = '',
    this.isEmailValid = true,
    this.message = '',
    this.isSubmitting = false,
    this.submissionSuccess = false,
    this.isLoading = false,
    this.isSuccess = false,
    this.status = CommonApiStatus.initial,
    this.errorMessage,
  });

  ContactSupportState copyWith({
    String? email,
    bool? isEmailValid,
    String? message,
    bool? isSubmitting,
    bool? submissionSuccess,
    bool? isLoading,
    bool? isSuccess,
    CommonApiStatus? status,
    String? errorMessage,
  }) {
    return ContactSupportState(
      email: email ?? this.email,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      message: message ?? this.message,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submissionSuccess: submissionSuccess ?? this.submissionSuccess,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    email,
    isEmailValid,
    message,
    isSubmitting,
    submissionSuccess,
    isLoading,
    isSuccess,
    status,
    errorMessage,
  ];
}
