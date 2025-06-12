import 'package:avionics_internal/bloc/Subscription/subscription_list_model.dart';
import 'package:equatable/equatable.dart';

import '../../Constants/ApiClass/ApiErrorModel.dart';

enum SubscriptionOption { oneYear, oneMonth }

abstract class SubscriptionState extends Equatable {
  const SubscriptionState();

  @override
  List<Object?> get props => [];
}

class SubscriptionInitial extends SubscriptionState {
  final String selectedId;
  final List<SubscriptionItemModel> subscriptionList;
  final bool isLoading;
  final bool isSuccess;
  final CommonApiStatus status;
  final String? errorMessage;

  const SubscriptionInitial({
    required this.selectedId,
    this.subscriptionList = const [],
    this.isLoading = false,
    this.isSuccess = false,
    this.status = CommonApiStatus.initial,
    this.errorMessage,
  });

  @override
  List<Object?> get props =>
      [selectedId, subscriptionList, isLoading, isSuccess, status, errorMessage];

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
