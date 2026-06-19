class BlackBoxQuestionModel {
  String? questionSetId;
  String? game;
  String? level;
  String? difficulty;
  List<CategoryTypes>? categoryTypes;

  BlackBoxQuestionModel({
    this.questionSetId,
    this.game,
    this.level,
    this.difficulty,
    this.categoryTypes,
  });

  BlackBoxQuestionModel.fromJson(Map<String, dynamic> json) {
    questionSetId = json['set_id']?.toString();
    game = json['game']?.toString();
    level = json['level']?.toString();
    difficulty = json['difficulty']?.toString();

    if (json['category_types'] != null) {
      categoryTypes = (json['category_types'] as List)
          .map((e) => CategoryTypes.fromJson(e))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'set_id': questionSetId,
      'game': game,
      'level': level,
      'difficulty': difficulty,
      'category_types':
      categoryTypes?.map((e) => e.toJson()).toList(),
    };
  }
}

class CategoryTypes {
  String? type;
  String? name;
  List<Questions>? questions;

  CategoryTypes({this.type, this.name, this.questions});

  CategoryTypes.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    name = json['name'];
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(new Questions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['name'] = this.name;
    if (this.questions != null) {
      data['questions'] = this.questions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Questions {
  String? question;
  String? explanation;
  String? title;
  List<Options>? options;
  String? answer;
  String? questionId;

  Questions(
      {this.question, this.explanation, this.title, this.options, this.answer, this.questionId});

  Questions.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    explanation = json['explanation'];
    title = json['title'];
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(new Options.fromJson(v));
      });
    }
    answer = json['answer'];
    questionId = json['question_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['question'] = question;
    data['explanation'] = explanation;
    data['title'] = title;
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    data['answer'] = answer;
    data['question_id'] = questionId;
    return data;
  }
}

class Options {
  String? label;
  String? value;

  Options({this.label, this.value});

  Options.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['value'] = this.value;
    return data;
  }
}
