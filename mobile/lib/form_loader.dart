import 'dart:convert';
import 'package:flutter/services.dart';
import 'models.dart';


class FormLoader {

  static Future<InventoryForm> loadColdRoomForm() async {

    final jsonString =
        await rootBundle.loadString(
            'assets/forms/cold_room.json'
        );

    final jsonData = json.decode(jsonString);

    return InventoryForm.fromJson(jsonData);

  }
}