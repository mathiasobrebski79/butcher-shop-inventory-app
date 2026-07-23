class InventoryForm {
  final String title;
  final List<Question> questions;

  InventoryForm({
    required this.title,
    required this.questions,
  });

  factory InventoryForm.fromJson(Map<String, dynamic> json) {
    return InventoryForm(
      title: json['title'],
      questions: (json['questions'] as List)
          .map((q) => Question.fromJson(q))
          .toList(),
    );
  }
}


class Question {
  final String field;
  final String label;
  final String type;
  final bool required;
  final List<String>? options;

  Question({
    required this.field,
    required this.label,
    required this.type,
    required this.required,
    this.options,
  });


  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      field: json['field'],
      label: json['label'],
      type: json['type'],
      required: json['required'] ?? false,
      options: json['options'] != null
          ? List<String>.from(json['options'])
          : null,
    );
  }
}