import 'package:flutter/material.dart';

import 'inventory_bot.dart';


class SummaryPage extends StatelessWidget {

  final InventoryBot bot;


  const SummaryPage({
    super.key,
    required this.bot,
  });



  @override
  Widget build(BuildContext context) {


    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "Résumé inventaire",
        ),

      ),


      body: Padding(

        padding: const EdgeInsets.all(16),


        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,


          children: [


            Text(

              "${bot.items.length} article(s)",

              style: const TextStyle(

                fontSize:22,

                fontWeight:
                    FontWeight.bold,

              ),

            ),


            const SizedBox(height:20),



            Expanded(

              child: ListView.builder(

                itemCount:
                    bot.items.length,


                itemBuilder:
                    (context,index){


                  final item =
                      bot.items[index];


                  return Card(

                    child: Padding(

                      padding:
                          const EdgeInsets.all(12),


                      child: Column(

                        crossAxisAlignment:
                            CrossAxisAlignment.start,


                        children: item.entries
                            .map(

                              (entry)=>Text(

                                "${entry.key} : ${entry.value}",

                              ),

                            )
                            .toList(),

                      ),

                    ),

                  );


                },

              ),

            ),



            SizedBox(

              width:
                  double.infinity,


              child: ElevatedButton(


                onPressed:(){


                  ScaffoldMessenger
                      .of(context)
                      .showSnackBar(

                    const SnackBar(

                      content:Text(

                        "Inventaire validé (prochaine étape : SQLite)",

                      ),

                    ),

                  );


                },


                child: const Text(

                  "Valider l'inventaire",

                ),

              ),

            )

          ],

        ),

      ),

    );


  }


}