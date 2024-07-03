import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

class DataBase_SQLite {
  static Database? _db;

  // init : create database NAME .
  initialDB() async {
    String databasepath = await getDatabasesPath();
    String path = join(
        databasepath, 'gallery.db'); // database name in = 'databasepath/amine'
    Database mydb = await openDatabase(path, onCreate: onCreate, version: 1);
    print("database 'gallery' initialised succesfully");
    return mydb;
  }

  // list of databases files
  Future<List<String>> getDatabaseFiles() async {
    String databasesPath = await getDatabasesPath();
    Directory directory = Directory(databasesPath);
    List<FileSystemEntity> files = directory.listSync();
    List<String> databaseFiles = [];
    for (var file in files) {
      if (file is File && file.path.endsWith('.db')) {
        databaseFiles.add(file.uri.pathSegments.last);
      }
    }
    return databaseFiles;
  }

  // list of databases
  void listDataBases() async {
    List<String> databaseFiles = await getDatabaseFiles();
    // Now 'databaseFiles' contains the list of SQLite database files in the specified directory
    print(databaseFiles);
  }

  // delete database
  Future<void> deleteDatabaseFile(String databaseFileName) async {
    String databasesPath = await getDatabasesPath();
    String databaseFilePath = '$databasesPath/$databaseFileName';

    File databaseFile = File(databaseFilePath);

    if (await databaseFile.exists()) {
      await databaseFile.delete();
      print('Database file $databaseFileName deleted.');
    } else {
      print('Database file $databaseFileName not found.');
    }
  }

  // onCreate : create database TABLES .
  onCreate(Database db, int version) async {
    // fn to create sqlite tables .
    await db.execute(
        "CREATE TABLE images (id INTEGER PRIMARY KEY , imagePath TEXT NOT NULL);");
    print("create database table 'images(id,imagePath)' successfuly");
  }

  // initialisation database : check database & tables creations .
  Future<Database?> getdb() async {
    if (_db == null) {
      _db = await initialDB();
      return _db;
    } else {
      return _db;
    }
  }

  // --------------------- CRUD API -------------------------------------

  // 1 - SELECT
  Future<List<Map>> ReadData(String sqlQuery) async {
    Database? mydb = await getdb();
    List<Map> response = await mydb!.rawQuery(sqlQuery);
    return response;
  }

  // 2 - INSERT
  Future<int> InsertData(String sqlQuery) async {
    Database? mydb = await getdb();
    int response = await mydb!.rawInsert(sqlQuery);
    return response;
  }

  // 3 - UPDATE
  Future<int> UpdateData(String sqlQuery) async {
    Database? mydb = await getdb();
    int response = await mydb!.rawUpdate(sqlQuery);
    return response;
  }

  // 4 - Delete
  Future<int> DeleteData(String sqlQuery) async {
    Database? mydb = await getdb();
    int response = await mydb!.rawDelete(sqlQuery);
    return response;
  }

  // 5 - close database

  void closeDatabase() {
    if (_db != null && _db!.isOpen) {
      _db!.close();
      print("database is closed");
    }
  }

  // ----------------- CRUD API IMPLEMENTATION ---------------------------

  // replace for ex : sqlquery = delete from 'table_var' by id = 'id_var'

  // 1 - SELECT

  Future<List<Map>> API_Select(String tableName) async {
    String selectQuery = "Select * from " + tableName;
    List<Map> response = await ReadData(selectQuery);
    print("-- execute query = " + selectQuery);
    print(response);
    return response;
  }

  // select nbr of row (max images in gallery = x '30')
  Future<List<Map>> API_GetNumberImages(String tableName) async {
    String select_img_nbr_Query = "Select count(*) from " + tableName;
    List<Map> response = await ReadData(select_img_nbr_Query);
    print("-- execute query = " + select_img_nbr_Query);
    print(response);
    return response;
  }

  // 2 - INSERT

  Future<int> API_Insert(
      String tableName, String col1Name, String val1Name) async {
    String insertQuery = "insert into " +
        tableName +
        " (" +
        col1Name +
        ") VALUES ('" +
        val1Name +
        "');";
    int response = await InsertData(insertQuery);
    print("-- execute query = " +
        insertQuery +
        " and returned : " +
        response.toString());
    // example : insert into 'tasks' (title) VALUES ('title1')
    return response;
  }

  // 3 - UPDATE
  Future<int> API_Update(
      String tableName, String col1Name, String val1Name, int id) async {
    String updateQuery = "update " +
        tableName +
        " set " +
        col1Name +
        " = '" +
        val1Name +
        "' where id = " +
        id.toString();
    int reponse = await UpdateData(updateQuery);
    print("-- execute query = " + updateQuery);
    // example : update title set title = 'task1' where id = 5
    return reponse;
  }

  // 4 - DELETE

  Future<int> API_Delete(String tableName, int id) async {
    String deleteQuery =
        "delete from '" + tableName + "' where id = " + id.toString();
    int reponse = await UpdateData(deleteQuery);
    print("-- execute query = " + deleteQuery);
    // example : delete from 'tasks' where id = 2
    return reponse;
  }

  // get nbr of rows
  Future<int?> API_GetNumberRows(String tableName) async {
    Database? mydb = await getdb();
    int? response = Sqflite.firstIntValue(
        await mydb!.rawQuery("select count(*) from " + tableName));
    print("----- NBR OF ROWS = " + response.toString());
    return response;
  }
}
