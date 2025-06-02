enum SubscriptionOption { oneYear, oneMonth }

abstract class SubscriptionState  {
  const SubscriptionState();

  @override
  List<Object?> get props => [];
}

class SubscriptionInitial extends SubscriptionState {
  final SubscriptionOption selectedOption;

  const SubscriptionInitial({this.selectedOption = SubscriptionOption.oneYear});

  @override
  List<Object?> get props => [selectedOption];

  SubscriptionInitial copyWith({
    SubscriptionOption? selectedOption,
  }) {
    return SubscriptionInitial(
      selectedOption: selectedOption ?? this.selectedOption,
    );
  }
}
