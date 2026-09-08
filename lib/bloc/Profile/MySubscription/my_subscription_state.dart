import '../../../Constants/ApiClass/ApiErrorModel.dart';
import 'my_subscription_model.dart';

class MySubscriptionState {
  final bool isLoading;
  final bool isFetchingMore;
  final bool isSuccess;

  final MySubscriptionResponseModel? subscriptionData;
  final MySubscriptionItem? selectedSubscription;

  final String? errorMessage;
  final CommonApiStatus status;

  final int currentPage;
  final bool hasNextPage;

  const MySubscriptionState({
    this.isLoading = false,
    this.isFetchingMore = false,
    this.isSuccess = false,
    this.subscriptionData,
    this.selectedSubscription,
    this.errorMessage,
    this.status = CommonApiStatus.initial,
    this.currentPage = 1,
    this.hasNextPage = true,
  });

  MySubscriptionState copyWith({
    bool? isLoading,
    bool? isFetchingMore,
    bool? isSuccess,
    MySubscriptionResponseModel? subscriptionData,
    MySubscriptionItem? selectedSubscription,
    String? errorMessage,
    CommonApiStatus? status,
    int? currentPage,
    bool? hasNextPage,
  }) {
    return MySubscriptionState(
      isLoading: isLoading ?? this.isLoading,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      isSuccess: isSuccess ?? this.isSuccess,
      subscriptionData: subscriptionData ?? this.subscriptionData,
      selectedSubscription: selectedSubscription ?? this.selectedSubscription,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
      currentPage: currentPage ?? this.currentPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
    );
  }
}
