import 'package:flutter/material.dart';

import 'database.dart';
import 'form_loader.dart';
import 'inventory_bot.dart';
import 'questionnaire_page.dart';
import 'server_settings_page.dart';
import 'sync_service.dart';



class HomePage extends StatefulWidget {

  const HomePage({super.key});


  @override
  State<HomePage> createState() =>
      _HomePageState();

}




class _HomePageState extends State<HomePage> {


  int pendingCount = 0;



  @override
  void initState() {

    super.initState();

    _loadPending();

  }




  Future<void> _loadPending() async {


    final inventories =
        await InventoryDatabase.instance
            .getPendingInventories();



    setState(() {

      pendingCount =
          inventories.length;

    });

  }





  Future<void> _newInventory() async {


    final form =
        await FormLoader
            .loadColdRoomForm();



    final bot =
        InventoryBot(form);




    await Navigator.push(


      context,


      MaterialPageRoute(


        builder:(context)=>

            QuestionnairePage(

              bot:bot,

            ),


      ),


    );



    // recharge le compteur au retour
    await _loadPending();

  }






  void _openServerSettings() {


    Navigator.push(


      context,


      MaterialPageRoute(


        builder: (_) =>

            const ServerSettingsPage(),


      ),


    );


  }






  Future<void> _sync() async {


    try {


      await SyncService.synchronize();



      await _loadPending();



      if (!mounted) return;



      ScaffoldMessenger.of(context)
          .showSnackBar(


        const SnackBar(

          content:

              Text(

                "Synchronisation terminée",

              ),

        ),


      );


    }

    catch (e) {


      if (!mounted) return;



      ScaffoldMessenger.of(context)
          .showSnackBar(


        SnackBar(

          content:

              Text(

                "Erreur : $e",

              ),

        ),


      );


    }


  }







  @override
  Widget build(BuildContext context) {


    return Scaffold(


      appBar: AppBar(


        title:

          const Text(

            "Butcher Shop Inventory",

          ),


      ),





      body: Padding(


        padding:

          const EdgeInsets.all(20),





        child: Column(


          children:[





            Text(


              "Inventaires non synchronisés : $pendingCount",


              style:

                const TextStyle(

                  fontSize:18,

                ),


            ),





            const SizedBox(height:40),





            SizedBox(


              width:

                double.infinity,





              child: ElevatedButton(


                onPressed:

                  _newInventory,





                child:

                  const Text(

                    "Nouvel inventaire",

                  ),


              ),


            ),





            const SizedBox(height:20),





            SizedBox(


              width:

                double.infinity,





              child: ElevatedButton(


                onPressed:

                  _sync,





                child:

                  const Text(

                    "Synchroniser",

                  ),


              ),


            ),





            const SizedBox(height:20),





            SizedBox(


              width:

                double.infinity,





              child: OutlinedButton(


                onPressed:

                  _openServerSettings,





                child:

                  const Text(

                    "Configuration serveur",

                  ),


              ),


            ),





          ],


        ),


      ),


    );


  }


}