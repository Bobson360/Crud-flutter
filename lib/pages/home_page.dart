import 'dart:io';

import 'package:contato/helpers/databaseHelper.dart';
import 'package:contato/models/contato.dart';
import 'package:contato/pages/contaPage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper db = DatabaseHelper();

  List<Contato> contatos = List<Contato>();

  @override
  void initState() {
    super.initState();
    // Contato c = Contato(20, 'Robson', 'bobson278@gmail.com', null);
    // db.insertContato(c);
    // db.addCol('image');
    // Contato c2 = Contato(2, 'Cris', 'crischaves278@gmail.com');
    // db.insertContato(c2);

    _exibeTodosContatos();
  }

  void _exibeTodosContatos() {
    db.getContatos().then((lista) {
      setState(() {
        contatos = lista;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agenda'),
        backgroundColor: Colors.blue,
        centerTitle: true,
        actions: <Widget>[],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _exibeContatoPage();
        },
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: contatos.length,
        itemBuilder: (context, index) {
          return _listaContatos(context, index);
        },
      ),
    );
  }

  _listaContatos(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: 70.0,
                height: 70.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: (contatos[index].image != null &&
                            contatos[index].image.isNotEmpty)
                        ? FileImage(File(contatos[index].image))
                        : AssetImage('images/user.png'),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      contatos[index].name ?? "",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      contatos[index].email ?? "",
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _confirmaExclusao(context, contatos[index].id, index);
                },
              )
            ],
          ),
        ),
      ),
      onTap: () {
        _exibeContatoPage(contato: contatos[index]);
      },
    );
  }

  void _exibeContatoPage({Contato contato}) async {
    final contatoRecebido = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContatoPage(contato: contato),
      ),
    );
    if (contatoRecebido != null) {
      if (contato != null) {
        print(contato.name);
        await db.updadeContato(contatoRecebido);
      } else {
        await db.insertContato(contatoRecebido);
      }
      _exibeTodosContatos();
    }
  }
  void _confirmaExclusao(BuildContext context, int contatoId, index) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ecluir contato'),
          content: Text('confirma a exclusão do contato'),
          actions: <Widget>[
            FlatButton(
                child: Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            FlatButton(
              child: Text('Excluir'),
              onPressed: () {
                setState(() {
                  contatos.removeAt(index);
                  db.deleteContato(contatoId);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
}
}


