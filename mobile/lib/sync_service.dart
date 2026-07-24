import 'dart:convert';

import 'package:http/http.dart' as http;

import 'database.dart';
import 'settings.dart';



class SyncService {


  static Future<void> synchronize() async {


    final serverUrl =
        await AppSettings.getServerUrl();



    if (serverUrl == null) {

      throw Exception(
        "Adresse serveur non configurée",
      );

    }




    final inventories =
        await InventoryDatabase.instance
            .getPendingInventories();




    if (inventories.isEmpty) {

      return;

    }




    final payload =
        inventories.map((inventory) {


      final data =
          jsonDecode(
            inventory["data_json"],
          );



      return {

        "uuid":
            inventory["uuid"],


        "created_at":
            inventory["created_at"],


        "form_type":
            inventory["form_type"],


        "items":
            data["items"],

      };


    }).toList();



    print("========== PAYLOAD ==========");
    print(const JsonEncoder.withIndent("  ").convert(payload));
    print("============================");

    final response =
        await http.post(


      Uri.parse(
        "$serverUrl/sync",
      ),



      headers: {

        "Content-Type":
            "application/json",

      },



      body:

          jsonEncode(

            payload,

          ),


    );





    if (response.statusCode != 200) {


      throw Exception(

        "Erreur serveur : ${response.statusCode}",

      );


    }





    final uuids =
        inventories
            .map(
              (e) =>
                  e["uuid"] as String,
            )
            .toList();




    await InventoryDatabase.instance
        .markAsSynced(
          uuids,
        );


  }


}