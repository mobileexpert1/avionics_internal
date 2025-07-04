import 'package:equatable/equatable.dart';

class ComparisonState extends Equatable {
  final List<String> labels;
  final List<String> a321Values;
  final List<String> a322Values;
  final bool isLoading;

  const ComparisonState({
    required this.labels,
    required this.a321Values,
    required this.a322Values,
    this.isLoading = false,
  });

  @override
  List<Object> get props => [labels, a321Values, a322Values,isLoading];
}
