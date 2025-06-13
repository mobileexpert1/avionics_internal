import 'package:avionics_internal/bloc/Subscription/subscription_list_model.dart';
import 'package:equatable/equatable.dart';

import '../../Constants/ApiClass/ApiErrorModel.dart';

enum SubscriptionOption { oneYear, oneMonth }

abstract class SubscriptionState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final CommonApiStatus status;
  final String? errorMessage;

  const SubscriptionState({
    this.isLoading = false,
    this.isSuccess = false,
    this.status = CommonApiStatus.initial,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [isLoading, isSuccess, status, errorMessage];
}

class SubscriptionInitial extends SubscriptionState {
  final String selectedId;
  final List<SubscriptionItemModel> subscriptionList;

  const SubscriptionInitial({
    required this.selectedId,
    this.subscriptionList = const [],
    bool isLoading = false,
    bool isSuccess = false,
    CommonApiStatus status = CommonApiStatus.initial,
    String? errorMessage,
  }) : super(
         isLoading: isLoading,
         isSuccess: isSuccess,
         status: status,
         errorMessage: errorMessage,
       );

  @override
  List<Object?> get props => super.props + [selectedId, subscriptionList];

  SubscriptionInitial copyWith({
    String? selectedId,
    List<SubscriptionItemModel>? subscriptionList,
    bool? isLoading,
    bool? isSuccess,
    CommonApiStatus? status,
    String? errorMessage,
  }) {
    return SubscriptionInitial(
      selectedId: selectedId ?? this.selectedId,
      subscriptionList: subscriptionList ?? this.subscriptionList,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
