// Define the subscription options
enum SubscriptionOption {
  oneYear,
  oneMonth,
}

abstract class SubscriptionState {
  const SubscriptionState(); // Make the constructor const

  @override
  List<Object?> get props => []; // Empty props for the base class
}

class SubscriptionInitial extends SubscriptionState {
  final SubscriptionOption selectedOption;

  const SubscriptionInitial({this.selectedOption = SubscriptionOption.oneYear}); // Make constructor const

  @override
  List<Object?> get props => [selectedOption]; // Define props for comparison

  SubscriptionInitial copyWith({
    SubscriptionOption? selectedOption,
  }) {
    return SubscriptionInitial(
      selectedOption: selectedOption ?? this.selectedOption,
    );
  }
}