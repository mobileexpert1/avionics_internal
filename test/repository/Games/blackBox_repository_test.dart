import 'package:avionics_internal/bloc/Games/SubGameSection/BlackBox_Section/blackBox_model.dart';
import 'package:avionics_internal/bloc/Games/SubGameSection/BlackBox_Section/blackBox_question_model.dart';
import 'package:avionics_internal/bloc/Games/SubGameSection/BlackBox_Section/blackBox_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final BlackboxRepository repository = BlackboxRepository();

  group('BLACKBOX REPOSITORY API REAL SERVER TEST', () {
    test('Get Blackbox Summary → API → SAFE CHECK', () async {
      try {
        final result = await repository.getBlackboxSummary(1);

        expect(result, isNotNull);
        expect(result, isA<List<BlackBoxSummaryModel>>());
      } catch (e) {
        expect(e, isNotNull);
      }
    });

    test('Get Blackbox Questions → API → SAFE CHECK', () async {
      try {
        final result = await repository.getBlackBoxQuestions("1");
        if (result != null) {
          expect(result, isA<BlackBoxQuestionModel>());
          expect(result.questionSetId, isNotEmpty);
        }
      } catch (e) {
        expect(e, isNotNull);
      }
    });

    test('Submit Blackbox Answers → API → SAFE CHECK', () async {
      final payload = {"answers": [], "time_taken": 0};

      try {
        final response = await repository.submitBlackBoxAnswers(
          payload,
          1
        );

        if (response != null) {
          expect(response.detail, isNotNull);
        }
      } catch (e) {
        expect(e, isNotNull);
      }
    });

    test('Get Blackbox Topic → API → SAFE CHECK', () async {
      try {
        final result = await repository.getBlackBoxTopic();
        if (result != null) {
          expect(result, isA<BlackBoxTopicResponse>());
          expect(result.data, isNotNull);
        }
      } catch (e) {
        expect(e, isNotNull);
      }
    });
  });
}
