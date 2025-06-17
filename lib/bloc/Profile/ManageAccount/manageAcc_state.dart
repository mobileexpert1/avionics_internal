import 'package:equatable/equatable.dart';
import '../../../Constants/ApiClass/ApiErrorModel.dart';

class ManageAccState extends Equatable {
  final String firstName;
  final String lastName;
  final String email;

  final String? firstNameError;
  final String? lastNameError;
  final String? emailError;

  final bool isButtonEnabled;

  final bool isLoading;
  final bool isSuccess;
  final CommonApiStatus status;
  final String? errorMessage;

  const ManageAccState({
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.firstNameError,
    this.lastNameError,
    this.emailError,
    this.isButtonEnabled = false,
    this.isLoading = false,
    this.isSuccess = false,
    this.status = CommonApiStatus.initial,
    this.errorMessage,
  });

  ManageAccState copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? firstNameError,
    String? lastNameError,
    String? emailError,
    bool? isButtonEnabled,
    bool? isLoading,
    bool? isSuccess,
    CommonApiStatus? status,
    String? errorMessage,
  }) {
    return ManageAccState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      firstNameError: firstNameError ?? this.firstNameError,
      lastNameError: lastNameError ?? this.lastNameError,
      emailError: emailError ?? this.emailError,
      isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    firstNameError,
    lastNameError,
    emailError,
    isButtonEnabled,
    isLoading,
    isSuccess,
    status,
    errorMessage,
  ];
}
