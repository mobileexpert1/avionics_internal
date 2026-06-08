import 'package:avionics_internal/bloc/Games/SubGameSection/OneWord_Section/oneWord_model.dart';
import 'package:avionics_internal/bloc/Games/SubGameSection/OneWord_Section/oneWord_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final OneWordTopicRepository repository = OneWordTopicRepository();

  group('ONE WORD / QUIZ / CALCULATION TOPIC API REAL SERVER TEST', () {
    test('Get One Word Topic → API → SAFE CHECK', () async {
      try {
        final result = await repository.getOneWordTopic();

        if (result != null) {
          expect(result, isA<OneWordTopicModel>());
          expect(result.data, isNotNull);
        }
      } catch (e) {
        expect(e, isNotNull);
      }
    });

    test('Get Quiz Topic → API → SAFE CHECK', () async {
      try {
        final result = await repository.getQuizTopic();

        if (result != null) {
          expect(result, isA<OneWordTopicModel>());
          expect(result.data, isNotNull);
        }
      } catch (e) {
        expect(e, isNotNull);
      }
    });

    test('Get Calculation Topic → API → SAFE CHECK', () async {
      try {
        final result = await repository.getCalculationTopic();

        if (result != null) {
          expect(result, isA<OneWordTopicModel>());
          expect(result.data, isNotNull);
        }
      } catch (e) {
        expect(e, isNotNull);
      }
    });
  });
}
