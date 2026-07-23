import 'package:flutter/material.dart';

import 'form_loader.dart';
import 'inventory_bot.dart';
import 'questionnaire_page.dart';



class HomePage extends StatelessWidget {

  const HomePage({super.key});


  @override
  Widget build(BuildContext context) {


    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "Butcher Shop Inventory",
        ),

      ),


      body: Center(

        child: Column(

          mainAxisAlignment:
              MainAxisAlignment.center,


          children: [


            const Text(

              "Inventaires",

              style: TextStyle(

                fontSize:28,

                fontWeight:
                    FontWeight.bold,

              ),

            ),


            const SizedBox(height:40),



            ElevatedButton(

              style:
                  ElevatedButton.styleFrom(

                    padding:
                      const EdgeInsets.all(20),

                  ),


              child: const Text(

                "Nouvel inventaire",

                style:
                    TextStyle(fontSize:18),

              ),



              onPressed: () async {


                final form =
                    await FormLoader
                    .loadColdRoomForm();


                final bot =
                    InventoryBot(form);



                Navigator.push(

                  context,

                  MaterialPageRoute(

                    builder:(context)=>

                      QuestionnairePage(

                        bot:bot,

                      ),

                  ),

                );


              },

            )


          ],

        ),

      ),

    );


  }


}