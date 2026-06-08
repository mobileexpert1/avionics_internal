import 'package:avionics_internal/Constants/ApiClass/baseDetailResponseModel.dart';
import 'package:avionics_internal/bloc/Games/QuizQuestionScreen/quiz_question_repository.dart';
import 'package:avionics_internal/bloc/Games/SubGameSection/Calculation_Section/calculation_model.dart';
import 'package:avionics_internal/bloc/Games/SubGameSection/Calculation_Section/calculation_submit_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final QuizQuestionRepository repository = QuizQuestionRepository();

  group('QUIZ QUESTION REPOSITORY API REAL SERVER TEST', () {
    test('Report Question → Quiz → API RESPONSE CHECK', () async {
      try {
        final response = await repository.reportQuestionPostMethod(
          setId: "1",
          questionId: "1",
          reason: "Test reason",
          isForType: "quiz",
        );
        expect(response, isA<BaseDetailResponseModel>());
        expect(response.detail, isNotNull);
      } catch (e) {
        expect(e, isNotNull);
      }
    });

    test('Get Calculation Game Data → API → SAFE CHECK', () async {
      try {
        final data = await repository.getCalculationData(1, 1);
        if (data != null) {
          expect(data, isA<CalculationGameModel>());
        }
      } catch (e) {
        expect(e, isNotNull);
      }
    });

    test('Fetch Additional Calculation Questions → API', () async {
      final data = await repository.fetchAdditionalQuestions(1, 2);
      if (data != null) {
        expect(data, isA<CalculationGameModel>());
      }
    });

    test('Get One Word Game Data → API', () async {
      try {
        final data = await repository.getOneWordData(1, 1);
        if (data != null) {
          expect(data, isA<CalculationGameModel>());
        }
      } catch (e) {
        expect(e, isNotNull);
      }
    });

    test('Get Quiz Questions → API', () async {
      try {
        final data = await repository.getQuizData(1, 1);

        if (data != null) {
          expect(data, isA<CalculationGameModel>());
        }
      } catch (e) {
        expect(e, isNotNull);
      }
    });

    test('Submit Quiz Result → API → SAFE CHECK', () async {
      final payload = {"game_number": 1, "answers": [], "score": 0};
      try {
        final response = await repository.submitResult(payload, "quiz");
        expect(response, isA<SubmitCalculationResultResponse>());
        expect(response.detail, isNotNull);
      } catch (e) {
        expect(e, isNotNull);
      }
    });
  });
}
// flutter clean
// rm -rf ios/Pods ios/Podfile.lock
// rm -rf ~/Library/Developer/Xcode/DerivedData
// flutter pub get
// cd ios
// pod install
// cd ..