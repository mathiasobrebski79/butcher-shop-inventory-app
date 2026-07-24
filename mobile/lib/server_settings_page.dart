import 'package:flutter/material.dart';

import 'settings.dart';



class ServerSettingsPage extends StatefulWidget {

  const ServerSettingsPage({
    super.key,
  });


  @override
  State<ServerSettingsPage> createState() =>
      _ServerSettingsPageState();

}




class _ServerSettingsPageState
    extends State<ServerSettingsPage> {


  final ipController =
      TextEditingController();


  final portController =
      TextEditingController(
        text: "8000",
      );



  @override
  void initState() {

    super.initState();

    _load();

  }





  Future<void> _load() async {


    final url =
        await AppSettings.getServerUrl();



    if (url != null) {

      final uri =
          Uri.parse(url);


      ipController.text =
          uri.host;


      portController.text =
          uri.port.toString();

    }

  }






  Future<void> _save() async {


    await AppSettings.saveServerConfig(

      ip:
          ipController.text.trim(),

      port:
          portController.text.trim(),

    );



    if (!mounted) return;


    ScaffoldMessenger.of(context)
        .showSnackBar(

      const SnackBar(

        content:
            Text(
              "Configuration enregistrée",
            ),

      ),

    );

  }






  @override
  Widget build(BuildContext context) {


    return Scaffold(

      appBar:
          AppBar(

            title:
                const Text(
                  "Serveur",
                ),

          ),



      body:
          Padding(

            padding:
                const EdgeInsets.all(16),


            child:
                Column(

              children: [


                TextField(

                  controller:
                      ipController,


                  decoration:
                      const InputDecoration(

                    labelText:
                        "Adresse IP du PC",

                    hintText:
                        "192.168.1.25",

                  ),

                ),



                TextField(

                  controller:
                      portController,


                  keyboardType:
                      TextInputType.number,


                  decoration:
                      const InputDecoration(

                    labelText:
                        "Port",

                  ),

                ),



                const SizedBox(
                  height: 20,
                ),



                ElevatedButton(

                  onPressed:
                      _save,


                  child:
                      const Text(
                        "Enregistrer",
                      ),

                ),

              ],

            ),

          ),

    );

  }


}