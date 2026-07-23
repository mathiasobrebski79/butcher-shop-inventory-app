import 'dart:convert';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';


class InventoryDatabase {


  static final InventoryDatabase instance =
      InventoryDatabase._init();


  static Database? _database;



  InventoryDatabase._init();



  Future<Database> get database async {

    if (_database != null) {
      return _database!;
    }


    _database = await _initDB(
      'inventories.db'
    );


    return _database!;

  }




  Future<Database> _initDB(String fileName) async {


    final dbPath =
        await getDatabasesPath();


    final path =
        join(dbPath, fileName);



    return await openDatabase(

      path,

      version: 1,

      onCreate: _createDB,

    );

  }




  Future _createDB(
      Database db,
      int version
  ) async {


    await db.execute('''

      CREATE TABLE inventories (

        id INTEGER PRIMARY KEY AUTOINCREMENT,

        uuid TEXT NOT NULL,

        created_at TEXT NOT NULL,

        form_type TEXT NOT NULL,

        data_json TEXT NOT NULL,

        synced INTEGER NOT NULL DEFAULT 0

      )

    ''');


  }




  Future<void> saveInventory({

    required String formType,

    required Map<String,dynamic> data,

  }) async {


    final db =
        await instance.database;



    await db.insert(

      'inventories',

      {

        'uuid':
            const Uuid().v4(),

        'created_at':
            DateTime.now()
            .toIso8601String(),


        'form_type':
            formType,


        'data_json':
            jsonEncode(data),


        'synced':
            0,

      },

    );

  }



  Future<List<Map<String,dynamic>>>
      getPendingInventories() async {


    final db =
        await instance.database;



    return await db.query(

      'inventories',

      where:
          'synced = ?',

      whereArgs:
          [0],

      orderBy:
          'created_at DESC',

    );

  }


}