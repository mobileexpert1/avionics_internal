class BlackBoxQuestionModel {
  String? game;
  String? level;
  String? difficulty;
  List<CategoryTypes>? categoryTypes;

  BlackBoxQuestionModel(
      {this.game, this.level, this.difficulty, this.categoryTypes});

  BlackBoxQuestionModel.fromJson(Map<String, dynamic> json) {
    game = json['game'];
    level = json['level'];
    difficulty = json['difficulty'];
    if (json['category_types'] != null) {
      categoryTypes = <CategoryTypes>[];
      json['category_types'].forEach((v) {
        categoryTypes!.add(new CategoryTypes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['game'] = this.game;
    data['level'] = this.level;
    data['difficulty'] = this.difficulty;
    if (this.categoryTypes != null) {
      data['category_types'] =
          this.categoryTypes!.map((v) => v.toJson()).toList();
    }
    return data;
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

  Questions(
      {this.question, this.explanation, this.title, this.options, this.answer});

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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question'] = this.question;
    data['explanation'] = this.explanation;
    data['title'] = this.title;
    if (this.options != null) {
      data['options'] = this.options!.map((v) => v.toJson()).toList();
    }
    data['answer'] = this.answer;
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
