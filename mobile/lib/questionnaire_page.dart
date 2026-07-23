import 'package:flutter/material.dart';

import 'models.dart';
import 'inventory_bot.dart';
import 'summary_page.dart';


class QuestionnairePage extends StatefulWidget {

  final InventoryBot bot;

  const QuestionnairePage({
    super.key,
    required this.bot,
  });


  @override
  State<QuestionnairePage> createState() =>
      _QuestionnairePageState();

}



class _QuestionnairePageState
    extends State<QuestionnairePage> {


  final TextEditingController controller =
      TextEditingController();



  String? selectedValue;



  Question get question =>
      widget.bot.currentQuestion;



  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text(
          widget.bot.form.title
        ),
      ),


      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Text(
              "Article ${widget.bot.items.length + 1}",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),


            const SizedBox(height:30),


            Text(
              question.label,
              style: const TextStyle(
                fontSize:18,
              ),
            ),


            const SizedBox(height:15),


            _buildInput(),


            const Spacer(),


            SizedBox(

              width: double.infinity,

              child: ElevatedButton(

                onPressed: _next,

                child: const Text(
                  "Suivant",
                ),

              ),

            )

          ],

        ),

      ),

    );

  }





  Widget _buildInput() {


    switch(question.type) {


      case "select":

        return DropdownButtonFormField<String>(

          value: selectedValue,

          items: question.options!
              .map(
                (value)=>DropdownMenuItem(
                  value:value,
                  child:Text(value),
                ),
              )
              .toList(),


          onChanged:(value){

            setState(() {

              selectedValue=value;

            });

          },

        );



      default:


        return TextField(

          controller:controller,

          keyboardType:
              question.type=="decimal"
              ? TextInputType.number
              : TextInputType.text,


          decoration:
              const InputDecoration(

                border:
                  OutlineInputBorder(),

              ),

        );

    }

  }





  void _next() {


    dynamic value;



    if(question.type=="select") {

      value=selectedValue;

    }

    else {

      value=controller.text;

    }



    if(question.required &&
       (value==null || value=="")) {


      ScaffoldMessenger.of(context)
          .showSnackBar(

            const SnackBar(

              content:Text(
                "Champ obligatoire",
              ),

            ),

          );


      return;

    }



    widget.bot.answer(value);



    if(widget.bot.currentQuestionIndex
        <
        widget.bot.form.questions.length - 1) {


      widget.bot.nextQuestion();


      controller.clear();

      selectedValue=null;


      setState(() {});


    }

    else {


      widget.bot.validateCurrentItem();



      _askAnotherItem();

    }

  }





  void _askAnotherItem() {


    showDialog(

      context:context,


      builder:(context)=>AlertDialog(


        title:const Text(
          "Article enregistré",
        ),


        content:const Text(
          "Ajouter un autre article ?",
        ),


        actions:[


          TextButton(

            child:const Text(
              "Non",
            ),


            onPressed:(){

              Navigator.pop(context);



              Navigator.pushReplacement(

                context,

                MaterialPageRoute(

                  builder:(context)=>
                    SummaryPage(
                      bot:widget.bot,
                    ),

                ),

              );

            },

          ),



          ElevatedButton(

            child:const Text(
              "Oui",
            ),


            onPressed:(){

              Navigator.pop(context);


              setState((){

                controller.clear();

                selectedValue=null;

              });


            },

          )

        ],

      ),

    );

  }

}