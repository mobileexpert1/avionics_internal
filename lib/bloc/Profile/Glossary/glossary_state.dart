import 'package:equatable/equatable.dart';
import 'glossary_model.dart';


class GlossaryState extends Equatable {
  final Map<String, List<GlossaryItem>> glossaryData;

  const GlossaryState({required this.glossaryData});

  @override
  List<Object?> get props => [glossaryData];
}
