import 'package:avionics_internal/bloc/Profile/MySubscription/my_subscription_model.dart';
import '../../../Constants/ApiClass/ApiErrorModel.dart';

class MySubscriptionState {
  final bool isLoading;
  final bool isSuccess;
  final MySubscriptionResponseModel? subscriptionData;
  final MySubscriptionItem? selectedSubscription;
  final String? errorMessage;
  final CommonApiStatus status;

  const MySubscriptionState({
    this.isLoading = false,
    this.isSuccess = false,
    this.subscriptionData,
    this.selectedSubscription,
    this.errorMessage,
    this.status = CommonApiStatus.initial,
  });

  MySubscriptionState copyWith({
    bool? isLoading,
    bool? isSuccess,
    MySubscriptionResponseModel? subscriptionData,
    MySubscriptionItem? selectedSubscription,
    String? errorMessage,
    CommonApiStatus? status,
  }) {
    return MySubscriptionState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      subscriptionData: subscriptionData ?? this.subscriptionData,
      selectedSubscription: selectedSubscription ?? this.selectedSubscription,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
    );
  }
}
