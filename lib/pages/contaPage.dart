import 'dart:io';

import 'package:contato/models/contato.dart';
import 'package:flutter/material.dart';

class ContatoPage extends StatefulWidget {
  final Contato contato;
  ContatoPage({this.contato});

  @override
  _ContatoPageState createState() => _ContatoPageState();
}

class _ContatoPageState extends State<ContatoPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _nameFocus = FocusNode();

  bool editado = false;
  Contato _editaContato;

  @override
  void initState() {
    super.initState();

    if (widget.contato == null) {
      _editaContato = Contato(0, '', '', null);
    } else {
      _editaContato = Contato.fromMap(widget.contato.toMap());

      _nameController.text = _editaContato.name;
      _emailController.text = _editaContato.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
            _editaContato.name == '' ? 'Novo Contato' : _editaContato.name),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_editaContato.name != null && _editaContato.name.isNotEmpty) {
            Navigator.pop(context, _editaContato);
          } else {
            _exibeAviso();
            FocusScope.of(context).requestFocus(_nameFocus);
          }
        },
        child: Icon(Icons.save),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: Container(
                width: 70.0,
                height: 70.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: (_editaContato.image != null &&
                            _editaContato.image.isNotEmpty)
                        ? FileImage(File(_editaContato.image))
                        : AssetImage('images/user.png'),
                  ),
                ),
              ),
            ),
            TextField(
              controller: _nameController,
              focusNode: _nameFocus,
              decoration: InputDecoration(labelText: 'Nome'),
              onChanged: (text) {
                editado = true;
                setState(() {
                  _editaContato.name = text;
                });
              },
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              onChanged: (text) {
                editado = true;
                _editaContato.email = text;
              },
              keyboardType: TextInputType.emailAddress,
            )
          ],
        ),
      ),
    );
  }

  void _exibeAviso() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text('Nome'),
          content: new Text('Informe o nome do contato'),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Fechar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
