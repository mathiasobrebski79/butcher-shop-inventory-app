import 'models.dart';


class InventoryBot {

  final InventoryForm form;


  List<Map<String, dynamic>> items = [];


  Map<String, dynamic> currentItem = {};


  int currentQuestionIndex = 0;


  InventoryBot(this.form);



  Question get currentQuestion {

    return form.questions[currentQuestionIndex];

  }



  bool get isFinished {

    return currentQuestionIndex >= form.questions.length;

  }



  void answer(dynamic value) {

    currentItem[currentQuestion.field] = value;

  }



  void nextQuestion() {

    currentQuestionIndex++;

  }



  void validateCurrentItem() {

    items.add(currentItem);

    currentItem = {};

    currentQuestionIndex = 0;

  }


  void resetItem() {

    currentItem = {};

    currentQuestionIndex = 0;

  }

}