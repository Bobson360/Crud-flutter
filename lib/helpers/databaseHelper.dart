import 'dart:async';
import 'dart:io';
import 'package:contato/models/contato.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {

  static DatabaseHelper _databaseHelper;
  static Database _database;

  // Definição das colunas na tabela
  String contatoTable = 'contato';
  String colId = 'id';
  String colName = 'name';
  String colEmail = 'email';
  String colImage = 'image';

  // Construtor nomeado para criar instancia da classe
  DatabaseHelper._createInstance();

  factory DatabaseHelper() {

    if(_databaseHelper == null ) {
      // executado somente uma vez
      _databaseHelper = DatabaseHelper._createInstance();
    }

    return _databaseHelper;
  } 

  Future<Database> get database async {
    if (_database == null ) {
      _database = await initializeDatabase();
    }

    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'contato.db';
    var contatoDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return contatoDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
                      'CREATE TABLE '
                      '$contatoTable('
                                      '$colId INTEGER PRIMARY KEY AUTOINCREMENT, '
                                      '$colName TEXT,  '
                                      '$colEmail TEXT,'
                                      '$colImage TEXT)'
                    );
  }

  // Incluir um objeto contato no banco de dados
  Future<int> insertContato(Contato contato) async {
    Database db = await this.database;

    var resultado = await db.insert(contatoTable, contato.toMap());

    return resultado;
  }

  Future<Contato> getContato(int id) async {
    Database db = await this.database;
    List<Map> maps = await db.query(contatoTable, 
    columns: [colId, colName, colEmail, colImage],
    where: "$colId = ?",
    whereArgs: [id]);

    if(maps.length > 0) {
      return Contato.fromMap(maps.first);
    }else{
      return null;
    }
  }

  Future<List> getContatos() async {
     Database db = await this.database;
     var resultado = await db.query(contatoTable);

     List<Contato> lista = resultado.isNotEmpty ? resultado.map(
        (c) => Contato.fromMap(c)
      ).toList() : [];

    return lista;
  }

  // UPDATE
  Future<int> updadeContato(Contato contato) async {
    var db = await this.database;

    var resultado = await db.update(contatoTable, contato.toMap(),
      where: '$colId = ?',
      whereArgs: [contato.id]);

    return resultado;
  }

  //DELETE
  Future<int> deleteContato(int id) async {
    var db = await this.database;

    var resultado = await db.delete(contatoTable,
      where: '$colId = ?',
      whereArgs: [id]);

    return resultado;
  }

  //Obtem o numero de objetos no banco
  Future<int> getCount() async {
    var db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery(
      'SQL COUNT (*) from $contatoTable');

      int resultado = Sqflite.firstIntValue(x);

      return resultado;
  }

  Future addCol(String col) async{
    Database db = await this.database;
    db.execute('ALTER TABLE $contatoTable ADD COLUMN $col;');
  }

  Future close() async {
    Database db = await this.database;
    
    db.close();
  }

  

}