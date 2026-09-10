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
  final int totalPages;
  final bool hasNextPage;
  final String currentQuery;

  const MySubscriptionState({
    this.isLoading = false,
    this.isFetchingMore = false,
    this.isSuccess = false,
    this.subscriptionData,
    this.selectedSubscription,
    this.errorMessage,
    this.status = CommonApiStatus.initial,
    this.currentPage = 1,
    this.totalPages = 1,
    this.hasNextPage = true,
    this.currentQuery = '',
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
    int? totalPages,
    bool? hasNextPage,
    String? currentQuery,
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
      totalPages: totalPages ?? this.totalPages,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      currentQuery: currentQuery ?? this.currentQuery,
    );
  }
}
